class Residence < ApplicationRecord
  after_validation :geocode, if: -> { prefecture_changed? || city_changed? }
  belongs_to :user

  validates :prefecture, presence: true
  validates :city, presence: true
  validates :started_on, presence: true

  # 現住所
  scope :current, -> { where(ended_on: nil) }
  # 過去の住所
  scope :past, -> { where.not(ended_on: nil) }

  def years_at(date = Date.current)
    end_date = ended_on || date
    ((end_date - started_on).to_i / 365.25).floor
  end

  def full_address
    "#{prefecture}#{city}"
  end

  geocoded_by :full_address do |residence, results|
    if geo = results.first
      residence.latitude = geo.latitude
      residence.longitude = geo.longitude
    end
  end
end
