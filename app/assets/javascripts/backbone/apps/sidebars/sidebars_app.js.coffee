@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showLeftSidebar: ->
      new SidebarsApp.Left.Controller
        region: App.leftSidebarRegion
        collection: @leftElements

  SidebarsApp.on "start", ->
    API.showLeftSidebar()