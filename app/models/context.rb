class Context < ActiveRecord::Base
  belongs_to :user
  has_many :todos
  validates :user, presence: true
  validates :name, presence: true, :uniqueness => {:scope => :user_id} #case sensitive false
  #todo add max length and exclusion for word "new"
  #todo make inclusion todos

  def self.create_defaults
    if self.count == 0
      self.create([{name: 'Home'},
                   {name: 'Office'},
                   {name: 'Errands'},
                   {name: 'Phone'},
                   {name: 'Computer'}])
    end
  end

  def self.make_group
    self.select('contexts.name as label, count(todos.id) as todo_count')
    .joins('left outer join todos on todos.context_id = contexts.id')
    .group('contexts.id')
    .to_a.map {|a|a.serializable_hash.symbolize_keys}
  end

  def self.by_name(name)
    self.where('lower(name) = ?', name.downcase).take
  end

end
