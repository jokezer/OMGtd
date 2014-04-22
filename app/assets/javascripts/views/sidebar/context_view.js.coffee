Gtd.Views.Sidebar||= {}

class Gtd.Views.Sidebar.ContextSidebar extends Gtd.Views.Sidebar.base

  render: ->
    $('#'+@options.type+'-sidebar').append($(@el).html(@template()))
    @options.collection.each(@makeLink)
    return this

  makeLink: (item) =>
    view = new Gtd.Views.Sidebar.Item(item.attributes)
    $(@el).append(view.render().el)
