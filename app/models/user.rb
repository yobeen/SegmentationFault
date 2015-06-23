class User < ActiveRecord::Base
  has_many :questions, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end
