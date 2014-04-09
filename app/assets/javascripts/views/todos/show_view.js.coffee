Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.ShowView extends Backbone.View
  template: JST["backbone-old/templates/todos/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
