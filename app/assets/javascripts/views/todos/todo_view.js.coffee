Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.TodoView extends Backbone.View
  template: JST['todos/todo']

  events:
    "click .destroy" : "destroy"

  tagName: "div"
  className: "draggable panel panel-default panel-todo"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    #_todo prior
    $(@el).addClass("prior-#{this.model.attributes.prior_name}")
    $(@el).html(@template(@model.toJSON() ))
    return this
