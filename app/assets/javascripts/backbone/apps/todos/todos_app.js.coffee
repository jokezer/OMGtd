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
      console.log("filter by #{state} #{group} #{label}")
      new TodosApp.List.Controller
        region: App.centralRegion




  App.addInitializer ->
    new TodosApp.Router
      controller: API