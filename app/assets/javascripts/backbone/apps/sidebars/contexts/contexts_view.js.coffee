@OMGtd.module "SidebarsApp.Contexts", (Contexts, App, Backbone, Marionette, $, _) ->

  class Contexts.Item extends Marionette.ItemView
    template: 'apps/sidebars/templates/item'
    tagName: 'li'

  class Contexts.Sidebar extends Marionette.CollectionView
    itemView: Contexts.Item
    tagName: 'ul'
    className: 'nav nav-pills nav-stacked'