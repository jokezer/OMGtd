@OMGtd.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Todo extends App.Entities.Model
    url: ->
      u = "/todos/"
      u = "#{u}#{@id}" if this.id
      u
    paramRoot: 'todo'

    @kinds = ['next', 'someday', 'waiting', 'scheduled', 'cycled']
    @states = ['inbox', 'active', 'trash', 'completed']
    @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}

    initialize: () ->
      @_setJdate()
      @_setState()
      @on('save', @_setState, @)
      @on('change', @_setState, @)
      @on('save', @_setJdate, @)
      @on('change', @_setJdate, @)
      @bind('validated:invalid', (model, errors) ->
        console.log(errors))


    defaults:
      title: ''
      content: ''
      state: 'inbox'
      kind: ''
      prior: 0

    validation:
      title:
        required: true
      kind:
        required: false
        oneOf: @kinds
      prior:
        required: false
        range: [0, 3]
      due: (value, attr, object) ->
        if object.kind == 'cycled' || object.kind == 'scheduled'
          return 'Due is required!' unless value

    _setState: () ->
      if @attributes.state=='inbox' and !!@attributes.kind
        @set({state:'active'}, silent:true)

    _setJdate: () ->
      jDate = @get('due_seconds')
      if jDate
        jDate = new Date(Number(jDate) * 1000);
        @set({jdue:jDate}, silent:true) #todo set to due?
      else
        @set({due_seconds:9999999999}, silent:true) #use for sorting


  class Entities.TodosCollection extends App.Entities.Collection
    model: Entities.Todo
    url: -> '/todos/'
    initialize: () ->
      @on('sync', @makeGroups, @)
      @on('reset', @makeGroups, @)

    comparator: (itemA, itemB) =>
      return 1 if itemA.get('prior') < itemB.get('prior')
      if itemA.get('prior') == itemB.get('prior')
        return 1 if itemA.get('due_seconds') > itemB.get('due_seconds')
      return 0

    makeGroups: =>
      @groupedStates = @_groupByA(@, 'state')
      model.groupedKinds = @_groupByA(model.vc, 'kind') for model in @groupedStates.models
      model.groupedCalendars = @_groupByA(model.vc, 'schedule_label') for model in @groupedStates.models
      model.groupedContexts = @_groupByA(model.vc, 'context_id') for model in @groupedStates.models

    getGroup: (state, group, label) =>
      todos = new Gtd.Collections.Todos()
      stateCollection = @groupedStates.get(state)
      switch group
        when 'kind'
          finalCollection = stateCollection.groupedKinds.get(label)
        when 'calendar'
          finalCollection = stateCollection.groupedCalendars.get(label)
        when 'context'
          finalCollection = stateCollection.groupedContexts.get(label)
        else
          #todo return empty collection
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

    consolelog: () ->
      console.log('sorted')

  API =
    getTodos: ->
      todos = new Entities.TodosCollection
      todos.fetch
        reset: true
      todos

    getTodo: (id) ->
      todo = new Entities.Todo
        id: id
      todo.fetch()
      todo

    newTodo: ->
      new Entities.Todo

  App.reqres.setHandler "todos:entities", ->
    API.getTodos()

  App.reqres.setHandler "todos:entity", (id) ->
    API.getTodo id

  App.reqres.setHandler "new:todos:entity", ->
    API.newTodo()