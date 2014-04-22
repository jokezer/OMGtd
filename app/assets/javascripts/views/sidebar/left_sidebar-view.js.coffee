Gtd.Views.Sidebar||= {}

class Gtd.Views.Sidebar.LeftSidebar extends Backbone.View
  template: JST['sidebar/group']

  initialize: (options) ->
    @todos = options.todos
    console.log(@todos)

  tagName: 'ul'
  className: 'nav nav-pills nav-stacked'

  addOne: (attr) =>
    view = new Gtd.Views.Sidebar.Item(attr)
    $(@el).append(view.render().el)

  makeLink: (state, group, label) =>
    col = @todos.getGroup(state, group, label)
    attr = {
      label:  col.label,
      href:   col.href,
      count:  col.length
    }
    view = new Gtd.Views.Sidebar.Item(attr)
    $(@el).append(view.render().el)

  render: ->
    $('#left-sidebar').append($(@el).html(@template()))
    @makeLink('inbox')
    @makeLink('active', 'calendar', 'today')
    @makeLink('active', 'kind', 'next')
    @makeLink('active', 'calendar', 'tomorrow')
    @makeLink('active', 'kind', 'scheduled')
    @makeLink('active', 'kind', 'cycled')
    @makeLink('active', 'kind', 'waiting')
    @makeLink('active', 'kind', 'someday')
    @makeLink('trash')
    @makeLink('completed')
    return this
