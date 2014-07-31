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
    
  App.commands.setHandler "todos:highlightLink", (attr) ->
    href = App.request "todos:link", attr.state, attr.group, attr.label
    link = '/#/todos/filter/' + href
    API.highlightLink link