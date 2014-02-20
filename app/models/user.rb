class User < ActiveRecord::Base
  has_many :todos


  validates :name, presence: true
  validates :email, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
end
