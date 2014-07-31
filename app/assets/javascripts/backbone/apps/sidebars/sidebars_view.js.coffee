@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->

  class SidebarsApp.Item extends Marionette.ItemView
    template: 'apps/sidebars/templates/item'
    tagName: 'li'

  class SidebarsApp.Sidebar extends Marionette.CompositeView
    initialize: (data) ->
      @label = data.label

    onRender: ->
      console.log 'render'

    serializeData: ->
      data = {}
      data.label = @label
      data

    events:
      "click a.button.white" : "hideSidebar"

    hideSidebar: ->
      $('#left-sidebar-region').addClass('visible-lg-block')

    itemView: SidebarsApp.Item
    template: 'apps/sidebars/templates/group'
    itemViewContainer: '.nav.nav-pills.nav-stacked'

  class SidebarsApp.Layout extends Marionette.Layout
    template: 'apps/sidebars/templates/layout'
    id:       'left-sidebar-wrapper'
    regions:
      kindsSidebarRegion    : "#kinds-sidebar-region"
      contextsSidebarRegion : "#contexts-sidebar-region"
      projectsSidebarRegion : "#projects-sidebar-region"

    highlightLink: (link) ->
      $('li', @$el).removeClass('active')
      $('a[href="' + link + '"]', @$el).parent().addClass('active')
