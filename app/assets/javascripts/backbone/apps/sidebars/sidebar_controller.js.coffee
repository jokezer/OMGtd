@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->

  class SidebarsApp.SidebarController extends App.Controllers.Base
    link: false
    initialize: () ->
      @layout = @getLayoutView()
      @show @layout
      @showAll()
      #todo optimize it
      @listenTo App.todos, 'validated:valid remove', (ev) ->
        @showAll()
        @highlightLink()

    getLayoutView: ->
      new SidebarsApp.Layout

    getCollectionView: (collection, label=false, linkToEdit=false) ->
      new App.SidebarsApp.Sidebar
        collection: collection
        label:      label
        linkToEdit: linkToEdit

    highlightLink: ->
      @layout.highlightLink @link

    showAll: ->
      @showKinds()
      @showContexts()
      @showProjects()

    showKinds: ->
      collection = @getCollection 'kinds'
      collectionView = @getCollectionView(collection)
      @layout.kindsSidebarRegion.show collectionView

    showContexts: ->
      return unless App.contexts.length
      collection = @getCollection 'context'
      collectionView = @getCollectionView(collection, 'Context')
      @layout.contextsSidebarRegion.show collectionView

    showProjects: ->
      return unless App.projects.length
      collection = @getCollection 'project'
      collectionView = @getCollectionView(collection, 'Project', 'projects')
      @layout.projectsSidebarRegion.show collectionView

    getCollection: (label) ->
      if label=='kinds'
        prepared =  SidebarsApp.leftElements.map (el) ->
          el.length = App.request "todos:entities:group:count", el.state, el.group, el.label
          el.href =   'todos/filter/' + App.request "todos:link", el.state, el.group, el.label
          el.label =  el.state unless el.label
          el
      else if label=='project'
        prepared =   App.projects.withState('active').map (el) ->
          el.set
            length: App.todos.where(project_id:el.id, state: 'active').length
            href:   "project/#{el.id}"
      else if label=='context'
        prepared =   App.contexts.map (el) ->
          el.set
            length: App.todos.where(context_id:el.id, state: 'active').length
            href:   "todos/filter/active/context/#{el.id}"
      new Backbone.Collection prepared
