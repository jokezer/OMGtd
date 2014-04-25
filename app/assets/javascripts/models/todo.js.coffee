class Gtd.Models.Todo extends Backbone.Model
  url: '/todos'

  constructor: ->
    super
    _.extend(Backbone.Model.prototype, Backbone.Validation.mixin)
    @kinds = ['next', 'someday', 'waiting', 'scheduled', 'cycled']
    @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}

  paramRoot: 'todo'

  defaults:
    title: ''
    content: ''

  validation:
    title:
      required: true
