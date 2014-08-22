@OMGtd.module "Components.Todos.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    getCollectionView: (todos) ->
      new List.Collection
        collection: todos

  App.reqres.setHandler "components:todos:list", (todos) ->
    collection = new List.Controller
    collection.getCollectionView(todos)