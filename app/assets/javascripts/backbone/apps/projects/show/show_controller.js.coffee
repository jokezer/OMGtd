@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: (data) ->
      @data = data
      @model     = data.project
      @layout      = @getLayoutView()
      @model.getTodos()
      @listenTo @model.todos, 'change:project_id', (e, l) ->
        @model.todos.remove(e) if l!=@model.id
      @projectView = @getProjectView()
      @listenTo @projectView, 'save', @save
      @show @layout
      @showAll()
      @highlightLink()

    highlightLink: () ->
      App.execute("left_sidebar:highlightLink", "/#/project/#{@data.project.id}")

    getLink: ->
      baseLink = "/#/project/#{@data.project.id}"
      if @data.state
        link = App.request "todos:link", @data.state, @data.group, @data.label
        link = "#{baseLink}/filter/#{link}"
      else link=baseLink
      link

    showAll: ->
      @layout.projectRegion.show @projectView
      @layout.projectNavsRegion.show @getNavs()
      @layout.createNewRegion.show @getNewView()
      if @data.state
        @layout.projectTodosRegion.show @getTodosList(@data.state, @data.group, @data.label)
      else
        @layout.projectTodosRegion.show @getTodosIndex()


    getProjectView: ->
      new Show.Item
        model: @model

    getLayoutView: ->
      new Show.Layout

    getTodosIndex: ->
      App.request "components:todos:index",
        todos: @model.todos

    getNewView: ->
      preload = project_id: @model.id
      preload[@data.group] = @data.label
      App.request "todos:new",
        preload: preload


    getTodosList: (state, group, label) ->
      todos = App.request "todos:entities:group",
        state: state,
        group: group,
        label: label,
        todos: @model.todos
      App.request "components:todos:list", todos


    getNavs: ->
      new Show.Navs
        todos:   @model.todos
        project: @model
        link:    @getLink()

    save: ->
      @model.set @getFormData()
      if !@model.validationError
        @model = App.request "save:projects:entity", @model

    getFormData: ->
      Backbone.Syphon.serialize(@projectView)