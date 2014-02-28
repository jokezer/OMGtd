class TodoPrior #< ActiveRecord::Base #todo change to active model
  #has_many :todos
  PRIORS = {
      1 => :low,
      2 => :medium,
      3 => :high,
  }

  def self.invert
    STATUSES.invert
  end


  def self.label_id(label)
    invert[label.to_sym]
  end

end
