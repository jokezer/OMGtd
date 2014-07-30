@OMGtd.module "Components.Todos.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: (data) ->
      @data = data

    groups:
      [
        {name: 'Today todos',        group: 'calendar',       label: 'today'},
        {name: 'Tomorrow todos',     group: 'calendar',       label: 'tomorrow'},
        {name: 'Weekly todos',       group: 'calendar',       label: 'weekly'},
        {name: 'Next todos',         group: 'kindNoCalendar', label: 'next'},
        {name: 'Scheduled todos',    group: 'kindNoCalendar', label: 'scheduled'},
        {name: 'Cycled todos',       group: 'kindNoCalendar', label: 'cycled'},
        {name: 'Waiting todos',      group: 'kindNoCalendar', label: 'waiting'},
        {name: 'Someday todos',      group: 'kindNoCalendar', label: 'someday'},
#          {label: 'Trash todos'}, if project
#          {label: 'Completed todos'}, if project
      ]

    makeCollection: ->
      for group in @groups
        group.todos = App.request "todos:entities:group",
          group: group.group
          label: group.label
      new Backbone.Collection(@groups)



    getLayoutView: ->
      collection = @makeCollection()
      new Index.Collection
        collection: collection

    getTodosView: ->
      App.request "todos:list", @todos

  App.reqres.setHandler "todos:index", (data) ->
    collection = new Index.Controller(data)
    collection.getLayoutView()