Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.baseIndexView extends Backbone.View

  initialize: (options) ->
    @options = options
    @options.todos.bind('save', @erender) #adds todoe before server validation
#    @listenTo(@options.todos, 'sync', @erender)

  addAll: () =>
    @options.todos.each(@addOne)
    $(@el).append('No items in this category') if @options.todos.length == 0

  addOne: (todo) =>
    view = new Gtd.Views.Todos.TodoView({model : todo})
    @$("#todos_collection").append(view.render().el)
    @$("#todos_collection").append(view.render().el)

  erender: () ->
    console.log('synced')

  requestOO: () ->
    console.log('request something')