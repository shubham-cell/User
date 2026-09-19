class ReportsController < ApplicationController
  before_action :require_login
  before_action :set_report, only: [:show, :download]

  def index
    @reports = current_user.reports.order(created_at: :desc)
  end

  def new
    @report = current_user.reports.new(
      start_date: 30.days.ago.to_date,
      end_date: Date.current
    )
  end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      ReportWorker.perform_async(@report.id)
      redirect_to @report, notice: "Report generation started. This page will update when it is ready."
    else
      flash.now[:alert] = @report.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def download
    unless @report.completed? && @report.file.attached?
      redirect_to @report, alert: "The report file is not ready yet."
      return
    end

    redirect_to rails_blob_path(@report.file, disposition: "attachment")
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
