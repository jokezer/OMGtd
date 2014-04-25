class Gtd.Models.Todo extends Backbone.Model
  url: '/todos'
  paramRoot: 'todo'

  @kinds: ['inbox', 'next', 'someday', 'waiting', 'scheduled', 'cycled']
  @states = ['inbox', 'active', 'trash', 'completed']
  @priors = {0: 'none', 1: 'low', 2: 'medium', 3: 'high'}

  initialize: () ->
    @_setState()
    @on('change', @_setState, @)

  defaults:
    title: ''
    content: ''
    state: 'inbox'
    kind: 'inbox'

  validation:
    title:
      required: true
    kind:
      oneOf: @kinds
    prior:
      required: false
      range: [0, 3]
    due: (value, attr, object) ->
      if object.kind == 'cycled' || object.kind == 'scheduled'
        return 'Due is required!' unless value

  _setState: () ->
    state = @get('state')
    kind = @get('kind')
    @set({state:'active'}, silent:true) if state=='inbox' and kind!='inbox'