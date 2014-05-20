@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showCollection(data.todos)
#        @showNew(data.todos)
        @showNew2()

      @show @layout

    showCollection: (todos) ->
      collectionView = @getTodosView todos
      @layout.todosRegion.show collectionView

    showNew: (todos) ->
      newView = @getNewView(todos)
      @layout.newRegion.show newView

    showNew2: () ->
      editView = App.request "todos:edit"
      @layout.newRegion.show editView

    getLayoutView: ->
      new Filter.Layout()

    getTodosView: (todos) ->
      App.request "todos:list", todos

    getNewView: (todos) ->
      App.request "todos:new", collection: todos