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
      @listenTo @form, "destroy", @destroy

    destroy: ->
      App.todos.remove(@model)
      App.request "destroy:todos:entity",
        model: @model

    save: ->
      @model.set @getFormData(), validate:true
      @model.set @getFormData()
      @model.set(state:@model.moveTo) if @model.moveTo
      if !@model.validationError
        @model.trigger("server:send")
        @model = App.request "save:todos:entity",
          model: @model
          action: @action
      else
        @form.model = @model
        @form.render()
        $('textarea', @form.$el).trigger('autosize.resize')
        @model.set @model.previousAttributes()

    getFormData: ->
      formData = Backbone.Syphon.serialize(@form)
      formData.context_id = parseInt(formData.context_id, 10) if formData.context_id
      formData.prior      = parseInt(formData.prior, 10)
      formData.prior      = 0 unless formData.prior
      formData

    getFormView: () ->
      new Edit.Form @model

  App.reqres.setHandler "todos:edit", (data) ->
    new Edit.Controller(data)