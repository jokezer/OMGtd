@OMGtd.module "SidebarsApp", (SidebarsApp, App, Backbone, Marionette, $, _) ->

  class SidebarsApp.Item extends Marionette.ItemView
    template: 'apps/sidebars/templates/item'
    tagName: 'li'

  class SidebarsApp.Sidebar extends Marionette.CompositeView
    initialize: (data) ->
      @label = data.label

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

    #todo: put it to the view
    App.commands.setHandler "todos:highlightLink", (attr) ->
      arr = [attr.state, attr.group, attr.label]
      newArr = arr.filter (item) -> !!item
      link = '/#/todos/filter/' + newArr.join('/')
      sidebar = $("#left-sidebar-wrapper")
      $('li', sidebar).removeClass('active')
      $('a[href="' + link + '"]', sidebar).parent().addClass('active')