Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.TodoView extends Backbone.View
  template: JST['todos/todo']
  events:
    "dblclick" : "edit"
    "focusout" : "close"
    "click .showMore"   : "toggleContent"
    "click .hideContent"   : "toggleContent"

  tagName: "form"
  className: "draggable panel panel-default panel-todo"

  edit: ->
    unless @$el.hasClass('editing')
      @$el.addClass('editing')
      @$el.find('textarea').autosize().trigger('autosize.resize')
      @$el.find('input').focus()

  close: ->
    saveTodo =  (view) ->
      unless view.$el.find('.edit:focus').length
        view.$el.removeClass('editing').addClass('saving')
        view.$el.find('.textarea').trigger('autosize.destroy')
        view.save()
    _.delay(saveTodo, 1000, @);

  #todo merge with new_view
  save: ->
    formData =
      title: $('input.panel-title', @$el).val()
      content: $('textarea.edit', @$el).val()

    @model.set(formData)
    if @model.isValid(true)
      @model.save({},
        success: (todo, jqXHR) =>
          @render()
        error: (todo, jqXHR) =>
          console.log(jqXHR)
      )
    else
      alert('dver zapilil')

  _setContent: ->
    content = @model.get('content')
    if content
      content = content.split('\n')
      result = {visible:content[0..2]}
      result.hidden = content[3..content.length-1] if content.length > 3
      return result

  toggleContent: ->
    @$el.find('.showMore').toggle()
    @$el.find('.hiddenContent').toggle()

  render: ->
    @$el.addClass("prior-#{Gtd.Models.Todo.priors[@model.get('prior')]}")
    data = @model.toJSON()
    data.groupedContent = @_setContent()
    @$el.html(@template(data))
    return this
