@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    tagName: 'form'
    triggers:
      'dblclick'            : 'consoler'

    events:
      'click .change-prior label': 'changePrior'
      'mouseleave'               : 'leaveElement'
      'focusout'                 : 'leaveElement'
      'click a.save'             : 'save'
      'click a.cancel'           : 'cancelEdit'

    initialize: (model, collection, opts) ->
      @model = model
      @collection = collection

    leaveElement: ->
      saveTodo =  (view) ->
        unless $('.edit:focus', view.$el).length ||
          $('.panel-todo', view.$el).hasClass('saving') ||
          view.$el.is(':hover')
            view.save()
      @timer = _.delay(saveTodo, 1500, @)

    cancelEdit: ->
      clearTimeout(@timer)
      @trigger 'cancel'

    save: ->
      $('.panel-todo', @$el).addClass 'saving'
      @$el.block message: null
      @trigger('save')

    serializeData: ->
      data = @model.toJSON()
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data.contexts = App.request "contexts:loaded"
      data.contexts = data.contexts.models
      data.errors = @model.validationError
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @selectRadio 'prior',       @model.get('prior')
      @selectRadio 'kind',        @model.get('kind')
      @selectRadio 'context_id',  @model.get('context_id')
      $('textarea', @$el).autosize()
      $('input.todo-due', @$el).datetimepicker({format: 'Y-m-d H:i'})
      focusInput = ($el) ->
        $el.find('input.panel-title').focus()
      @timer = _.delay(focusInput, 30, @$el)

    selectRadio: (name, value) ->
      $("input[type='radio'][name='#{name}'][value=#{value}]", @$el)
        .prop("checked", true)
        .parent()
        .addClass('active')

    changePrior: (a) ->
      key = $("input", $(a.target)).val()
      @setPriorClass key

    setPriorClass: (key) ->
      $('.panel-todo', @$el).attr('class', (i, c) ->
          c?.replace(/\bprior-\S+/g, ''))
      priorLabel = App.request "todos:entity:prior:label", key
      $('.panel-todo', @$el).addClass("prior-#{priorLabel}")