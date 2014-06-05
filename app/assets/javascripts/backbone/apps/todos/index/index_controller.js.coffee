@OMGtd.module "TodosApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base

    initialize: (data) ->
      @todos = data.todos
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showIndexLayout()
#        @showNew()
      @show @layout

    showIndexLayout: () ->
      indexLayout = @getIndexLayout()
      @layout.todosRegion.show indexLayout
#
#    showNew: () ->
#      newView = @getNewView()
#      @layout.newRegion.show newView

    getLayoutView: ->
      new Index.Layout()

    getIndexLayout: ->
      App.request "todos:index",
        todos: @todos

    getNewView: () ->
      App.request "todos:new", collection: @todos