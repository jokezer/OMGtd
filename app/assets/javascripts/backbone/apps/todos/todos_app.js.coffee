@OMGtd.module "TodosApp", (TodosApp, App, Backbone, Marionette, $, _) ->

  class TodosApp.Router extends Marionette.AppRouter
    appRoutes:
      "todos"	                            : "index"
      "todos/filter/:state"               : "filterState"
      "todos/filter/:state/:group/:label" : "filterState"

  API =
    index: ->
      new TodosApp.Index.Controller
        region: App.centralRegion
        todos:  App.todos

    filterState: (state, group=false, label=false) ->
      new TodosApp.Filter.Controller
        region: App.centralRegion
        state: state,
        group: group,
        label: label,
#

#     todos for project or context
#       console.log context_models = App.todos.where(context_id:21)
#       todos = new OMGtd.Entities.TodosCollection
#       todos.reset(context_models)
#       console.log todos

  App.addInitializer ->
    new TodosApp.Router
      controller: API