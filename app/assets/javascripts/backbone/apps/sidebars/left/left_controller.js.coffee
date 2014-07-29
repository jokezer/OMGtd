@OMGtd.module "SidebarsApp.Left", (Left, App, Backbone, Marionette, $, _) ->

  class Left.Controller extends App.Controllers.Base

    initialize: () ->
      @makeElements Left.leftElements
      leftView = @getLeftView()
      @show leftView

    getLeftView: ->
      new App.SidebarsApp.Sidebar
        collection: @collection

    makeElements: (elements) ->
      prepared =  elements.map (el) ->
        el.length = App.request "todos:entities:group:count", el.state, el.group, el.label

        el.href = App.request "todos:link", el.state, el.group, el.label

        el.label = el.state unless el.label
        el
      @collection = new Backbone.Collection prepared
