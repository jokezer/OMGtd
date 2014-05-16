do (Marionette) ->
  _.extend Marionette.Renderer,

    render: (template, data) ->
      template = 'backbone/' + template
      path = JST[template]
      throw "Template #{template} not found!" unless path
      path(data)