@OMGtd.module "TodosApp.Filter", (Filter, App, Backbone, Marionette, $, _) ->

  class Filter.Layout extends Marionette.LayoutView
    template: 'apps/todos/filter/templates/layout'
    regions:
      newRegion:   "#new-region"
      todosRegion: "#todos-region"
