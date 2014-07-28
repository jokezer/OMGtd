@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    startAll: ->
      API.showLeftSidebar()
      API.showContextsSidebar()
      API.showProjectsSidebar()

    showLeftSidebar: ->
      new SidebarsApp.Left.Controller
        region: App.leftSidebarRegion
        collection: @leftElements

    showContextsSidebar: ->
      new SidebarsApp.Contexts.Controller
        region: App.contextsSidebarRegion
        collection: @leftElements

    showProjectsSidebar: ->
      new SidebarsApp.Projects.Controller
        region: App.projectsSidebarRegion
#        collection: @leftElements


  SidebarsApp.on "start", ->
    API.startAll()
    App.todos.on "validated:valid remove", ->
      API.startAll()