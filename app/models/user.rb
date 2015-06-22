class User < ActiveRecord::Base
  has_many :questions, -> { order(created_at: :desc) }, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end
