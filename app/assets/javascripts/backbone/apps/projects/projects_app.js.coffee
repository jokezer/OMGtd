@OMGtd.module "ProjectsApp", (ProjectsApp, App, Backbone, Marionette, $, _) ->

  class ProjectsApp.Router extends Marionette.AppRouter
    appRoutes:
      "projects"	                            : "index"
      "project/:id"	                          : "showProject"

  API =
    index: ->
      new ProjectsApp.Index.Controller
        region:    App.centralRegion
        projects:  App.request "projects:by_state:all"

    showProject: (id) ->
      id = parseInt(id)
      new ProjectsApp.Show.Controller
        region:   App.centralRegion
        project:  App.request "projects:entity", id
        todos:    new App.Entities.TodosCollection( App.todos.where(project_id: id) )

  App.addInitializer ->
    new ProjectsApp.Router
      controller: API