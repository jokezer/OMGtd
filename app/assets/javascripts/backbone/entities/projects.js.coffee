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
#        group_ids: ids,
        GroupCollection: Entities.TodosCollection,
        groupBy: (project) =>
          return project.get('state')
      })

    withState: (state) ->
      @groupedStates.get('active').vc


  API =
    getProjects: ->
      Projects = new Entities.ProjectsCollection
      Projects.fetch
        reset: true
      Projects

    getProject: (id) ->
      Project = new Entities.Project
        id: id
      Project.fetch()
      Project

    newProject: ->
      new Entities.Project

    getLoadedProjects: ->
      App.Projects

    getProjectLabel: (id) ->
      App.Projects.get(id).get('label')

  App.reqres.setHandler "projects:entities", ->
    API.getProjects()

  App.reqres.setHandler "projects:entity", (id) ->
    API.getProject id

  App.reqres.setHandler "new:projects:entity", ->
    API.newProject()

  App.reqres.setHandler "projects:loaded", ->
    API.getLoadedProjects()

  App.reqres.setHandler "project:label", (id) ->
    API.getProjectLabel(id)