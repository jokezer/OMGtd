Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.TodoView extends Backbone.View
  template: JST['todos/todo']

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
