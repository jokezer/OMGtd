@OMGtd.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.Context extends App.Entities.Model
    url: ->
      u = "/contexts/"
      u = "#{u}#{@id}" if this.id
      u
    paramRoot: 'context'

    validation:
      name:
        required: true


  class Entities.ContextsCollection extends App.Entities.Collection
    model: Entities.Context
    url: -> '/contexts/'

  API =
    getContexts: ->
      contexts = new Entities.ContextsCollection
      contexts.fetch
        reset: true
      contexts

    getContext: (id) ->
      context = new Entities.Context
        id: id
      context.fetch()
      context

    newContext: ->
      new Entities.Context

  App.reqres.setHandler "contexts:entities", ->
    API.getContexts()

  App.reqres.setHandler "contexts:entity", (id) ->
    API.getContext id

  App.reqres.setHandler "new:contexts:entity", ->
    API.newContext()