class Gtd.Collections.Todos extends Backbone.Collection
  model: Gtd.Models.Todo
  url: '/todos'

  makeGroups: =>
    @groupedStates = @_groupByA(@, 'state')
    model.groupedKinds = @_groupByA(model.vc, 'kind_label') for model in @groupedStates.models
    model.groupedCalendars = @_groupByA(model.vc, 'schedule_label') for model in @groupedStates.models

  getGroup: (state, group, label) =>
    todos = new Gtd.Collections.Todos()
    stateCollection = @groupedStates.get(state)
    switch group
      when 'kind'
        kindCollection = stateCollection.groupedKinds.get(label)
        todos = kindCollection.vc if kindCollection
      when 'calendar'
        calendarCollection = stateCollection.groupedCalendars.get(label)
        todos = calendarCollection.vc if calendarCollection
      else
        todos = stateCollection.vc if stateCollection
    return todos

  _groupByA: (collection, attr) =>
    Backbone.buildGroupedCollection({
      collection: collection,
      groupBy: (todo) =>
        return todo.get(attr)
    })