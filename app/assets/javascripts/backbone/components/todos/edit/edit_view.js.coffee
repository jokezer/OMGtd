@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    tagName: 'form'

    events:
      'click .change-prior label'       : 'changePrior'
#      'mouseleave'                      : 'leaveElement'
#      'focusout'                        : 'leaveElement'
      'click .save'                    : 'save'
      'click .cancel'                  : 'cancelEdit'
      'click .trash'                   : 'saveTrash'
      'click .complete'                : 'saveComplete'
      'click .activate'                : 'saveActivated'
      'click .makeProject'             : 'saveMakeProject'
      'click button.showConfirmDelete'  : 'showConfirmDelete'
      'click button.hideConfirmDelete'  : 'hideConfirmDelete'
      'click button.confirmDelete'      : 'destroy'
      'click label.kind'                : 'toggleInterval'

    initialize: (model) ->
      @model = model

    toggleInterval: (el) ->
      if el.target.children[0].value == 'cycled'
        $('.interval', @$el).show()
      else
        $('.interval', @$el).hide()

    destroy: ->
      clearTimeout(@timer)
      @trigger('destroy')

    showConfirmDelete: ->
      @$el.find('button.delCon').appendTo('.deleteGroup', @$el)

    hideConfirmDelete: ->
      @$el.find('button.delCon').appendTo('.confirmButtons', @$el)

    saveActivated: () ->
      @model.moveTo = 'active'
      @save()

    saveTrash: () ->
      @model.moveTo = 'trash'
      @save()

    saveComplete: () ->
      @model.moveTo = 'completed'
      @save()

    saveMakeProject: () ->
      @model.makeProject = true
      @save()

    leaveElement: ->
      saveTodo =  (view) ->
        unless $('.edit:focus', view.$el).length ||
          $('.panel-todo', view.$el).hasClass('saving') ||
          view.$el.is(':hover') ||
          view.model.isNew()
            view.save()
      @timer = _.delay(saveTodo, 200, @)

    cancelEdit: ->
      clearTimeout(@timer)
      @trigger 'cancel'

    save: ->
      @trigger('save')

    serializeData: ->
      data = @model.toJSON()
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data.contexts = (App.request "contexts:loaded").models  if App.contexts.length
      data.intervals = App.request "todos:entity:intervals"
      data.projects = (App.request "projects:by_state", 'active').toArray() if App.projects.length
      data.errors = @model.validationError
      data.isNew = @model.isNew()
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @selectRadio 'prior',       @model.get('prior'), true
      @selectRadio 'kind',        @model.get('kind')
      @selectRadio 'context_id',  @model.get('context_id')
      intervalToSelect = @model.get('interval')
      intervalToSelect = 'monthly' unless intervalToSelect
      @selectRadio 'interval',    intervalToSelect
      @selectRadio 'project_id',  @model.get('project_id'), true
      $('.interval', @$el).hide() unless @model.get('kind')=='cycled'
      $('textarea', @$el).autosize()
      $('input.todo-due', @$el).datetimepicker({format: 'Y-m-d H:i', firstDay: 1})
      focusInput = ($el) ->
        $el.find('input.title').focus()
      @timer = _.delay(focusInput, 30, @$el)

    selectRadio: (name, value, setFirst) ->
      return if !value && !setFirst
      if value
        el = $("input[type='radio'][name='#{name}'][value=#{value}]", @$el)
      else
        el = $("input[type='radio'][name='#{name}']", @$el).eq(0)
      el
        .prop("checked", true)
        .parent()
        .addClass('active')

    changePrior: (a) ->
      key = $("input", $(a.target)).val()
      @setPriorClass key

    setPriorClass: (key) ->
      priorLabel = App.request "todos:entity:prior:label", key
      $('.panel-todo', @$el).attr('prior', priorLabel)