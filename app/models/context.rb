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

  def prefix
    '@'
  end

  include ContextProject

  def self.create_defaults
    if self.count == 0
      self.create([{name: 'Home'},
                   {name: 'Office'},
                   {name: 'Errands'},
                   {name: 'Phone'},
                   {name: 'Computer'}])
    end
  end

end
