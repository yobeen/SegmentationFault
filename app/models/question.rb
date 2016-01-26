class Question < ActiveRecord::Base
  has_many :answers, -> { order(accepted: :desc, created_at: :desc) }, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  acts_as_votable

  validates :title, presence: true, length: { maximum: 250 }
  validates :content, presence: true, length: { maximum: 15000 }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes[:file].blank? },
                                allow_destroy: true

  def rating
    get_upvotes.size - get_downvotes.size
  end
end
