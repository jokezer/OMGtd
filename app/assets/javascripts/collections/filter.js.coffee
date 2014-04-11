#class Gtd.Collections.TodosGroups extends Backbone.Collection
#  model: Gtd.Models.Todo
#  url: '/todos/groups'

#state inbox
#state trash
#state completed
#state active by
  #kind next
  #kind scheduled
  #kind someday
  #kind maybe
  #kind waiting
  #calendar today
  #calendar tomorrow
  #calendar later?
  #calendar this week?
  #calendar this mount?

#1. Group all todos by state
  #make collections
  #render sidebars
#2. Load only inbox and active state todos, count trash and canceled?