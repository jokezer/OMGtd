Gtd.Views.Sidebar ||= {}

class Gtd.Views.Sidebar.Item extends Backbone.View
  initialize: (attr) ->
    @attr = attr

  template: JST['sidebar/item']

  tagName: "li"
  className: "droppable ui-droppable"

  render: ->
    $(@el).html(@template(@attr))
    return this
