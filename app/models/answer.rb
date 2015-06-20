class Answer < ActiveRecord::Base
  belongs_to :question, -> { order(created_at: :desc) }
  
  validates :content, presence: true, length: { maximum: 15000 } 
end
