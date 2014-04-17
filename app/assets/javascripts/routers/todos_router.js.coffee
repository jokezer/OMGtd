class Gtd.Routers.Todos extends Backbone.Router
  initialize: (options) ->
    @todos = options.todos

  routes:
    "new"      : "newTodo"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"
    "state/:state" : "filterState"

  newTodo: ->
    @view = new Gtd.Views.Todos.NewView(collection: @todos)
    $("#todos").html(@view.render().el)

  index: ->
    @view = new Gtd.Views.Todos.IndexView(todos: @todos)
    $("#todos").html(@view.render().el)
    console.log(@todos.groupByA('state'))
#    console.log(@todos.subGroup().get('active').grouped_vc.get('next').vc.at(0)  )

  show: (id) ->
    todo = @todos.get(id)

    @view = new Gtd.Views.Todos.ShowView(model: todo)
    $("#todos").html(@view.render().el)

  edit: (id) ->
    todo = @todos.get(id)
    @view = new Gtd.Views.Todos.EditView(model: todo)
    $("#todos").html(@view.render().el)

  filterState: (state) ->
    @view = new Gtd.Views.Todos.IndexView(todos: @todos.subGroup().get(state).vc )
    $("#todos").html(@view.render().el)