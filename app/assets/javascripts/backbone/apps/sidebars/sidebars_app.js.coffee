@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showLeftSidebar: ->
      new SidebarsApp.Left.Controller
        region: App.leftSidebarRegion
        collection: @leftElements
    showContexts: ->
      new SidebarsApp.Contexts.Controller
        region: App.rightSidebarRegion
        collection: @leftElements


  SidebarsApp.on "start", ->
    API.showLeftSidebar()
    API.showContexts()
    App.todos.on "validated:valid remove", ->
      API.showLeftSidebar()
      API.showContexts()