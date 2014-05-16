@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Controller extends App.Controllers.Base

    initialize: (data) ->
      collection = App.request "todos:list", data.todos
      @show collection