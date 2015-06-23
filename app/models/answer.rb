class Answer < ActiveRecord::Base
  belongs_to :question, -> { order(created_at: :desc) }
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 15000 } 
end
