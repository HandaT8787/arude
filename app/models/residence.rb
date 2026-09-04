class Residence < ApplicationRecord
  belongs_to :user

  validates :prefecture, presence: true
  validates :city, presence: true
  validates :started_on, presence: true

  scope :current, -> { where(ended_on: nil) }

  def years_at(date = Date.current)
    end_date = ended_on || date
    ((end_date - started_on).to_i / 365.25).floor
  end
end
