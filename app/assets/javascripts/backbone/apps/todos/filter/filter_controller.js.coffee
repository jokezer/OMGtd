@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      @todos = data.todos
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showCollection()
        @showNew()
#        @showNew2()
      @show @layout

    showCollection: () ->
      collectionView = @getTodosView()
      @layout.todosRegion.show collectionView

    showNew: () ->
      newView = @getNewView()
      @layout.newRegion.show newView

    getLayoutView: ->
      new Filter.Layout()

    getTodosView: ->
      App.request "todos:list", @todos

    getNewView: () ->
      App.request "todos:new", collection: @todos