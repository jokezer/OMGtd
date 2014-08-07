@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      @todos = App.request "todos:entities:group", data
      @layout = @getLayoutView()
      @listenTo @layout, "show", =>
        @showCollection()
        @showNew(data)
      @show @layout
      @highlightLink(data)

    highlightLink: (data) ->
      href = App.request "todos:link", data.state, data.group, data.label
      link = '/#/todos/filter/' + href
      App.execute("left_sidebar:highlightLink", link)

    showCollection: () ->
      collectionView = @getTodosView()
      @layout.todosRegion.show collectionView

    showNew: (data) ->
      newView = @getNewView(data)
      @layout.newRegion.show newView

    getLayoutView: ->
      new Filter.Layout()

    getTodosView: ->
      App.request "todos:list", @todos

    getNewView: (data) ->
      preload = {}
      preload[data.group] = data.label
      App.request "todos:new", preload: preload