@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    triggers:
      'dblclick'            : 'consoler'

    events:
      'click .change-prior label': 'changePrior'

    serializeData: ->
#      data = @model.toJSON()
      data = {}
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data

    onRender: ->
      @$el.find('#todoDue').datetimepicker({format: 'Y-m-d H:i'})
      @setPriorClass(1) #todo @model.get('prior')

    changePrior: (a) ->
      key = $("input", $(a.target)).val()
      @setPriorClass key

    setPriorClass: (key) ->
      $('.panel-todo', @$el).attr('class', (i, c) ->
          c?.replace(/\bprior-\S+/g, ''))
      priorLabel = App.request "todos:entity:prior:label", key
      $('.panel-todo', @$el).addClass("prior-#{priorLabel}")