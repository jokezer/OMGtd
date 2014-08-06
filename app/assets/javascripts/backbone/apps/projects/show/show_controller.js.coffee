@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: (data) ->
      @data = data
      @model     = data.project
      @layout      = @getLayoutView()
      @projectView = @getItemView()
      @listenTo @projectView, 'save', @save
      @getTodos()
      @show @layout
      @showAll()
      @highlightLink(data.project.id)

    getTodos: ->
      #todo: initialize project todos once
      @todos = new App.Entities.TodosCollection( App.todos.where(project_id: @model.id) )
      @todos.makeGroups()

    highlightLink: (id) ->
      App.execute("todos:highlightLink", "/#/project/#{id}")

    showAll: ->
      @layout.projectRegion.show @projectView
      @layout.projectNavsRegion.show @getNavs()
      if @data.state
        @layout.projectTodosRegion.show @getTodosList(@data.state, @data.group, @data.label)
      else
        @layout.projectTodosRegion.show @getTodosIndex()


    getItemView: ->
      new Show.Item
        model: @model

    getLayoutView: ->
      new Show.Layout

    getTodosIndex: ->
      App.request "todos:index",
        todos: @todos

    getTodosList: (state, group, label) ->
      todos = App.request "todos:entities:group",
        state: state,
        group: group,
        label: label,
        todos: @todos
      App.request "todos:list", todos


    getNavs: ->
      new Show.Navs
        todos:   @todos
        project: @model

    save: ->
      @model.set @getFormData(), validate:true
      @model.set @getFormData()
      if !@model.validationError
        @model = App.request "save:projects:entity", @model

    getFormData: ->
      Backbone.Syphon.serialize(@projectView)