Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.filterView extends Gtd.Views.Todos.baseIndexView
  template: JST['todos/filter']

  render: =>
    $(@el).html(@template(todos: @options.todos.toJSON(), label:@options.label))
    @addAll()
    return this
