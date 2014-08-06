@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'apps/projects/show/templates/layout'
    regions:
      projectRegion       : "#projectRegion"
      createNewRegion     : "#createNewRegion"
      projectTodosRegion  : "#projectTodosRegion"

  class Show.Item extends Marionette.ItemView
    template: 'apps/projects/show/templates/item'
    events:
      'click a.save'      : 'save'

    onRender: ->
      $('textarea', @$el).autosize()

    save: ->
      @trigger('save')