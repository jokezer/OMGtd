@OMGtd = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.loaded = {
    todos:    false,
    contexts: false
  }

  App.addRegions
    headerRegion          : "#header-region"
    mainRegion            :	"#main-region"
    footerRegion          : "#footer-region"
    leftSidebarRegion     : "#left-sidebar-region"
    centralRegion         : "#central-region"
    rightSidebarRegion    : "#right-sidebar-region"

  App.rootRoute = "todos"

  App.reqres.setHandler "default:region", ->
    App.mainRegion

  App.addInitializer ->
    @contexts = App.request "contexts:entities"
    App.execute "when:fetched", @contexts, =>
      App.trigger('loaded:contexts')

    @todos = App.request "todos:entities"
    App.execute "when:fetched", @todos, =>
      App.trigger('loaded:todos')


  App.on "loaded:contexts", ->
    App.loaded.contexts = true
    App.trigger('loaded:something')

  App.on "loaded:todos", ->
    App.loaded.todos = true
    App.trigger('loaded:something')

  App.on "loaded:something", ->
    if App.loaded.contexts && App.loaded.todos
      App.trigger('loaded:finished')

  App.on "loaded:finished", ->
    App.module("SidebarsApp").start()
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()
    @startHistory()