class TodoStatus #< ActiveRecord::Base #todo change to active model
  #has_many :todos
  STATUSES = {1 => :inbox, 2 => :next, 3 => :scheduled, 4 => :someday, 5 => :waiting, 6 => :completed, 7 => :trash}
  STATUS_GROUP = {}
  STATUS_GROUP[:active] = [1,2,3,4,5]
  STATUS_GROUP[:hidden] = [6,7]

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
