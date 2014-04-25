describe "Todo Model", ->

  it "should exist", ->
    expect(Gtd.Models.Todo).toBeDefined()

  describe "Attributes", ->
    todo = new Gtd.Models.Todo

    it "should have default attributes", ->
      expect(todo.attributes.title).toBeDefined()
      expect(todo.attributes.content).toBeDefined()

  describe "Validations", ->
    attrs = {}
    describe "with correct data", ->
      ritz = new Gtd.Models.Todo {title:'Correct todo', kind:'next'}
      it "is correct", ->
        expect(ritz.isValid(true)).toBe(true)

    describe "with incorrect data", ->
      beforeEach ->
        attrs =
          title: 'New todo'
          content: 'Content of new todo'
          kind: 'next'

      afterEach ->
        ritz = new Gtd.Models.Todo attrs
        expect(ritz.isValid(true)).toBe(false)

      it "should validate the presence of title", ->
        attrs["title"] = null

  #    it "should validate the state of todo", ->
  #      attrs["state"] = 'incorrect'
  #
  #    it "should validate the kind of todo", ->
  #      attrs["kind"] = 'incorrect'
  #
  #    it "should have due inserted if kind is scheduled", ->
  #      attrs["kind"] = 'scheduled'
  #      attrs["due"]  = null
  #
  #    it "should have due inserted if kind is cycled", ->
  #      attrs["kind"] = 'cycled'
  #      attrs["due"]  = null