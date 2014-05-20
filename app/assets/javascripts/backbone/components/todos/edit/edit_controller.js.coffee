@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Controller extends App.Controllers.Base

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
      formData =
        title:      $('input.panel-title',                                    @form.$el).val()
        due:        $('input.todo-due',                                       @form.$el).val()
        content:    $("textarea[name='todo[content]']",                       @form.$el).val()
        kind:       $("input[type='radio'][name='todo[kind]']:checked",       @form.$el).val()
        prior:      $("input[type='radio'][name='todo[prior]']:checked",      @form.$el).val()
        context_id: $("input[type='radio'][name='todo[context_id]']:checked", @form.$el).val()
      formData.context_id = parseInt(formData.context_id, 10)
      formData.prior      = parseInt(formData.prior, 10)
      formData

    getFormView: () ->
      new Edit.Form @model, @collection

  App.reqres.setHandler "todos:edit", (model, collection, opts={}) ->
    form = new Edit.Controller model, collection, opts
    form