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
    App.module("SidebarsApp").start()


  App.on "initialize:after", ->
    @navigate(@rootRoute, trigger: true) unless @getCurrentRoute()
    @startHistory()
