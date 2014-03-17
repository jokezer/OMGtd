### NEW _TODO ORDER
# Each _todo have finite states: inbox, active, canceled(trash), finished
# And statuses: next, scheduled, someday, waiting
#STATES:
  #INBOX
    # When created _todo state is inbox (if not defined). Don't have any types
  #ACTIVE
    # Active _todo, always showed in user active todos. Have 1 type
  #TRASH
    # The same as active, but dont showed in active todos list.
  #COMPLETED
    # The same as trash
#TYPES:
  #NEXT
    # deadline - may have deadline time
  #SCHEDULED
    # deadline is obligatory
  #SOMEDAY
    # deadline not required
  #WAITING
    # deadline optional - use as reminder

#PROJECT
  #STATES:
    #ACTIVE
      # all project's todos marked as active
    #TRASH
      # all project's todos marked as trash
    #COMPLETED
      # all project's todos marked as completed

# Use project deadline as week, month, year task

#class TodoStatus #< ActiveRecord::Base #todo change to active model
#  #has_many :todos
#  COLLECTION = {1 => :inbox,
#              2 => :next,
#              3 => :scheduled,
#              4 => :someday,
#              5 => :waiting,
#              6 => :completed,
#              7 => :trash}
#  GROUP = {}
#  GROUP[:active] = [1,2,3,4,5]
#  GROUP[:hidden] = [6,7]
#
#  def self.filter_by(group)
#    COLLECTION.select { |key,_| GROUP[group].include? key } if GROUP[group]
#  end
#
#  def self.invert
#    COLLECTION.invert
#  end
#
#  def self.label(id)
#    COLLECTION[id.to_i]
#  end
#
#  def self.label_id(label)
#    invert[label.to_sym] if label
#  end
#
#end
