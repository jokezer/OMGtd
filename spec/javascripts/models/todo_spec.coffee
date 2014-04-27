describe "Todo Model", ->

  it "should exist", ->
    expect(Gtd.Models.Todo).toBeDefined()

  describe "Attributes", ->
    todo = new Gtd.Models.Todo

    it "should have default attributes", ->
      expect(todo.attributes.title).toBeDefined()
      expect(todo.attributes.content).toBeDefined()

  describe "states and kinds", ->
    it "set state to active if kind is not inbox on create", ->
      todo = new Gtd.Models.Todo {title:'Correct todo', kind:'next'}
      expect(todo.attributes.state).toBe('active')
    it "set state to active if kind is not inbox on update", ->
      todo = new Gtd.Models.Todo {title:'Correct todo'}
      todo.set({kind:'next'})
      expect(todo.get('state')).toBe('active')

  describe "Validations", ->
    attrs = {}
    describe "with correct data", ->

      it "is correct", ->
        todo = new Gtd.Models.Todo {title:'Correct todo', kind:'next'}
        expect(todo.isValid(true)).toBe(true)

      it "have state inbox and kind inbox by default", ->
        todo = new Gtd.Models.Todo {title:'Correct todo'}
        expect(todo.attributes.state).toBe('inbox')
        expect(todo.attributes.kind).toBe('')


    describe "with incorrect data", ->
      beforeEach ->
        attrs =
          title:    'New todo'
          content:  'Content of new todo'
          kind:     'next'

      afterEach ->
        ritz = new Gtd.Models.Todo attrs
        expect(ritz.isValid(true)).toBe(false)

      it "should validate the presence of title", ->
        attrs["title"] = null

      it "should validate the kind", ->
        attrs["kind"] = 'incorrect'

      it "should validate the prior", ->
        attrs["prior"] = 'incorrect'

      it "should have due inserted if kind is scheduled", ->
        attrs["kind"] = 'scheduled'
        attrs["due"]  = null

      it "should have due inserted if kind is cycled", ->
        attrs["kind"] = 'cycled'
        attrs["due"]  = null