class User < ActiveRecord::Base
  has_many :posts

  before_validation :strip_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :username, :email, presence: true
  validates :username, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX }

  def strip_email
    self.email = email.strip unless email.nil?
  end
end
