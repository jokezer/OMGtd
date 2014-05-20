@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    triggers:
      'dblclick'            : 'consoler'

    events:
      'click .change-prior label': 'changePrior'

    initialize: (model, collection, opts) ->
      @model = model
      @collection = collection

    serializeData: ->
      data = @model.toJSON()
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @selectRadio 'prior', @model.get('prior')
      @selectRadio 'kind',  @model.get('kind')
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