Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.TodoView extends Backbone.View
  template: JST['todos/todo']

  events:
    "dblclick" : "edit"
    "focusout" : "close"

  tagName: "form"
  className: "draggable panel panel-default panel-todo"

  edit: ->
    @$el.addClass('editing')
    @$el.find('input').focus()

  another: ($el) ->
    console.log($el.find('.edit:focus').length)

  close: ->
    _.delay(@another, 1000, @$el);

  render: ->
    $(@el).addClass("prior-#{Gtd.Models.Todo.priors[@model.get('prior')]}")
    $(@el).html(@template(@model.toJSON() ))
    return this
