#todo context and project models has many common things that would be better to put in module
class Context < ActiveRecord::Base
  belongs_to :user
  has_many :todos, :dependent => :nullify
  validates :user, presence: true
  validates :name,
            presence: true,
            uniqueness: {:scope => :user_id, :case_sensitive => false},
            length: {maximum: 20}

  before_save {|c|c.name.tr!(' ','_')}

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
    self.select('contexts.name, contexts.name as label, count(todos.id) as todo_count')
    .joins('left outer join todos on todos.context_id = contexts.id')
    .group('contexts.id')
    .to_a.map { |a| a.serializable_hash.symbolize_keys }
  end

  def self.by_name(name)
    self.where('lower(name) = ?', name.downcase).take
  end

  def self.by_label(label)
    self.where('lower(name) = ?', label[1..-1].downcase).take
  end

  def label
    "@#{self.name}"
  end

end
