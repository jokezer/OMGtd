@OMGtd.module "TodosApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Controller extends App.Controllers.Base

    initialize: ->
      @todos = App.request "todos:entities"
      App.execute "when:fetched", @todos, =>

        @layout = @getCollectionView @todos

        # @listenTo @layout, "close", @close

        @show @layout

    getCollectionView: (todos) ->
      new List.Collection
        collection: todos