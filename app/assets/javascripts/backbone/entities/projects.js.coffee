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
      model.save({},
        success: (project, resp) ->
          if Object.keys(resp.errors).length
            model.validationError = resp.errors
            model.trigger 'server:error'
          else
            model.trigger 'server:saved'
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

    getProjectTodos: (id) ->
      if !App.currentProject || App.currentProject.id != id
        App.currentProject =
          todos: new App.Entities.TodosCollection( App.todos.where(project_id: id) )
          id:    id
        App.currentProject.todos.listenTo App.todos, 'add', (el) ->
          if el.get('project_id') == App.currentProject.id
            App.currentProject.todos.add el
      App.currentProject.todos

    reloadProjects: ->
      projects = App.request "projects:entities"
      App.execute "when:fetched", projects, =>
        App.projects = projects
        App.execute('left_sidebar:update')

  App.reqres.setHandler "projects:entities", ->
    API.getProjects()

  App.reqres.setHandler "project:todos", (id) ->
    API.getProjectTodos(id)

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

  App.reqres.setHandler "projects:reload", ->
    API.reloadProjects()