class Gtd.Models.Todo extends Backbone.Model
  url: '/todos'
  paramRoot: 'todo'

  @kinds = ['next', 'someday', 'waiting', 'scheduled', 'cycled']
  @states = ['inbox', 'active', 'trash', 'completed']
  @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}

  initialize: () ->
    @_setState()
    @on('save', @_setState, @)
    @on('change', @_setState, @)

  defaults:
    title: ''
    content: ''
    state: 'inbox'
    kind: ''

  validation:
    title:
      required: true
    kind:
      required: false
      oneOf: @kinds
    prior:
      required: false
      range: [0, 3]
    due: (value, attr, object) ->
      if object.kind == 'cycled' || object.kind == 'scheduled'
        return 'Due is required!' unless value

  _setState: () ->
    if @attributes.state=='inbox' and !!@attributes.kind
      @set({state:'active'}, silent:true)
