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
                     content: "This is GTD-style task manager\n"+
                         "Click to the \"Edit button\" to edit this task.",
                     kind: 'next',
                     prior: 3)
        todos.create(title: 'Create the project',
                     content: "You can create project from each task.\n To create project, click to the \"Make Project\" button in edit mode",
                     kind: 'next',
                     prior: 2)
        todos.create(title: 'Change the context of task',
                     content: "Choose the appropriate context of task, and you'll can sort your tasks by your current context",
                     kind: 'next',
                     prior: 2)
        todos.create(title: 'Change the prior of todo',
                     content: "Use arrow buttons on the right to change todo prior",
                     kind: 'next',
                     prior: 2)
        todos.create(title: 'Cycled todo',
                     content: "Some tasks need to be done many times, over and over again. Pay for the internet, for example.
Set the cycled kind for those ones, and choose the interval. You will not have to create those tasks again, it'll recreate automatically",
                     kind: 'next',
                     prior: 1)
      end
    end
  end

end
