class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #todo optimize db requests
  has_many :todos, :dependent => :delete_all
  has_many :contexts, :dependent => :delete_all
  has_many :projects, :dependent => :delete_all

  after_create do |user|
    user.contexts.create_defaults
  end

  #validates :name, presence: true
  validates :email, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
end
