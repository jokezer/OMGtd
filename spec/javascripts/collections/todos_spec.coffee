describe "Todos collection", ->

  todos = new Gtd.Collections.Todos

  it "should exist", ->
    expect(Gtd.Collections.Todos).toBeDefined()

  it "should use the Restaurant model", ->
    expect(todos.model).toEqual Gtd.Models.Todo

  describe "grouping of todos", ->
    beforeEach: () ->
      @story1 = new Gtd.Models.Todo(title:'First todo',  kind:'next')
      @story2 = new Gtd.Models.Todo(title:'Second todo', kind:'next')
      @story3 = new Gtd.Models.Todo(title:'Third todo',  kind:'next')
      @story4 = new Gtd.Models.Todo(title:'Fourth todo', kind:'next')
      @story5 = new Gtd.Models.Todo(title:'Fifth todo',  kind:'next')