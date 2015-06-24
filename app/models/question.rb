class Question < ActiveRecord::Base
  has_many :answers, -> { order(created_at: :desc) }, dependent: :destroy

  validates :title, presence: true, length: { maximum: 250 }
  validates :content, presence: true, length: { maximum: 15000 } 
end
