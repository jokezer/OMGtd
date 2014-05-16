@OMGtd.module "TodosApp", (TodosApp, App, Backbone, Marionette, $, _) ->

  class TodosApp.Router extends Marionette.AppRouter
    appRoutes:
      "todos"	                            : "index"
      "todos/filter/:state"               : "filterState"
      "todos/filter/:state/:group/:label" : "filterState"

  API =
    index: ->
      console.log('index page of application')

    filterState: (state, group=false, label=false) ->
      new TodosApp.Filter.Controller
        region: App.centralRegion
        todos: App.todos.getGroup(state, group, label)

  App.addInitializer ->
    new TodosApp.Router
      controller: API