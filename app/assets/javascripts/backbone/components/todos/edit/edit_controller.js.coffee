@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: () ->
      @form = @getFormView()
      @listenTo @form, "consoler", =>
        console.log('consoller')

    getFormView: () ->
      new Edit.Form

  App.reqres.setHandler "todos:edit", ->
    form = new Edit.Controller
    form.form