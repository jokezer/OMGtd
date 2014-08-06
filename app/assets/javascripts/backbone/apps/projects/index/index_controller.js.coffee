@OMGtd.module "ProjectsApp.Index", (Index, App, Backbone, Marionette, $, _) ->

  class Index.Controller extends App.Controllers.Base
    initialize: (data) ->
      @projects = data.projects
      @layout = @getLayoutView()
      @show @layout
      @showAll()

    showAll: ->
      @layout.activeProjectsRegion.show @getCollectionView(@projects.active)
      @layout.finishedProjectsRegion.show @getCollectionView(@projects.finished)
      @layout.trashProjectsRegion.show @getCollectionView(@projects.trash)

    getCollectionView: (collection) ->
      new Index.Collection
        collection: collection

    getLayoutView: ->
      new Index.Layout