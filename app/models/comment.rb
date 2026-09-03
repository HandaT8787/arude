class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post

  has_many :reports, dependent: :destroy

  validates :body, presence: true
end
