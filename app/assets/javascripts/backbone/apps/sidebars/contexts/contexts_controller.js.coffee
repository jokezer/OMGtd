@OMGtd.module "SidebarsApp.Contexts", (Contexts, App, Backbone, Marionette, $, _) ->

  class Contexts.Controller extends App.Controllers.Base

    initialize: () ->
      @render()


    render: ->
      @makeElements()
      contextsView = @getContextsView()
      @show contextsView


    getContextsView: ->
      new App.SidebarsApp.Sidebar
        collection: @collection
        label:      'Contexts'

    makeElements: () ->
      prepared =   App.contexts.map (el) ->
        el.set({
          length: App.todos.where(context_id:el.id, state: 'active').length
          href:   "active/context/#{el.id}"
        })
      @collection = new Backbone.Collection prepared
