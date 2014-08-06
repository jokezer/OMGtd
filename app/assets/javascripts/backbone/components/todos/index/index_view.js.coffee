@OMGtd.module "Components.Todos.Index", (Index, App, Backbone, Marionette, $, _) ->
#
#  class Index.Layout extends Marionette.LayoutView
#    template: 'components/todos/index/templates/layout'

  class Index.Layout extends Marionette.LayoutView
    template: 'components/todos/index/templates/group'
    regions:
      groupRegion:   ".group-region"

  class Index.Collection extends Marionette.CollectionView
    childView: Index.Layout
    onAddChild: (childView) ->
      collectionView = App.request "todos:list", childView.model.get('todos')
      childView.groupRegion.show collectionView