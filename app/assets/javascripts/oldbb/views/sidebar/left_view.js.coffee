Gtd.Views.Sidebar||= {}

class Gtd.Views.Sidebar.LeftSidebar extends Gtd.Views.Sidebar.base

  makeLink: (state, group, label) =>
    col = @options.todos.getGroup(state, group, label)
    view = new Gtd.Views.Sidebar.Item(col)
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
