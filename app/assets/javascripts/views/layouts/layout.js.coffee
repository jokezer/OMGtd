class Gtd.Views.Layout extends Backbone.View
  template: JST['layouts/layout']
  initialize: (options) ->
    @options = options

  events :
    "click #createNew" : "createNew"

  renderSidebars: ->
    left_sidebar = new Gtd.Views.Sidebar.LeftSidebar(todos: @options.todos)
    @$el.find('#left-sidebar').append(left_sidebar.render().el)
    #contexts
    contexts = new Gtd.Collections.Contexts
    p = contexts.fetch()
    p.done ->
      context_sidebar = new Gtd.Views.Sidebar.ContextSidebar(todos:contexts, type:'contexts')
      context_sidebar.render()
    #projects
    projects = new Gtd.Collections.Projects
    p = projects.fetch()
    p.done ->
      context_sidebar = new Gtd.Views.Sidebar.ContextSidebar(todos:projects, type:'projects')
      context_sidebar.render()

  createNew: (e) ->
    e.preventDefault()
    $('#createNew').hide()
    @newForm.$el.show()

  renderNewForm: () ->
    @newForm = new Gtd.Views.Todos.NewView(collection: @options.todos)
    @newForm.$el.hide()
    @$el.find('#createNew').after(@newForm.render().el)

  render: =>
    $(@el).html(@template())
    @renderSidebars()
    @renderNewForm()
    return this