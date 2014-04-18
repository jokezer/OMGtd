class Gtd.Routers.Todos extends Backbone.Router
  initialize: (options) ->
    @todos = options.todos
    @todos.makeGroups()

  routes:
    "new"      : "newTodo"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"
    "filter/:state" : "filterState"
    "filter/:state/:group/:label" : "filterState"

  newTodo: ->
    @view = new Gtd.Views.Todos.NewView(collection: @todos)
    $("#todos").html(@view.render().el)

  index: ->
    @view = new Gtd.Views.Todos.IndexView(todos: @todos)
    $("#todos").html(@view.render().el)
#    console.log(@todos.groupByA('state'))
#    console.log(@todos.subGroup().get('active').grouped_vc.get('next').vc.at(0)  )

  show: (id) ->
    todo = @todos.get(id)
    @view = new Gtd.Views.Todos.ShowView(model: todo)
    $("#todos").html(@view.render().el)

  edit: (id) ->
    todo = @todos.get(id)
    @view = new Gtd.Views.Todos.EditView(model: todo)
    $("#todos").html(@view.render().el)

  filterState: (state, group=false, label=false) ->
#    todos = new Gtd.Collections.Todos()
#    stateCollection = @todos.groupedStates.get(state)
#    todos = stateCollection.vc if stateCollection
#    if kind
#      kindCollection = stateCollection.groupedKinds.get(kind)
#      todos = kindCollection.vc if stateCollection
    todos = @todos.getGroup(state, group, label)
    @view = new Gtd.Views.Todos.IndexView(todos: todos)
    $("#todos").html(@view.render().el)
