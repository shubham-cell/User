class ReportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :reports, retry: 3, backtrace: true

  CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

  def perform(report_id)
    report = Report.find(report_id)
    report.update!(status: :processing, error_message: nil)

    user = report.new_user
    transactions = user.transactions.where(created_at: report.date_range).order(:created_at)

    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: "Transactions") do |sheet|
      sheet.add_row ["ID", "Amount", "Date", "Type", "Description"]

      transactions.each do |transaction|
        sheet.add_row [
          transaction.id,
          transaction.amount,
          transaction.created_at.strftime("%Y-%m-%d"),
          transaction.transaction_category.to_i.zero? ? "Credit" : "Debit",
          transaction.description
        ]
      end
    end

    stream = package.to_stream
    stream.rewind

    report.file.purge if report.file.attached?
    report.file.attach(
      io: stream,
      filename: report.filename,
      content_type: CONTENT_TYPE
    )
    report.update!(status: :completed, transaction_count: transactions.size)
  rescue StandardError => e
    report&.update(status: :failed, error_message: e.message)
    raise
  end
end
