@OMGtd.module "Components.Todos.New", (New, App, Backbone, Marionette, $, _) ->

  class New.Form extends Marionette.ItemView
    template: 'components/new/templates/form'