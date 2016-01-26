class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? },
                                allow_destroy: true

  acts_as_votable

  validates :content, presence: true, length: { maximum: 15000 }

  def accept
		Answer.transaction do
		  question.answers.update_all(accepted: false)
		  update!(accepted: true)
		end
  end

  def rating
    get_upvotes.size - get_downvotes.size
  end
end
