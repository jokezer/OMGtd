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
      kind:   $("input[type='radio'][name='todo[kind]']:checked").val()
      prior:   $("input[type='radio'][name='todo[prior]']:checked").val()
      due: $('#todoDue').val()

    @collection.create(formData,
      success: (todo) =>
        @cancel()
      error: (todo, jqXHR) =>
        console.log(jqXHR.responseText)
    )

  cancel: (e=false) ->
    e.preventDefault() if e
    @$el.find('input')
      .not(':button, :submit, :reset, :hidden')
      .val('')
      .removeAttr('checked')
      .removeAttr('selected');
    @$el.hide()
    $('#createNew').show()

  render: ->
    attr = @model.toJSON()
    attr.kinds = Gtd.Models.Todo.kinds
    attr.priors = Gtd.Models.Todo.priors
    $(@el).html(@template(attr))
    @$el.find('#todoDue').datetimepicker({format: 'Y-m-d H:i'})
    return this
