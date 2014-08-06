@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Button extends Marionette.ItemView
    template: 'components/todos/new/templates/button'

  class New.Layout extends Marionette.LayoutView
    template: 'components/todos/new/templates/layout'
    regions:
      createNewRegion: "#createNew-region"
    triggers:
      'click #createNew': 'show:form'