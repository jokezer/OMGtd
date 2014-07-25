@OMGtd.module "SidebarsApp.Projects", (Projects, App, Backbone, Marionette, $, _) ->

  class Projects.Controller extends App.Controllers.Base

    initialize: () ->
      @render()


    render: ->
      @makeElements()
      ProjectsView = @getProjectsView()
      @show ProjectsView


    getProjectsView: ->
      new App.SidebarsApp.Sidebar
        collection: @collection
        label:      'Projects'

    makeElements: () ->
      prepared =   App.projects.withState('active').map (el) ->
        el.set({
          length: App.todos.where(project_id:el.id, state: 'active').length
          href:   "active/project/#{el.id}"
        })
      @collection = new Backbone.Collection prepared
