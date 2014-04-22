Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.indexView extends Gtd.Views.Todos.baseIndexView
  template: JST['todos/index']

  addGroup: (group, todos)=>
    @$("#todos_collection").append($('<p>', text:"Group of #{group} - #{todos.length} todos"))
    todos.each(@addOne) if todos
    @$("#todos_collection").append('No items in this category') if todos.length == 0

  render: =>
    $(@el).html(@template())
    @addGroup('today todos',      @options.todos.getGroup('active', 'calendar', 'today'))
    @addGroup('next todos',       @options.todos.getGroup('active', 'kind', 'next'))
    @addGroup('tomorrow todos',   @options.todos.getGroup('active', 'calendar', 'tomorrow'))
    @addGroup('seven_days',       @options.todos.getGroup('active', 'calendar', 'seven_days'))
    @addGroup('cycled',           @options.todos.getGroup('active', 'kind', 'cycled'))
    @addGroup('waiting',          @options.todos.getGroup('active', 'kind', 'waiting'))
    @addGroup('someday',          @options.todos.getGroup('active', 'kind', 'someday'))
    return this
