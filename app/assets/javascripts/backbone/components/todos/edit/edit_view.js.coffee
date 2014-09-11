@OMGtd.module "Components.Todos.Edit", (Edit, App, Backbone, Marionette, $, _) ->

  class Edit.Form extends Marionette.ItemView
    template: 'components/todos/edit/templates/form'
    tagName: 'form'

    events:
      'click #priorsGroup .btn-group label'         : 'changePrior'
#      'mouseleave'                      : 'leaveElement'
#      'focusout'                        : 'leaveElement'
      'click .save'                    : 'save'
      'click .cancel'                  : 'cancelEdit'
      'click .trash'                   : 'saveTrash'
      'click .complete'                : 'saveComplete'
      'click .activate'                : 'saveActivated'
      'click #kindsGroup .btn-group label' : 'toggleInterval'

    initialize: (model) ->
      @model = model

    toggleInterval: (el) ->
      if el.target.children[0].value == 'cycled'
        $('#intervalsGroup', @$el).show()
      else
        $('#intervalsGroup', @$el).hide()

    destroy: ->
      clearTimeout(@timer)
      @trigger('destroy')

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
      data.errors = @model.validationError
      data

    onRender: ->
      @setPriorClass @model.get('prior')
      @addAllButtonsGroups()
      state = @model.get('state')
      if state == 'trash' || state == 'completed'
        @addDeleteButton()
      if (state == 'active' || state == 'inbox') && !@model.get('project_id') && !@model.isNew()
        @addMakeProjectButton()
      $('#intervalsGroup', @$el).hide() unless @model.get('kind')=='cycled'
      $('textarea', @$el).autosize()
      $('input.todo-due', @$el).datetimepicker({format: 'Y-m-d H:i', firstDay: 1})
      focusInput = ($el) ->
        $el.find('input.title').focus()
      @timer = _.delay(focusInput, 30, @$el)

    addDeleteButton: ->
      view = App.request 'components:form:confirm_button',
        label: 'Delete',
        symbol: 'fire'
        btnClass: 'danger'
      $("#deleteButton", @$el).html(view.render().el)
      @listenTo view, 'confirm', @destroy

    addMakeProjectButton: ->
      view = App.request 'components:form:confirm_button',
        label: 'Make Project',
        symbol: 'share',
        btnClass: 'link'
      $("#makeProjectButton", @$el).html(view.render().el)
      @listenTo view, 'confirm', @saveMakeProject

    addAllButtonsGroups: ->
      @addButtonGroup
        label: 'kind',
        group: App.request "todos:entity:kinds"
        selected: @model.get('kind')
      @addButtonGroup
        label: 'prior',
        group: App.request "todos:entity:priors"
        selected: @model.get('prior')
        setFirst: true
      @addButtonGroup
        label: 'interval',
        group: App.request "todos:entity:intervals"
        selected: @model.get('interval')
        setFirst: true
      if App.contexts.length
        contexts = @makeContextHash (App.request "contexts:loaded").models
        @addButtonGroup
          label: 'context',
          name: 'context_id',
          group: contexts
          selected: @model.get('context_id')
          setFirst: true
      if App.projects.length
        projects = @makeContextHash (App.request "projects:by_state", 'active').toArray()
        @addButtonGroup
          label: 'project',
          name: 'project_id',
          group: projects
          selected: @model.get('project_id')
          setFirst: true


    addButtonGroup: (data) ->
      view = App.request 'components:form:select_button_group', data
      $("##{data.label}sGroup", @$el).html(view.render().el)

    makeContextHash: (group) ->
      obj = {0: 'none'}
      for item in group
        obj[item.get('id')] = item.get('label')
      obj

    changePrior: (a) ->
      key = $("input", $(a.target)).val()
      @setPriorClass key

    setPriorClass: (key) ->
      priorLabel = App.request "todos:entity:prior:label", key
      $('.panel-todo', @$el).attr('prior', priorLabel)