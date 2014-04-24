class Gtd.Models.Todo extends Backbone.Model
  url: '/todos'
  paramRoot: 'todo'
  defaults: {
    title: '',
    content: ''
  }
  constructor: ->
    super
    @kinds = ['next', 'someday', 'waiting', 'scheduled', 'cycled']
    @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}