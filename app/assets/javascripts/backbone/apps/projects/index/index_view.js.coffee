@OMGtd.module "ProjectsApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Layout extends Marionette.Layout
    template: 'apps/projects/index/templates/layout'
    regions:
      createProjectRegion     : "#createProjectRegion"
      activeProjectsRegion    : "#activeProjectsRegion"
      finishedProjectsRegion  : "#finishedProjectsRegion"
      trashProjectsRegion     : "#trashProjectsRegion"

  class Index.Item extends Marionette.ItemView
    template: 'apps/projects/index/templates/item'

  class Index.Empty extends Marionette.ItemView
    template: 'apps/projects/index/templates/empty'

  class Index.Collection extends Marionette.CollectionView
    itemView:   Index.Item
    emptyView:  Index.Empty