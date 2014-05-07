describe "Todo view", ->

  todo = new Gtd.Models.Todo(id:1, title:'Title of todo')

  beforeEach ->
    @todoView = new Gtd.Views.Todos.TodoView({model : todo})

  it "should be defined", ->
    expect(Gtd.Views.Todos.TodoView).toBeDefined()

  it "should have the right model", ->
    expect(@todoView.model).toEqual todo

  describe "basic elements", ->
    it 'renders the todo name', ->
      expect( @todoView.render().$el.find('h5').text() ).toBe(todo.get('title'))

  describe "Content showing", ->
    it "more content button and hidden additional content when long content", ->
      todo.set({content:'first\n second\n third\n fourth\n fifth\n'})
      expect(@todoView.render().$el.find('.showMore').length).toBe(1)
      expect(@todoView.render().$el.find('.hiddenContent:hidden').length).toBe(1)

    it "more content button and hidden additional content when short content", ->
      todo.set({content:'first\n second\n third'})
      expect(@todoView.render().$el.find('.showMore').length).toBe(0)
      expect(@todoView.render().$el.find('.hiddenContent').length).toBe(0)

    it "trigger the toggleContent method when buttons clicked", ->
      todo.set({content:'first\n second\n third\n fourth\n fifth\n'})
      spyOn(@todoView, 'toggleContent')
      @todoView.delegateEvents()
      @todoView.render().$el.find('.showMore').trigger('click')
      expect(@todoView.toggleContent).toHaveBeenCalled()
      @todoView.render().$el.find('.hideContent').trigger('click')
      expect(@todoView.toggleContent).toHaveBeenCalled()


  describe "CRUD options", ->
    it "check edit event", ->
      spyOn(@todoView, 'edit')
      @todoView.delegateEvents()
      @todoView.render().$el.trigger('dblclick')
    it "add editing class", ->
      @todoView.edit()
      expect(@todoView.$el.hasClass('editing')).toBe(true)


    xit "check saving method"
