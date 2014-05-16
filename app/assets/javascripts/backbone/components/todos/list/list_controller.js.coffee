@OMGtd.module "Components.Todos.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base
#
#    initialize: (data) ->
#      @collection = @getCollectionView data.todos
#      @collection

    getCollectionView: (todos) ->
      new List.Collection
        collection: todos

  App.reqres.setHandler "todos:list", (todos) ->
    console.log('rendering todos list', todos.length)
    collection = new List.Controller
    collection.getCollectionView(todos)