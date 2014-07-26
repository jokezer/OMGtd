@OMGtd.module "Entities", (Entities, App, Backbone,  Marionette, $, _) ->

  class Entities.Todo extends App.Entities.Model
    url: ->
      u = "/todos/"
      u = "#{u}#{@id}" if this.id
      u
    paramRoot: 'todo'

    @kinds = ['next', 'someday', 'waiting', 'scheduled', 'cycled']
    @states = ['inbox', 'active', 'trash', 'completed']
    @calendars = ['today', 'tomorrow', 'weekly', 'no']
    @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}

    initialize: () ->
      @_setJdate()
      @_setState()
      @on('save', @_setState, @)
      @on('change', @_setState, @)
      @on('change:due_seconds', @_setJdate, @)

    defaults:
      title: ''
      content: ''
      state: 'inbox'
      kind: 'inbox'
      prior: 0
      due: ''

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
      if jDate && jDate < 9999999999
        d = new Date(Number(jDate) * 1000)
        m = d.getMonth()+1
        jDate = d.getFullYear()+'-'+@fd(m)+'-'+@fd(d.getDate())+' '+@fd(d.getHours())+':'+@fd(d.getMinutes())
        @set({due:jDate}, silent:true) #todo set to due?
      else
        @set({due_seconds:9999999999}, silent:true) #use for sorting

    fd: (m) ->
      if m <=9 then '0' + m else m

  class Entities.TodosCollection extends App.Entities.Collection
    model: Entities.Todo
    url: -> '/todos/'

    comparator: (itemA, itemB) =>
      return 1 if itemA.get('prior') < itemB.get('prior')
      if itemA.get('prior') == itemB.get('prior')
        return 1 if itemA.get('due_seconds') > itemB.get('due_seconds')
      return -1

    makeGroups: =>
      @groupedStates = @_groupByA(@, 'state',
        App.request 'todos:entity:states')
      model.groupedKinds = @_groupByA(model.vc, 'kind',
        App.request 'todos:entity:kinds') for model in @groupedStates.models
      model.groupedCalendars = @_groupByA(model.vc, 'calendar',
        App.request 'todos:entity:calendars') for model in @groupedStates.models
      contexts = App.contexts.pluck('id')
      model.groupedContexts = @_groupByA(model.vc, 'context_id',
        contexts) for model in @groupedStates.models
      model.groupedKinds = @_groupByA(model.vc, 'kind',
        App.request 'todos:entity:kinds') for model in @groupedStates.get('active').groupedCalendars.models

#    getWhere: (data) ->
#      todos = @where(data)
#      collection = new TodosCollection
#      collection.reset(todos)
#      collection

    getGroup: (state, group, label) =>
      @makeGroups()
      stateCollection = @groupedStates.get(state)
      switch group
        when 'kind'
          finalCollection = stateCollection.groupedKinds.get(label)
        when 'calendar'
          finalCollection = stateCollection.groupedCalendars.get(label)
        when 'context'
          finalCollection = stateCollection.groupedContexts.get(label)
        when 'kindNoCalendar'
          finalCollection = stateCollection.groupedCalendars.get('no').groupedKinds.get(label)
        else
          #todo return empty collection
          finalCollection = stateCollection
      todos = finalCollection.vc
      todos.comparator = @comparator
#      todos._groupByA = @_groupByA
#      todos.makeGroups = @makeGroups
#      todos.getGroup = @getGroup
      todos.sort()
      return todos
#
#    _makeHref: (arr) ->
#      newArr = arr.filter (item) -> item isnt undefined
#      'filter/' + newArr.join('/')
#
#
#    _makeLabel: (state, label=false) =>
#      label = state unless label
#      return label


    _groupByA: (collection, attr, ids) =>
      Backbone.buildGroupedCollection({
        collection: collection,
        group_ids: ids,
        GroupCollection: Entities.TodosCollection,
        groupBy: (todo) =>
          return todo.get(attr)
      })

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

    getTodoStates: ->
      Entities.Todo.states

    getTodoKinds: ->
      Entities.Todo.kinds

    getTodoCalendars: ->
      Entities.Todo.calendars

    getTodoPriors: ->
      Entities.Todo.priors

    saveTodo: (data) ->
      model = data.model
      model.save({},
        success: (todo, resp) ->
          if Object.keys(resp.errors).length
            todo.validationError = resp.errors
            todo.trigger 'server:error'
          else
            todo.trigger 'server:saved'
        error: ->
          console.log('Server error!')
      )
      model

    destroyTodo: (data) ->
      model = data.model
      model.destroy(
        success: (todo, resp) ->
          if resp == true
            todo.trigger 'server:destroyed'
            console.log 'successful deleted'
        error: ->
          console.log('Server error!')
      )


    getPriorLabel: (key) ->
      Entities.Todo.priors[key]

  App.reqres.setHandler "todos:entities", ->
    API.getTodos()

  App.reqres.setHandler "todos:entity", (id) ->
    API.getTodo id

  App.reqres.setHandler "new:todos:entity", ->
    API.newTodo()

  App.reqres.setHandler "todos:entity:states", ->
    API.getTodoStates()

  App.reqres.setHandler "todos:entity:kinds", ->
    API.getTodoKinds()

  App.reqres.setHandler "todos:entity:calendars", ->
    API.getTodoCalendars()

  App.reqres.setHandler "todos:entity:priors", ->
    API.getTodoPriors()

  App.reqres.setHandler "todos:entity:prior:label", (key) ->
    API.getPriorLabel key

  App.reqres.setHandler "save:todos:entity", (data) ->
    API.saveTodo
      model:      data.model

  App.reqres.setHandler "destroy:todos:entity", (data) ->
    API.destroyTodo
      model:      data.model