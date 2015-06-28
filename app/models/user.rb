class User < ActiveRecord::Base
  user_regex = /\A[a-zA-z0-9][a-zA-z0-9 _\-.']/
  validates :name, presence: true, length: { minimum: 3, maximum: 30 }, format: { with: user_regex }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
