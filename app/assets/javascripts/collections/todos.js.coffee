class Gtd.Collections.Todos extends Backbone.Collection
  model: Gtd.Models.Todo
  url: '/todos'
  initialize: ->
    @makeGroups()

  makeGroups: =>
    @grouped_states = @_groupByA(@, 'state')
    model.grouped_kinds = @_groupByA(model.vc, 'kind_label') for model in @grouped_states.models

  _groupByA: (collection, attr) =>
    @grouped_states = Backbone.buildGroupedCollection({
      collection: collection,
      groupBy: (todo) =>
        return todo.get(attr)
    })