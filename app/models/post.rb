class Post < ActiveRecord::Base
  belongs_to :user

  # VALID_URL_REGEX = /\Ahttps?:\/\/(www.)?(.*)\.(.*)[^\/]\z/

  validates :name, :url, :user, presence: true
  validates :name, length: { minimum: 5 }
  validates :name, uniqueness: { case_sensitive: false }
  # validates :url, format: { with: VALID_URL_REGEX }
end
