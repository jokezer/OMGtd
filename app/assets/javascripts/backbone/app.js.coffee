@OMGtd = do (Backbone, Marionette) ->

  App = new Marionette.Application

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
    @todos = App.request "todos:entities"
    App.execute "when:fetched", @todos, =>
      App.module("SidebarsApp").start()
      App.trigger('todos:loaded')


  App.on "todos:loaded", ->
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()
    @startHistory()
