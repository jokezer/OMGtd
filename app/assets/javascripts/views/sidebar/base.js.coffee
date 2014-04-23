Gtd.Views.Sidebar||= {}

class Gtd.Views.Sidebar.base extends Backbone.View

  template: JST['sidebar/group']

  initialize: (options) ->
    @options = options
#    @options.todos.bind('add', @erender)

  tagName: 'ul'
  className: 'nav nav-pills nav-stacked'

  addOne: (attr) =>
    view = new Gtd.Views.Sidebar.Item(attr)
    $(@el).append(view.render().el)

#  erender: () =>
#    @render()
#    console.log(@render().el)