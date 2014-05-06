Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.TodoView extends Backbone.View
  template: JST['todos/todo']

  events:
    "dblclick" : "edit"
    "focusout" : "close"
    "submit"   : "update"

  tagName: "form"
  className: "draggable panel panel-default panel-todo"

  edit: ->
    unless @$el.hasClass('editing')
      @$el.addClass('editing')
      @$el.find('input').focus()

  close: ->
    saveTodo =  ($el) ->
      unless $el.find('.edit:focus').length
        $el.removeClass('editing')
    _.delay(saveTodo, 1000, @$el);

  render: ->
    $(@el).addClass("prior-#{Gtd.Models.Todo.priors[@model.get('prior')]}")
    $(@el).html(@template(@model.toJSON() ))
    return this
