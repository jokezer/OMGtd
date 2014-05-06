Gtd.Views.Todos ||= {}

class Gtd.Views.Todos.NewView extends Backbone.View
  template: JST["todos/new"]
  events:
    "submit #new-todo": "save"
    "click a.cancel": "cancel"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind('validated:invalid', (model, errors) =>
      console.log(errors)
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

    @model.set(formData)
    if @model.isValid(true)
      @model.save({},
        success: (todo, jqXHR) =>
          @collection.add(@model)
          @cancel()
        error: (todo, jqXHR) =>
          console.log(jqXHR)
      )
    else
      console.log('render huender')



  cancel: (e=false) ->
    e.preventDefault() if e
    @$el.find('input')
      .not(':button, :submit, :reset, :hidden, :radio')
      .val('')
      .removeAttr('checked')
      .removeAttr('selected');
    @$el.hide()
    @$el.find('textarea').val('')
    $('#createNew').show()

  render: ->
#    Backbone.Validation.bind(@)
    attr = @model.toJSON()
    attr.kinds = Gtd.Models.Todo.kinds
    attr.priors = Gtd.Models.Todo.priors
    $(@el).html(@template(attr))
    @$el.find('#todoDue').datetimepicker({format: 'Y-m-d H:i'})
    return this
