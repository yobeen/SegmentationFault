class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :content, presence: true, length: { maximum: 15000 }

  def accept
	  question.answers.update_all(accepted: false)
	  update(accepted: true)
  end
end
