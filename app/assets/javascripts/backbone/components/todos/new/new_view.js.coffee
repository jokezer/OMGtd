@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Form extends Marionette.ItemView
    template: 'components/todos/new/templates/form'

    serializeData: ->
#      data = @model.toJSON()
      data = {}
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data

    onRender: ->
      @$el.find('#todoDue').datetimepicker({format: 'Y-m-d H:i'})

  class New.Button extends Marionette.ItemView
    template: 'components/todos/new/templates/button'

  class New.Layout extends Marionette.Layout
    template: 'components/todos/new/templates/layout'
    regions:
      createNewRegion: "#createNew-region"
    triggers:
      'click #createNew': 'show:form'
      'click #closeForm': 'close:form'
      'submit #new-todo': 'save:form'