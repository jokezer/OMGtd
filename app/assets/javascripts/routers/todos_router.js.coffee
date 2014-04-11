class Gtd.Routers.Todos extends Backbone.Router
  initialize: (options) ->
    @todos = new Gtd.Collections.Todos()
    @todos.reset options.todos

  routes:
    "new"      : "newTodo"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newTodo: ->
    @view = new Gtd.Views.Todos.NewView(collection: @todos)
    $("#todos").html(@view.render().el)

  index: ->
    @view = new Gtd.Views.Todos.IndexView(todos: @todos)
    $("#todos").html(@view.render().el)
#    byState = @todos.groupByA('state')
    console.log(@todos.subGroup())

  show: (id) ->
    todo = @todos.get(id)

    @view = new Gtd.Views.Todos.ShowView(model: todo)
    $("#todos").html(@view.render().el)

  edit: (id) ->
    todo = @todos.get(id)

    @view = new Gtd.Views.Todos.EditView(model: todo)
    $("#todos").html(@view.render().el)