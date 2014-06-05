@OMGtd.module "Components.Todos.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: (data) ->
      @todos = data.todos
      @groups = new Backbone.Collection(
        [
          {label: 'Today todos',        todos: @todos.getGroup('active', 'calendar', 'today')},
          {label: 'Tomorrow todos',     todos: @todos.getGroup('active', 'calendar', 'tomorrow')},
          {label: 'Weekly todos',       todos: @todos.getGroup('active', 'calendar', 'weekly')},
          {label: 'Next todos'},
          {label: 'Scheduled todos'},
          {label: 'Cycled todos'},
          {label: 'Waiting todos'},
          {label: 'Someday todos'},
#          {label: 'Trash todos'}, if project
#          {label: 'Completed todos'}, if project
        ]
      )

    getLayoutView: ->
      new Index.Collection
        collection: @groups

    getTodosView: ->
      App.request "todos:list", @todos

  App.reqres.setHandler "todos:index", (data) ->
    collection = new Index.Controller(data)
    collection.getLayoutView()