@OMGtd.module "ProjectsApp", (ProjectsApp, App, Backbone, Marionette, $, _) ->

  class ProjectsApp.Router extends Marionette.AppRouter
    appRoutes:
      "projects"	                              : "index"
      "project/:id"	                            : "showProject"
      "project/:id/filter/:state"             	: "showProject"
      "project/:id/filter/:state/:group/:label"	: "showProject"

  API =
    index: ->
      new ProjectsApp.Index.Controller
        region:    App.centralRegion
        projects:  App.request "projects:by_state:all"

    showProject: (id, state=false, group=false, label=false) ->
      id = parseInt(id)
      new ProjectsApp.Show.Controller
        region:   App.centralRegion
        project:  App.request "projects:entity", id
        state:    state
        group:    group
        label:    label

  App.addInitializer ->
    new ProjectsApp.Router
      controller: API