@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      @todos = App.request "todos:entities:group", data
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showCollection()
        @showNew()
      @show @layout
      App.execute("todos:highlightLink", data)

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