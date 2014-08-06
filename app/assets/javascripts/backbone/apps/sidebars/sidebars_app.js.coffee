@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showSidebar: ->
      @controller = new SidebarsApp.SidebarController
        region: App.leftSidebarRegion

    highlightLink: (link) ->
      @showSidebar() unless @controller
      @controller.link = link
      @controller.highlightLink()

  SidebarsApp.on "start", ->
    API.showSidebar()
    
  App.commands.setHandler "left_sidebar:highlightLink", (link) ->
    API.highlightLink link