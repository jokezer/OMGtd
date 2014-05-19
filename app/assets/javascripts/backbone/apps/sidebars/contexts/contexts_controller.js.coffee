@OMGtd.module "SidebarsApp.Contexts", (Contexts, App, Backbone, Marionette, $, _) ->

  class Contexts.Controller extends App.Controllers.Base

    initialize: () ->
      @makeElements App.contexts
      contextsView = @getContextsView()
      @show contextsView

    getContextsView: ->
      new Contexts.Sidebar
        collection: @collection

    makeElements: (elements) ->
      prepared =  elements.map (el) ->
        el.set({
          length: el.get('todos_count')
          href:   "active/context/#{el.id}"
        })
      @collection = new Backbone.Collection prepared
