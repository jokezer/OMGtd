@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base
  #TODO todo dont save if click to edit another one before first saved
    initialize: (model, collection, opts) ->
      @model      = model
      @collection = collection
      @form = @getFormView()
      @listenTo @form, "consoler", =>
        console.log('consoller')

      @listenTo @form, "save", @save
      @listenTo @form, "done", ->
        @trigger "done"

    save: ->
      @model.set(@getFormData())
      @model.save({},
        success: (todo) ->
          todo.trigger 'successSave'
      )
      @trigger("done") unless @model.validationError

    getFormData: ->
      formData = Backbone.Syphon.serialize(@form)
      formData.context_id = parseInt(formData.context_id, 10)
      formData.prior      = parseInt(formData.prior, 10)
      formData

    getFormView: () ->
      new Edit.Form @model, @collection

  App.reqres.setHandler "todos:edit", (model, collection, opts={}) ->
    form = new Edit.Controller model, collection, opts
    form