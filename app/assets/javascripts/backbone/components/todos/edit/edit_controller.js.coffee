@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (model, collection, opts) ->
      @model      = model
      @collection = collection
      @form = @getFormView()
      @listenTo @form, "consoler", =>
        console.log('consoller')

    getFormView: () ->
      new Edit.Form @model, @collection

  App.reqres.setHandler "todos:edit", (model, collection, opts={}) ->
    form = new Edit.Controller model, collection, opts
    form.form