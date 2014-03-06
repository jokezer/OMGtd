class Context < ActiveRecord::Base
  belongs_to :user
  has_many :todos

  validates :user, presence: true
  validates :name, presence: true

  def self.create_defaults
    if self.count == 0
      self.create([{name: '@Home'},
                   {name: '@Office'},
                   {name: '@Errands'},
                   {name: '@Phone'},
                   {name: '@Computer'}])
    end
  end

  def self.make_group
    self.find(:all, :select => 'contexts.*, count(todos.id) as todo_count',
                 :joins => 'left outer join todos on todos.context_id = contexts.id',
                 :group => 'contexts.id'
    )
  end
end
