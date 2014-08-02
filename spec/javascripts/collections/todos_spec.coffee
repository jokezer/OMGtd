describe "Todos collection", ->

  todos = new OMGtd.Entities.TodosCollection

  it "should exist", ->
    expect(OMGtd.Entities.TodosCollection).toBeDefined()

  it "should use the Restaurant model", ->
    expect(todos.model).toEqual OMGtd.Entities.Todo

  describe "filter", ->
    beforeEach ->
      @collection = new OMGtd.Entities.TodosCollection()
      @todo1 = new OMGtd.Entities.Todo(title:'First todo')
      @todo2 = new OMGtd.Entities.Todo(title:'Second todo', kind:'next')
      @todo3 = new OMGtd.Entities.Todo(title:'Third todo',  kind:'scheduled', schedule_label:'today')
      @todo4 = new OMGtd.Entities.Todo(title:'Fourth todo', kind:'next',      schedule_label:'tomorrow')
      @todo5 = new OMGtd.Entities.Todo(title:'Fifth todo',  kind:'someday')
      @todo6 = new OMGtd.Entities.Todo(title:'Sixth todo',  kind:'someday')
      @collection.reset([@todo1, @todo2, @todo3, @todo4, @todo5, @todo6])

#    it "by state", ->
#      todos = @collection.getGroup('inbox')
#      expect(todos.at(0)).toBe(@todo1)
#      expect(todos.length).toBe(1)

#    it "by calendar", ->
#      todos = @collection.getGroup('active', 'calendar', 'today')
#      expect(todos.at(0)).toBe(@todo3)
#      expect(todos.length).toBe(1)
##
#    it "by kind", ->
#      todos = @collection.getGroup('active', 'kind', 'someday')
#      expect(todos.at(0)).toBe(@todo5)
#      expect(todos.length).toBe(2)

  describe "order", ->
    beforeEach ->
      @collection = new OMGtd.Entities.TodosColletionShow()
      @todo1 = new OMGtd.Entities.Todo(title:'First todo', prior:3, due_seconds:1111111111)
      @todo2 = new OMGtd.Entities.Todo(title:'First todo', prior:3)
      @todo3 = new OMGtd.Entities.Todo(title:'First todo', prior:2, due_seconds:1111111111)
      @todo4 = new OMGtd.Entities.Todo(title:'First todo', prior:2, due_seconds:2222222222)
      @todo5 = new OMGtd.Entities.Todo(title:'First todo', prior:0, due_seconds:1111111111)
      @collection.reset([@todo2, @todo3, @todo1, @todo4, @todo5])
      @collection.sort()

    it "check order", ->
      expect(@collection.at(0)).toBe(@todo1)
      expect(@collection.at(1)).toBe(@todo2)
      expect(@collection.at(2)).toBe(@todo3)
      expect(@collection.at(3)).toBe(@todo4)
      expect(@collection.at(4)).toBe(@todo5)