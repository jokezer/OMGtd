@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
#      @collection = @getCollectionView data.todos
      collection = App.request "todos:list", data.todos
      @show collection
      console.log(collection)
#
#    getCollectionView: (todos) ->
#      new List.Collection
#        collection: todos