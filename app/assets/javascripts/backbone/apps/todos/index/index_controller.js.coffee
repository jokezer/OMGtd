@OMGtd.module "TodosApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base

    initialize: (data) ->
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showIndexLayout()
#        @showNew()
      @show @layout
      App.execute("left_sidebar:highlightLink", '/#/todos')

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
      App.request "components:todos:index"
#
#    getNewView: () ->
#      App.request "todos:new", collection: @todos