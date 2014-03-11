class TodoStatus #< ActiveRecord::Base #todo change to active model
  #has_many :todos
  COLLECTION = {1 => :inbox,
              2 => :next,
              3 => :scheduled,
              4 => :someday,
              5 => :waiting,
              6 => :completed,
              7 => :trash}
  GROUP = {}
  GROUP[:active] = [1,2,3,4,5]
  GROUP[:hidden] = [6,7]

  def self.filter_by(group)
    COLLECTION.select { |key,_| GROUP[group].include? key } if GROUP[group]
  end

  def self.invert
    COLLECTION.invert
  end

  def self.label(id)
    COLLECTION[id.to_i]
  end

  def self.label_id(label)
    invert[label.to_sym] if label
  end

end
