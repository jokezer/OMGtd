Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.IndexView extends Backbone.View
  template: JST['todos/index']

  initialize: (options) ->
    @options = options
    @options.todos.bind('reset', @addAll)

  addAll: () =>
    @options.todos.each(@addOne)
    $(@el).append('No items in this category') if @options.todos.length == 0

  addOne: (todo) =>
    view = new Gtd.Views.Todos.TodoView({model : todo})
    @$("#todos_collection").append(view.render().el)

  render: =>
    $(@el).html(@template(todos: @options.todos.toJSON() ))
    @addAll()
    return this
