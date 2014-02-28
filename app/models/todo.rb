class Todo < ActiveRecord::Base

  # todo move status to separate active model (and controller)
  # show method in status controller will calculate which statuses to show
  # via current_user variable and params hash

  STATUSES = {1 => :inbox, 2 => :next, 3 => :scheduled, 4 => :someday, 5 => :waiting, 6 => :completed, 7 => :trash}
  STATUS_GROUP = {}
  STATUS_GROUP[:active] = [1,2,3,4,5]
  STATUS_GROUP[:hidden] = [6,7]

  default_scope { order('updated_at DESC') }

  scope :by_status, ->(label) { where(:status => invert_statuses[label.to_sym])}

  belongs_to :user
  validates :user, presence: true
  validates :title, presence: true
  validates :status, presence: true, :inclusion => {:in => STATUSES.keys}


  self.per_page = 4

  #def count_by_type
  #  user.todos.group(:status).count
  #end
  
  #def get_main_page
  #end

  def status_label
    STATUSES[self.status]
  end

  def self.filter_statuses_by(group)
      STATUSES.select { |key,_| STATUS_GROUP[group].include? key } if STATUS_GROUP[group]
  end

  def self.invert_statuses
    STATUSES.invert
  end

  def self.status_label_id(label)
    invert_statuses[label.to_sym]
  end

end
