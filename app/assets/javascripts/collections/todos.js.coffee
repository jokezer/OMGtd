class Gtd.Collections.Todos extends Backbone.Collection
  model: Gtd.Models.Todo
  url: '/todos'
  groupByA: (group) =>
    Backbone.buildGroupedCollection({
      collection: @,
      groupBy: (animal) =>
        return animal.get(group)
    })

  groupByKind: (model) =>
    Backbone.buildGroupedCollection({
      collection: model.vc,
      groupBy: (animal) =>
        return animal.get('kind_label')
    })

  subGroup: (collection) =>
    @groupByKind(model) for model in collection.models
