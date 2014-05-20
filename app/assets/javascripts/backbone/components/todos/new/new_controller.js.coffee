@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Controller extends App.Controllers.Base

    initialize: (data) ->
      @model = App.request "new:todos:entity"
      @collection = data.collection
      @layout = @getLayoutView()

      @listenTo @layout, 'show',        @loadLayout
      @listenTo @layout, 'show:form',   @showForm
      @listenTo @layout, 'close:form',  @closeForm
      @listenTo @layout, 'save:form',   @save

    showForm: ->
      @button.close()
      @form   = @getFormView()
      @layout.createNewRegion.show @form

    closeForm: ->
      @form.close()
      @button = @getButtonView()
      @layout.createNewRegion.show @button

    loadLayout: () ->
      @button = @getButtonView()
      @layout.createNewRegion.show @button

    save: (e) ->
#      e.preventDefault()
#      e.stopPropagation()

      formData =
        title:    $('input.panel-title').val()
        due:      $('input.todo-due').val()
        content:  $('#todoContent').val()
        kind:     $("input[type='radio'][name='todo[kind]']:checked").val()
        prior:    $("input[type='radio'][name='todo[prior]']:checked").val()

      @model.set(formData)
      @model = App.request "create:todos:entity", @model, @collection

#      if @model.isValid(true)
#        @model.save({},
#          success: (todo, jqXHR) =>
#            @collection.add(@model)
#            @cancel()
#          error: (todo, jqXHR) =>
#            console.log(jqXHR)
#        )
#      else
#        console.log('render huender')


    getFormView: () ->
      new New.Form()

    getButtonView: () ->
      new New.Button()

    getLayoutView: () ->
      new New.Layout()

  App.reqres.setHandler "todos:new", (data) ->
    form = new New.Controller(data)
    form.layout