class Answer < ActiveRecord::Base
  belongs_to :question
  
  validates :content, presence: true, length: { maximum: 15000 }
  default_scope -> { order(created_at: :desc) }
end
