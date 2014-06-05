@OMGtd.module "Components.Todos.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: (data) ->
      @todos = data.todos
      @groups = new Backbone.Collection(
        [
          {label: 'Today todos',        todos: @todos.getGroup('active', 'calendar', 'today'),            showed:3},
          {label: 'Tomorrow todos',     todos: @todos.getGroup('active', 'calendar', 'tomorrow',          showed:3)},
          {label: 'Weekly todos',       todos: @todos.getGroup('active', 'calendar', 'weekly',            showed:3)},
          {label: 'Next todos',         todos: @todos.getGroup('active', 'kindNoCalendar', 'next'),       showed:3},
          {label: 'Scheduled todos',    todos: @todos.getGroup('active', 'kindNoCalendar', 'scheduled',   showed:3)},
          {label: 'Cycled todos',       todos: @todos.getGroup('active', 'kindNoCalendar', 'cycled',      showed:3)},
          {label: 'Waiting todos',      todos: @todos.getGroup('active', 'kindNoCalendar', 'waiting',     showed:3)},
          {label: 'Someday todos',      todos: @todos.getGroup('active', 'kindNoCalendar', 'someday',     showed:3)},
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