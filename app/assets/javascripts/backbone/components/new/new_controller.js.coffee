@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    getFormView: () ->
      new New.Form()

  App.reqres.setHandler "todos:new", ->
    form = new New.Controller
    form.getFormView()