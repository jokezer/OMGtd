@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      @layout = @getLayoutView()

      @listenTo @layout, "show", =>
        @showCollection(data.todos)
        @showNew()

      @show @layout

    showCollection: (todos) ->
      collectionView = @getTodosView todos
      @layout.todosRegion.show collectionView

    showNew: ->
      newView = @getNewView()
      @layout.newRegion.show newView

    getLayoutView: ->
      new Filter.Layout()

    getTodosView: (todos) ->
      App.request "todos:list", todos

    getNewView: ->
      App.request "todos:new"

