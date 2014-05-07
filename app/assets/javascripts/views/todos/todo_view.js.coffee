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
    saveTodo =  ($el) ->
      unless $el.find('.edit:focus').length
        $el.removeClass('editing')
        $el.find('.textarea').trigger('autosize.destroy');
    _.delay(saveTodo, 1000, @$el);

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
