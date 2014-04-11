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
    model.grouped_vc = Backbone.buildGroupedCollection({
      collection: model.vc,
      groupBy: (animal) =>
        return animal.get('kind_label')
    })

  subGroup: =>
    collection = @groupByA('state')
    @groupByKind(model) for model in collection.models
    return collection
