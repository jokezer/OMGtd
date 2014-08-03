@OMGtd.module "ProjectsApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: ->
      @layout = @getLayoutView()
      @show @layout
      @showAll()

    showAll: ->
      projects = App.request "projects:by_state:all"
      @layout.activeProjectsRegion.show @getCollectionView(projects.active)
      @layout.finishedProjectsRegion.show @getCollectionView(projects.finished)
      @layout.trashProjectsRegion.show @getCollectionView(projects.trash)

    getCollectionView: (collection) ->
      new Index.Collection
        collection: collection

    getLayoutView: ->
      new Index.Layout