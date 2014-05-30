@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base
  #TODO todo dont save if click to edit another one before first saved

    initialize: (data) ->
      @model      = data.model
      @action     = data.action
      @form = @getFormView()
      @listenTo @form, "save", @save
      @listenTo @form, "cancel", ->
        @trigger "cancel"

    save: ->
      @model.set(@getFormData())
      @model = App.request "save:todos:entity",
        model: @model
      if @model.validationError
        @form.render()
        $('textarea', @form.$el).trigger('autosize.resize')
      else
        App.todos.add(@model) if @action == 'new'
        @model.trigger("server:send")

    getFormData: ->
      formData = Backbone.Syphon.serialize(@form)
      formData.context_id = parseInt(formData.context_id, 10)
      formData.prior      = parseInt(formData.prior, 10)
      formData

    getFormView: () ->
      new Edit.Form @model, @collection

  App.reqres.setHandler "todos:edit", (data) ->
    form = new Edit.Controller(data)
    form