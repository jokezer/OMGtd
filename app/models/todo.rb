class Todo < ActiveRecord::Base

  STATUSES = {1 => :inbox, 2 => :next, 3 => :scheduled, 4 => :someday, 5 => :waiting, 6 => :completed, 7 => :trash}
  STATUS_GROUP = {}
  STATUS_GROUP[:active] = [1,2,3,4,5]
  STATUS_GROUP[:hidden] = [6,7]
  # it is possible to use .invert here
  #ALLOWED_STATUSES = [:inbox, :next, :scheduled, :someday, :waiting, :completed, :trash]
  #ACTIVE_STATUSES = [:inbox, :next, :scheduled, :someday, :waiting]
  #HIDDEN_STATUSES = [:completed, :trash]

  #scope :active, where(:status => Account::STATUS[:active])
  #scope :suspended, where(:status => Account::STATUS[:suspended])
  #scope :closed, where(:status => Account::STATUS[:closed])

  default_scope { order('updated_at DESC') }

  scope :by_status, ->(label) { where(:status => invert_statuses[label.to_sym])}

  belongs_to :user
  validates :user, presence: true
  validates :title, presence: true
  validates :status, presence: true, :inclusion => {:in => STATUSES.keys}


  self.per_page = 4

  def count_by_type
    user.todos.group(:status).count
  end

  def get_main_page
  end

  def status_label
    STATUSES[self.status]
  end

  def self.filter_statuses_by(group)
      STATUSES.select { |key,_| STATUS_GROUP[group].include? key } if STATUS_GROUP[group]
  end

  def self.invert_statuses
    STATUSES.invert
  end

end
