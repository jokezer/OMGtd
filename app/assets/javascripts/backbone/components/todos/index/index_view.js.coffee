@OMGtd.module "Components.Todos.Index", (Index, App, Backbone, Marionette, $, _) ->
#
#  class Index.Layout extends Marionette.Layout
#    template: 'components/todos/index/templates/layout'

  class Index.Layout extends Marionette.Layout
    template: 'components/todos/index/templates/group'
    regions:
      groupRegion:   ".group-region"

  class Index.Collection extends Marionette.CollectionView
    itemView: Index.Layout
    onAfterItemAdded: (itemView) ->
      console.log itemView.model.get('todos')
      collectionView = App.request "todos:list", itemView.model.get('todos')
      itemView.groupRegion.show collectionView