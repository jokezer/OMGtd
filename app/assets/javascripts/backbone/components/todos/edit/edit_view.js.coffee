@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    triggers:
      'dblclick'            : 'consoler'

    events:
      'click .change-prior label': 'changePrior'
      'mouseleave'               : 'leaveElement'

    initialize: (model, collection, opts) ->
      @model = model
      @collection = collection

    leaveElement: ->
      saveTodo =  (view) ->
        panel = $('.panel-todo', view.$el)
        unless $('.edit:focus', view.$el).length || panel.hasClass('saving') || view.$el.is(':hover')
          panel.block message: 'loading'
          view.trigger('save')

      _.delay(saveTodo, 1500, @);

    serializeData: ->
      data = @model.toJSON()
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data.contexts = App.contexts.models
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @selectRadio 'prior',       @model.get('prior')
      @selectRadio 'kind',        @model.get('kind')
      @selectRadio 'context_id',  @model.get('context_id')
      $('textarea', @$el).autosize()
      $('input.todo-due', @$el).datetimepicker({format: 'Y-m-d H:i'})

    selectRadio: (name, value) ->
      $("input[type='radio'][name='todo[#{name}]'][value=#{value}]", @$el)
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