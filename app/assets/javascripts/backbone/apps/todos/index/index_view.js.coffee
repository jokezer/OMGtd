@OMGtd.module "TodosApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Layout extends Marionette.Layout
    template: 'apps/todos/filter/templates/layout'
    regions:
      newRegion:   "#new-region"
      todosRegion: "#todos-region"
