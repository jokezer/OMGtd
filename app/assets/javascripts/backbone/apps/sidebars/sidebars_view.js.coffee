@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->

  class SidebarsApp.Item extends Marionette.ItemView
    template: 'apps/sidebars/templates/item'
    tagName: 'li'

  class SidebarsApp.Sidebar extends Marionette.CompositeView
    initialize: (data) ->
      @label = data.label
      @linkToEdit = data.linkToEdit

    serializeData: ->
      data = {}
      data.label = @label
      data.linkToEdit = @linkToEdit
      data

    events:
      "click a.button.white" : "hideSidebar"

    hideSidebar: ->
      $('#left-sidebar-region').addClass('visible-lg-block')

    childView: SidebarsApp.Item
    template: 'apps/sidebars/templates/group'
    childViewContainer: '.nav.nav-pills.nav-stacked'

  class SidebarsApp.Layout extends Marionette.LayoutView
    template: 'apps/sidebars/templates/layout'
    id:       'left-sidebar-wrapper'
    regions:
      kindsSidebarRegion    : "#kinds-sidebar-region"
      contextsSidebarRegion : "#contexts-sidebar-region"
      projectsSidebarRegion : "#projects-sidebar-region"

    highlightLink: (link) ->
      $('li', @$el).removeClass('active')
      $('a[href="' + link + '"]', @$el).parent().addClass('active')
