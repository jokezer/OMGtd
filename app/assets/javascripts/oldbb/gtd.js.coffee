window.Gtd =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    _.extend(Backbone.Model.prototype, Backbone.Validation.mixin)
    console.log 'Hello from Backbone!'