Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.indexView extends Backbone.View
  template: JST['todos/index']

  initialize: (options) ->
    @options = options
    @options.todos.bind('reset', @addAll)

  addAll: () =>
    @options.todos.each(@addOne)
    $(@el).append('No items in this category') if @options.todos.length == 0

  #do not touch, method in parent class
  addOne: (todo) =>
    view = new Gtd.Views.Todos.TodoView({model : todo})
    @$("#todos_collection").append(view.render().el)

  addGroup: (group, todos)=>
    @$("#todos_collection").append($('<p>', text:"Group of #{group} - #{todos.length} todos"))
    todos.each(@addOne) if todos
    @$("#todos_collection").append('No items in this category') if todos.length == 0

  render: =>
    $(@el).html(@template())
    @addGroup('today todos',      @options.todos.getGroup('active', 'calendar', 'today'))
    @addGroup('next todos',       @options.todos.getGroup('active', 'kind', 'next'))
    @addGroup('tomorrow todos',   @options.todos.getGroup('active', 'calendar', 'tomorrow'))
    @addGroup('other scheduled(all now)',  @options.todos.getGroup('active', 'kind', 'scheduled'))
    @addGroup('cycled',           @options.todos.getGroup('active', 'kind', 'cycled'))
    @addGroup('waiting',          @options.todos.getGroup('active', 'kind', 'waiting'))
    @addGroup('someday',          @options.todos.getGroup('active', 'kind', 'someday'))
    return this
