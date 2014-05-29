@OMGtd.module "SidebarsApp.Left", (Left, App, Backbone, Marionette, $, _) ->

  class Left.Controller extends App.Controllers.Base

    initialize: () ->
      @makeElements Left.leftElements
      leftView = @getLeftView()
      @show leftView

    getLeftView: ->
      new Left.Sidebar
        collection: @collection

    makeElements: (elements) ->
      prepared =  elements.map (el) ->
        el.length = App.todos.getGroup(el.state, el.group, el.label).length
        el.href = if el.group then [el.state, el.group, el.label].join('/') else el.state
        el.label = el.state unless el.label
        el
      @collection = new Backbone.Collection prepared
