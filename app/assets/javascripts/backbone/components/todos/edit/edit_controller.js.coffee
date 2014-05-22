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
      @listenTo @form, "cancel", ->
        @trigger "cancel"

    save: ->
      @model.set(@getFormData())
      @model.save({},
        success: (todo, resp) ->
          if Object.keys(resp.errors).length
            todo.validationError = resp.errors
            todo.trigger 'validationError'
          else
            todo.trigger 'successSave'
        error: ->
          alert('Server error!')
      )
      if @model.validationError
        @form.render()
        $('textarea', @form.$el).trigger('autosize.resize')
      else
        @trigger("done")

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