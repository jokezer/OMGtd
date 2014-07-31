@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->
  @startWithParent = false

  API =
    showSidebar: ->
      @controller = new SidebarsApp.SidebarController
        region: App.leftSidebarRegion

    highlightLink: (link) ->
      @controller.link = link
      @controller.highlightLink()

  SidebarsApp.on "start", ->
    API.showSidebar()
#    App.todos.on "validated:valid remove", ->
#      API.renderAll()

  App.commands.setHandler "todos:highlightLink", (attr) ->
    href = App.request "todos:link", attr.state, attr.group, attr.label
    link = '/#/todos/filter/' + href
    API.highlightLink link
#    sidebar = $("#left-sidebar-wrapper")
#    $('li', sidebar).removeClass('active')
#    $('a[href="' + link + '"]', sidebar).parent().addClass('active')