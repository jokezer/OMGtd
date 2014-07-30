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
      kind: ''
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

    makeGroups: =>
      @groupedStates = @_groupByA(@, 'state',
        App.request 'todos:entity:states')
      model.groupedKinds = @_groupByA(model.vc, 'kind',
        App.request 'todos:entity:kinds') for model in @groupedStates.models
      model.groupedCalendars = @_groupByA(model.vc, 'calendar',
        App.request 'todos:entity:calendars') for model in @groupedStates.models
      if App.contexts
        contexts = App.contexts.pluck('id')
        model.groupedContexts = @_groupByA(model.vc, 'context_id',
          contexts) for model in @groupedStates.models
      model.groupedKinds = @_groupByA(model.vc, 'kind',
        App.request 'todos:entity:kinds') for model in @groupedStates.get('active').groupedCalendars.models

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
      finalCollection.vc

#    _makeLabel: (state, label=false) =>
#      label = state unless label
#      return label

    _groupByA: (collection, attr, ids) =>
      Backbone.buildGroupedCollection({
        collection: collection,
        group_ids: ids,
#        GroupCollection: Entities.TodosCollection,
        groupBy: (todo) =>
          return todo.get(attr)
      })

  class TodosColletionShow extends Backbone.PageableCollection
    model: Entities.Todo
    mode: 'client'
    state:
      pageSize: 5

    comparator: (itemA, itemB) =>
      return 1 if itemA.get('prior') < itemB.get('prior')
      if itemA.get('prior') == itemB.get('prior')
        return 1 if itemA.get('due_seconds') > itemB.get('due_seconds')
      return -1


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

    getGroup: (attr) ->
      attr.todos = App.todos unless attr.todos
      attr.state = 'active' unless attr.state
      vc = App.todos.getGroup(attr.state, attr.group, attr.label)
      _.extend(vc, new TodosColletionShow vc.toArray())
      vc.setPageSize(3)
      vc

    getGroupCount: (state, group, label) ->
      App.todos.getGroup(state, group, label).length

    saveTodo: (data) ->
      model =   data.model
      action =  data.action
      model.save({},
        success: (todo, resp) ->
          if Object.keys(resp.errors).length
            todo.validationError = resp.errors
            todo.trigger 'server:error'
            App.todos.remove(model) if action == 'new'
          else
            todo.trigger 'server:saved'
        error: (a, b) ->
          alert 'connection error'
      )
      if action == 'new' and !model.validationError
        App.todos.add(model)
        model.trigger 'reSort'
      model

    destroyTodo: (data) ->
      model = data.model
      model.destroy(
        success: (todo, resp) ->
          if resp == true
            todo.trigger 'server:destroyed'
        error: ->
          alert 'connection error'
      )

    makeLink: (state, group, label) ->
      arr = [state, group, label]
      newArr = arr.filter (item) -> !!item
      newArr.join('/')


    getPriorLabel: (key) ->
      Entities.Todo.priors[key]

  App.reqres.setHandler "todos:entities", ->
    API.getTodos()

  App.reqres.setHandler "todos:entities:group", (data) ->
    API.getGroup data

  App.reqres.setHandler "todos:entities:group:count", (state, group, label) ->
    API.getGroupCount state, group, label

  App.reqres.setHandler "todos:entity", (id) ->
    API.getTodo id

  App.reqres.setHandler "new:todos:entity", ->
    API.newTodo()

  App.reqres.setHandler "save:todos:entity", (data) ->
    API.saveTodo
      model:      data.model
      action:     data.action

  App.reqres.setHandler "destroy:todos:entity", (data) ->
    API.destroyTodo
      model:      data.model

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

  App.reqres.setHandler "todos:link", (state, group, label) ->
    API.makeLink state, group, label