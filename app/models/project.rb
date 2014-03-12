#todo context and project models has many common things that would be better to put in module
class Project < ActiveRecord::Base
  belongs_to :user
  has_many :todos, :dependent => :delete_all
  validates :user, presence: true
  validates :title,
            presence: true,
            uniqueness: {:scope => :user_id, :case_sensitive => false},
            length: {maximum: 20}
  before_validation { |c| c.name = c.title.tr(' ', '_') }

  #finite machines
  #to do
  # -> create_project
  # -> project(active)
  # -> cancel (all todos canceled?), project in canceled list
  # -> finish (all todos finished?), project in finished list
  # -> restore *from cancel or finish(all todos restored as well(how to save statuses?))


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
    self.todos.update_all(:status_id => TodoStatus.label_id(attr))
  end

  #to do methods
  def prior
    TodoPrior::COLLECTION[self.prior_id]
  end

  #context methods
  def self.make_group
    self.select('projects.name, projects.name as label,'+
                    ' count(todos.id) as todo_count')
    .joins('left outer join todos on todos.context_id = contexts.id')
    .group('projects.id')
    .to_a.map { |a| a.serializable_hash.symbolize_keys }
  end

  def self.by_name(name)
    self.where('lower(name) = ?', name.downcase).take
  end

  def self.by_label(label)
    self.where('lower(name) = ?', label[1..-1].downcase).take
  end

  def label
    "##{self.name}"
  end
end
