class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :test_user
  #todo optimize db requests
  has_many :todos, :dependent => :delete_all
  has_many :contexts, :dependent => :delete_all
  has_many :projects, :dependent => :delete_all

  after_create :create_defaults

  validates :email, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  def create_defaults
    if contexts.count == 0
      contexts.create([{name: 'Home'},
                       {name: 'Office'},
                       {name: 'Errands'},
                       {name: 'Phone'},
                       {name: 'Computer'}])
      unless test_user
        todos.create(title: 'Welcome to One More GTD',
                     content: "This is GTD style task manager\n"+
                         "Click to \"Create new\" to create new task.",
                     kind: 'next',
                     prior: 3)
        todos.create(title: 'Drag and Drop',
                     content: "Drag and drop todos with mouse to manage them",
                     kind: 'next',
                     prior: 2)
        todos.create(title: 'Edit todos',
                     content: "Click on todo header to edit todo content.\n Also you can create project from todo",
                     kind: 'next',
                     prior: 2)
        todos.create(title: 'Edit todos',
                     content: "Use arrow buttons on the right to change todo prior",
                     kind: 'next',
                     prior: 2)
      end
    end
  end

end
