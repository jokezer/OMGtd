@OMGtd = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.loaded = {
    todos:    false,
    contexts: false
  }

  App.addRegions
    leftSidebarRegion     : "#left-sidebar-region"
    centralRegion         : "#central-region"
    headerRegion          : "#header-region"
    mainRegion            :	"#main-region"
    footerRegion          : "#footer-region"

  App.rootRoute = "todos"

  App.reqres.setHandler "default:region", ->
    App.mainRegion

  App.addInitializer ->
    @contexts = App.request "contexts:entities"
    App.execute "when:fetched", @contexts, =>
      App.trigger('loaded:contexts')

  App.on "loaded:contexts", ->
    @projects = App.request "projects:entities"
    App.execute "when:fetched", @projects, =>
      App.trigger('loaded:projects')

  App.on "loaded:projects", ->
    @todos = App.request "todos:entities"
    App.execute "when:fetched", @todos, =>
      App.trigger('loaded:finished')

  App.on "loaded:finished", ->
    @todos.makeGroups()
    App.module("SidebarsApp").start()
    @startHistory()
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()