class Question < ActiveRecord::Base
  has_many :answers, -> { order(accepted: :desc, created_at: :desc) }, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { maximum: 250 }
  validates :content, presence: true, length: { maximum: 15000 }

  accepts_nested_attributes_for :attachments
end
