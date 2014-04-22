Gtd.Views.Sidebar||= {}

class Gtd.Views.Sidebar.base extends Backbone.View

  template: JST['sidebar/group']

  initialize: (options) ->
    @options = options

  tagName: 'ul'
  className: 'nav nav-pills nav-stacked'

  addOne: (attr) =>
    view = new Gtd.Views.Sidebar.Item(attr)
    $(@el).append(view.render().el)