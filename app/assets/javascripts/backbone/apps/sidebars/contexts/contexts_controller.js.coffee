@OMGtd.module "SidebarsApp.Contexts", (Contexts, App, Backbone, Marionette, $, _) ->

  class Contexts.Controller extends App.Controllers.Base

    initialize: () ->
      @render()


    render: ->
      @makeElements()
      contextsView = @getContextsView()
      @show contextsView


    getContextsView: ->
      new Contexts.Sidebar
        collection: @collection

    makeElements: () ->
      prepared =   App.contexts.map (el) ->
        el.set({
          length: App.todos.getGroup('active', 'context', el.id).length
          href:   "active/context/#{el.id}"
        })
      @collection = new Backbone.Collection prepared
