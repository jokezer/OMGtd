class Gtd.Routers.Todos extends Backbone.Router
  initialize: (options) ->
    @todos = options.todos
    @todos.makeGroups()
    @renderSidebars()

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
    @view = new Gtd.Views.Todos.indexView(todos: @todos)
    $("#todos").html(@view.render().el)

  show: (id) ->
    todo = @todos.get(id)
    @view = new Gtd.Views.Todos.ShowView(model: todo)
    $("#todos").html(@view.render().el)

  edit: (id) ->
    todo = @todos.get(id)
    @view = new Gtd.Views.Todos.EditView(model: todo)
    $("#todos").html(@view.render().el)

  filterState: (state, group=false, label=false) ->
    todos = @todos.getGroup(state, group, label)
    @view = new Gtd.Views.Todos.filterView(todos: todos, label: todos.label, length: todos.length)
    $("#todos").html(@view.render().el)

  #todo move from here
  renderSidebars: ->
    left_sidebar = new Gtd.Views.Sidebar.LeftSidebar(todos: @todos)
    left_sidebar.render()
    #contexts
    contexts = new Gtd.Collections.Contexts
    p = contexts.fetch()
    p.done ->
      context_sidebar = new Gtd.Views.Sidebar.ContextSidebar(collection:contexts, type:'context')
      context_sidebar.render()
    #projects
    projects = new Gtd.Collections.Projects
    p = projects.fetch()
    p.done ->
      context_sidebar = new Gtd.Views.Sidebar.ContextSidebar(collection:projects, type:'project')
      context_sidebar.render()
