@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    triggers:
      'dblclick': 'consoler'

    testEdit: ->
      console.log('sdeawfasdf')