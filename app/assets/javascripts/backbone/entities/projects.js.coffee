@OMGtd.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Project extends App.Entities.Model
    url: ->
      u = "/projects/"
      u = "#{u}#{@id}" if this.id
      u
    paramRoot: 'project'

    states: ['active', 'finished', 'trash']

    defaults:
      title: ''
      content: ''
      state: 'active'

    validation:
      title:
        required: true


  class Entities.ProjectsCollection extends App.Entities.Collection
    model: Entities.Project
    url: -> '/projects/'
    initialize: ->
      @makeGroups()

    makeGroups: ->
      @groupedStates =  Backbone.buildGroupedCollection({
        collection: @,
        groupBy: (project) =>
          return project.get('state')
      })

    withState: (state) ->
      group = @groupedStates.get(state)
      group.vc if group


  API =
    getProjects: ->
      Projects = new Entities.ProjectsCollection
      Projects.fetch
        reset: true
      Projects

    saveProject: (model) ->
      console.log 'save project'
      model.save({},
        error: (a, b) ->
          alert 'connection error'
      )
      model

    getProject: (id) ->
      App.projects.get id

    newProject: ->
      new Entities.Project

    getLoadedProjects: ->
      App.projects

    getProjectLabel: (id) ->
      App.projects.get(id).get('label')

    getAllProjectsByStates: ->
      output =
        active:   App.projects.withState 'active'
        finished: App.projects.withState 'finished'
        trash:    App.projects.withState 'trash'
      output

    getProjectsByState: (state) ->
      App.projects.withState state

  App.reqres.setHandler "projects:entities", ->
    API.getProjects()

  App.reqres.setHandler "save:projects:entity", (model) ->
    API.saveProject model

  App.reqres.setHandler "projects:by_state", (state) ->
    API.getProjectsByState state

  App.reqres.setHandler "projects:by_state:all", ->
    API.getAllProjectsByStates()

  App.reqres.setHandler "projects:entity", (id) ->
    API.getProject id

  App.reqres.setHandler "new:projects:entity", ->
    API.newProject()

  App.reqres.setHandler "projects:loaded", ->
    API.getLoadedProjects()

  App.reqres.setHandler "project:label", (id) ->
    API.getProjectLabel(id)