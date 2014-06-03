@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (data) ->
#      @collection = data.collection
      @layout = @getLayoutView()
      @listenTo @layout, 'show',        @loadLayout
      @listenTo @layout, 'show:form',   @showForm

    showForm: ->
      @model = App.request "new:todos:entity"
      @button.close()
      @form = @getFormView()
      @layout.createNewRegion.show @form.form
      @listenTo @form,    'cancel',       @closeForm
      @listenTo @model,   'server:send',  @closeForm

    closeForm: ->
      @stopListening(@form)
      @stopListening(@model)
      @form.close()
      @button = @getButtonView()
      @layout.createNewRegion.show @button

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