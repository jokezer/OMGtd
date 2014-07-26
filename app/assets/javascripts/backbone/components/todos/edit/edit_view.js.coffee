@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    tagName: 'form'

    events:
      'click .change-prior label'       : 'changePrior'
      'mouseleave'                      : 'leaveElement'
      'focusout'                        : 'leaveElement'
      'click a.save'                    : 'save'
      'click a.cancel'                  : 'cancelEdit'
      'click a.trash'                   : 'saveTrash'
      'click a.complete'                : 'saveComplete'
      'click a.activate'                : 'saveActivated'
      'click button.showConfirmDelete'  : 'showConfirmDelete'
      'click button.hideConfirmDelete'  : 'hideConfirmDelete'
      'click button.confirmDelete'      : 'destroy'

    initialize: (model) ->
      @model = model

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
      @undelegateEvents() if @model.isValid()
      $('.panel-todo', @$el).addClass 'saving'
      @trigger('save')

    serializeData: ->
      data = @model.toJSON()
      data.kinds =  App.request "todos:entity:kinds"
      data.priors = App.request "todos:entity:priors"
      data.contexts = App.request "contexts:loaded"
      data.contexts = data.contexts.models
      data.errors = @model.validationError
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @selectRadio 'prior',       @model.get('prior')
      @selectRadio 'kind',        @model.get('kind')
      @selectRadio 'context_id',  @model.get('context_id')
      $('textarea', @$el).autosize()
      $('input.todo-due', @$el).datetimepicker({format: 'Y-m-d H:i', firstDay: 1})
      focusInput = ($el) ->
        $el.find('input.panel-title').focus()
      @timer = _.delay(focusInput, 30, @$el)

    selectRadio: (name, value) ->
      return unless value
      $("input[type='radio'][name='#{name}'][value=#{value}]", @$el)
        .prop("checked", true)
        .parent()
        .addClass('active')

    changePrior: (a) ->
      key = $("input", $(a.target)).val()
      @setPriorClass key

    setPriorClass: (key) ->
      priorLabel = App.request "todos:entity:prior:label", key
      $('.panel-todo', @$el).attr('prior', priorLabel)
      alert $('.panel-todo', @$el).attr('prior')