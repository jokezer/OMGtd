#todo context and project models has many common things that would be better to put in module
class Project < ActiveRecord::Base
  belongs_to :user
  has_many :todos, :dependent => :delete_all
  validates :user, presence: true
  validates :title,
            presence: true,
            uniqueness: {:scope => :user_id, :case_sensitive => false},
            length: {maximum: 20}
  before_validation do |c|
    c.name = c.title if c.name.blank?
    c.name = c.name.tr(' ', '_')
  end

  def prefix
    '#'
  end

  include ContextProject

  #todo it has n+1 problem
  def todos_count
    self.todos.count
  end

  #todo test if another user try to access current user scope
  def self.make_from_todo(todo)
    user = todo.user
    todo_params = todo.attributes.slice('title', 'content', 'user_id',
                                        'prior_id', 'expire')
    project = user.projects.build(todo_params)
    todo.destroy if project.save
  end

  def set_to (attr=:canceled)
    #self.todos.update_all(:status_id => TodoStatus.label_id(attr))
  end

  #to do methods
  def prior
    TodoPrior::COLLECTION[self.prior_id]
  end

end