@OMGtd.module "ProjectsApp", (ProjectsApp, App, Backbone, Marionette, $, _) ->

  class ProjectsApp.Router extends Marionette.AppRouter
    appRoutes:
      "projects"	                            : "index"

  API =
    index: ->
      new ProjectsApp.Index.Controller
        region: App.centralRegion

  App.addInitializer ->
    new ProjectsApp.Router
      controller: API