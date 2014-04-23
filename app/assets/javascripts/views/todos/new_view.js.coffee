Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.NewView extends Backbone.View
  template: JST["todos/new"]
  events:
    "submit #new-todo": "save"
    "click a.cancel": "cancel"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    formData =
      title:   $('#todoTitle').val()
      content: $('#todoContent').val()

    @collection.create(formData,
      success: (todo) =>
        @cancel()
      error: (todo, jqXHR) =>
        console.log(jqXHR.responseText)
    )

  cancel: (e=false) ->
    e.preventDefault() if e
    @$el.remove()
    $('#createNew').show()

  render: ->
    $(@el).html(@template(@model.toJSON()))


    return this
