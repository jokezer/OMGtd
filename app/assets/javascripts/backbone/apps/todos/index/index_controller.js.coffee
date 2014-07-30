@OMGtd.module "TodosApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base

    initialize: (data) ->
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
      App.request "todos:index"
#
#    getNewView: () ->
#      App.request "todos:new", collection: @todos