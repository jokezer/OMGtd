@OMGtd.module "SidebarsApp.Left", (Left, App, Backbone, Marionette, $, _) ->

  class Left.Item extends Marionette.ItemView
    template: 'apps/sidebars/templates/item'
    tagName: 'li'

  class Left.Sidebar extends Marionette.CollectionView
    itemView: Left.Item
    tagName: 'ul'
    className: 'nav nav-pills nav-stacked'
