class Gtd.Collections.Todos extends Backbone.Collection
  model: Gtd.Models.Todo
  url: '/todos'
  initialize: () ->
    @on('sync', @makeGroups, @)
    @on('reset', @makeGroups, @)

  comparator: (itemA, itemB) =>
    if itemA.get('prior') == itemB.get('prior')
      return 1 if itemA.get('due_seconds') > itemB.get('due_seconds')
    return 1 if itemA.get('prior') < itemB.get('prior')
    return 0

  makeGroups: =>
    @groupedStates = @_groupByA(@, 'state')
    model.groupedKinds = @_groupByA(model.vc, 'kind') for model in @groupedStates.models
    model.groupedCalendars = @_groupByA(model.vc, 'schedule_label') for model in @groupedStates.models

  getGroup: (state, group, label) =>
    todos = new Gtd.Collections.Todos()
    stateCollection = @groupedStates.get(state)
    switch group
      when 'kind'
        finalCollection = stateCollection.groupedKinds.get(label)
      when 'calendar'
        finalCollection = stateCollection.groupedCalendars.get(label)
      else
        finalCollection = stateCollection
    todos = finalCollection.vc if finalCollection
    todos.href = @_makeHref([state, group, label])
    todos.label = @_makeLabel(state, label)
    return todos

  _makeHref: (arr) ->
    newArr = arr.filter (item) -> item isnt undefined
    'filter/' + newArr.join('/')


  _makeLabel: (state, label=false) =>
    label = state unless label
    return label


  _groupByA: (collection, attr) =>
    Backbone.buildGroupedCollection({
      collection: collection,
      groupBy: (todo) =>
        return todo.get(attr)
    })