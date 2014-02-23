class Todo < ActiveRecord::Base
  belongs_to :user
  belongs_to :type
  validates :user, presence: true
  validates :title, presence: true
  #TODO figure out how to make types of todos
  #There is four main type of todo: Inbox, Next, Scheduled, Someday/Maybe, Waiting, Completed, Canceled
  #But I want to group Scheduled in view to Today(with delayed), Tomorrow, Later

  #filter by given type
  scope :type, lambda { |type| joins(:type).where(:types => {:label => type}) }
  # all active todos
  scope :active, lambda { joins(:type).where{:label != :completed} }

  # filter by type todos = user.todos.includes(:type)
  # includes just to cache the query


  # todos.first.type.label
  # => "inbox"
  # TODO add all types, not only inserted

  #scope :today, # where type=scheduled and expire date < today.(with delayed)
  #scope :tomorrow # where
  #to get all todos grouped by type
  #or by context or project: user.todos.context(:home).by_type
  def self.group_by_type
  end
end
