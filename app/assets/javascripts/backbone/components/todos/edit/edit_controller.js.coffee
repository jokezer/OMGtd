@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

    initialize: (data) ->
      @model      = data.model
      @collection = data.collection
      @action     = data.action
      @form = @getFormView()
      @listenTo @form, "save", @save
      @listenTo @form, "cancel", ->
        @trigger "cancel"

    save: ->
      @model.set(@getFormData())
      @model.set(state:@model.moveTo) if @model.moveTo
      @model = App.request "save:todos:entity",
        model: @model
      if @model.validationError
        @form.render()
        $('textarea', @form.$el).trigger('autosize.resize')
      else
        if @action == 'new'
          App.todos.add(@model)
          @model.trigger 'reSort'
        @model.trigger("server:send")

    getFormData: ->
      formData = Backbone.Syphon.serialize(@form)
      formData.context_id = parseInt(formData.context_id, 10) if formData.context_id
      formData.prior      = parseInt(formData.prior, 10)
      formData

    getFormView: () ->
      new Edit.Form @model

  App.reqres.setHandler "todos:edit", (data) ->
    form = new Edit.Controller(data)
    form