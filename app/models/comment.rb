class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :post

  has_many :reports, dependent: :destroy

  validates :body, presence: true

  def author_name
    return nil if post.group.nil?
    if user.present?
      user.username
    else
      "退会済みユーザー"
    end
  end
end
