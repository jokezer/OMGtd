describe "New todo view", ->

  todos = [{id: 0, title: 'first'}, {id:1, title: 'first'}, {id:2, title: 'first'}]
  collection = new Gtd.Collections.Todos()
  collection.reset(todos)

  beforeEach ->
    @newForm = new Gtd.Views.Todos.NewView(collection: collection)

  it "should be defined", ->
    expect(Gtd.Views.Todos.NewView).toBeDefined()

  it "should have the right collection", ->
    expect(@newForm.collection).toEqual collection