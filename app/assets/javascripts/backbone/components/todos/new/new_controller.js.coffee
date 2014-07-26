@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (data) ->
#      @collection = data.collection
      @layout = @getLayoutView()
      @listenTo @layout, 'show',        @loadLayout
      @listenTo @layout, 'show:form',   @showForm

    showForm: (a, model=false) ->
      if model then @model = model else @model = App.request "new:todos:entity"
      @button.close()
      @form = @getFormView()
      @layout.createNewRegion.show @form.form
      @listenTo @form,    'cancel',       @closeForm
      @listenTo @model,   'server:send',  @successAdd

    closeForm: ->
      @stopListening(@form)
      @stopListening(@model)
      @form.close()
      @button = @getButtonView()
      @layout.createNewRegion.show @button

    successAdd: ->
      @closeForm()
      @listenTo @model, "server:error", ->
<<<<<<< HEAD
=======
        App.todos.remove(@model)
>>>>>>> e56c8743fe3444bfa7193b6b272b1585bf7f8b29
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