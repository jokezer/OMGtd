@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends App.Controllers.Base
    initialize: (data) ->
      @model     = data.project
      @todos       = data.todos
      @layout      = @getLayoutView()
      @projectView = @getItemView()
      @listenTo @projectView, 'save', @save
      @show @layout
      @showAll()

    showAll: ->
      @layout.projectRegion.show @projectView
      @layout.projectTodosRegion.show @getTodosIndex()

    getItemView: ->
      new Show.Item
        model: @model

    getLayoutView: ->
      new Show.Layout

    getTodosIndex: ->
      App.request "todos:index",
        todos: @todos

    save: ->
      @model.set @getFormData(), validate:true
      @model.set @getFormData()
      if !@model.validationError
        @model = App.request "save:projects:entity", @model

    getFormData: ->
      Backbone.Syphon.serialize(@projectView)