@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (data) ->
#      @collection = data.collection
      @layout = @getLayoutView()
      @listenTo @layout, 'show',        @loadLayout
      @listenTo @layout, 'show:form',   @showForm

    showForm: (a, model=false) ->
      if model then @model = model else @model = App.request "new:todos:entity"
      @button.destroy()
      @form = @getFormView()
      @layout.createNewRegion.show @form.form
      @listenTo @form,    'cancel',       @destroyForm
      @listenTo @model,   'server:send',  @successAdd

    destroyForm: ->
      @stopListening(@form)
      @stopListening(@model)
      @form.destroy()
      @button = @getButtonView()
      @layout.createNewRegion.show @button

    successAdd: ->
      @destroyForm()
      @listenTo @model, "server:error", ->
        @showForm(false, @model)

    loadLayout: () ->
      @button = @getButtonView()
      @layout.createNewRegion.show @button

    getFormView: () ->
      App.request "todos:edit",
        model:   @model,
        action:  'new'

    getButtonView: () ->
      new New.Button()

    getLayoutView: () ->
      new New.Layout()

  App.reqres.setHandler "todos:new", (data) ->
    form = new New.Controller(data)
    form.layout