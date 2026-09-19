class Report < ApplicationRecord
  belongs_to :new_user
  has_one_attached :file

  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :start_date, :end_date, presence: true
  validate :end_date_not_before_start_date

  def date_range
    start_date.beginning_of_day..end_date.end_of_day
  end

  def filename
    "transaction_report_#{new_user_id}_#{start_date}_#{end_date}.xlsx"
  end

  private

  def end_date_not_before_start_date
    return if start_date.blank? || end_date.blank?
    return if end_date >= start_date

    errors.add(:end_date, "must be on or after the start date")
  end
end
