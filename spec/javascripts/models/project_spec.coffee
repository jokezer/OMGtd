describe "Project Model", ->

  it "should exist", ->
    expect(OMGtd.Entities.Project).toBeDefined()

  describe "Attributes", ->
    project = new OMGtd.Entities.Project

    it "should have default attributes", ->
      expect(project.attributes.title).toBeDefined()
      expect(project.attributes.content).toBeDefined()
      expect(project.attributes.state).toBe('active')

  describe "todos", ->

    project = new OMGtd.Entities.Project
    project.id = 23

    @todo1 = new OMGtd.Entities.Todo(title:'First todo',    project_id: project.id)
    @todo2 = new OMGtd.Entities.Todo(title:'Second todo',   project_id: project.id)
    @todo3 = new OMGtd.Entities.Todo(title:'Third todo',    project_id: project.id)
    @todo4 = new OMGtd.Entities.Todo(title:'Four todo')
    @todo5 = new OMGtd.Entities.Todo(title:'Fifth todo')
    OMGtd.todos = new OMGtd.Entities.TodosCollection([@todo2, @todo3, @todo1, @todo4, @todo5])

    it "has getTodos method", ->
      expect(project.getTodos).toBeDefined()

    it "getTodos method adds todos property with todos collection", ->
      project.getTodos()
      expect(project.todos).toBeDefined()
      expect(project.todos.length).toBe(3)

  xdescribe "todos manipulation"
