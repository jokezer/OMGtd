@OMGtd.module "Components.Todos.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Item extends Marionette.ItemView
    template: 'components/todos/list/templates/todo'
    move: false
    events:
      "dblclick"          : "edit"
      "click .showMore"   : "toggleContent"
      "click .hideContent": "toggleContent"
      "click .inc-prior"  : "incPrior",
      "click .dec-prior"  : "decPrior",
    initialize: ->
      @listenTo @model, 'slideDown', @slideDown
      @listenTo @model, 'server:send', @successEdit
      @listenTo @model, "server:saved", @successSync
      @listenTo @model, "change:prior", ->
        @move = true
#      @listenTo @model, "change:due", ->
#        @move = true
      @listenTo @model, "move", ->
        @trigger 'move' #for collection view

    slideDown: ->
      @$el.find('.panel-todo').hide().show('slide', {}, 'fast')

    slideUp: ->
      @$el.find('.panel-todo').hide('slide', {}, 'fast', ->
        $(this).css('visibility', 'hidden').show())

    addSavingClass: () ->
      @$el.find('.panel-todo').addClass('saving')

    removeSavingClass: () ->
      @$el.find('.panel-todo').removeClass('saving')

    incPrior: ->
      @slideUp()
      prior = @model.get('prior')
      if prior < 3
        @model.set({prior:++prior})
        @_savePrior()

    decPrior: ->
      @slideUp()
      prior = @model.get('prior')
      if prior >= 0
        @model.set({prior:prior-1})
        @_savePrior()

    edit: ->
      unless @$el.find('.panel-todo').hasClass('saving')
        @undelegateEvents()
        edit = App.request "todos:edit",
          model:  @model
          action: 'edit'
        @listenTo edit, "cancel", @cancelEdit
        @$el.html(edit.form.render().el)
        $('textarea', @$el).trigger('autosize.resize')

    cancelEdit: ->
      @undelegateEvents()
      @render()
      @delegateEvents()

    successEdit: ->
      @cancelEdit()
      @addSavingClass()
      @slideUp() if @move
      @listenTo @model, "server:error", ->
        @removeSavingClass()
        @edit()

    successSync: ->
      if @move
        @model.trigger('move')
        @model.trigger('slideDown')
      else
        @removeSavingClass()

    _setContent: ->
      content = @model.get('content')
      if content
        content = content.split('\n')
        result = {visible:content[0..2]}
        result.hidden = content[3..content.length-1] if content.length > 3
        return result

    toggleContent: ->
      @$el.find('.showMore').toggle()
      @$el.find('.hiddenContent').toggle()

    serializeData: ->
      data = @model.toJSON()
      context_id = @model.get('context_id')
      data.context = App.request "context:label", context_id if context_id
      data.groupedContent = @_setContent()
      data

    onRender: ->
      @_setPriorName()

    _setPriorName: ->
      priorLabel = App.request "todos:entity:prior:label", @model.get('prior')
      $('.panel-todo', @$el).addClass("prior-#{priorLabel}")

    _savePrior: ->
      @model = App.request "save:todos:entity",
        model: @model

  class List.Empty extends Marionette.ItemView
    template: 'components/todos/list/templates/empty'

  class List.Collection extends Marionette.CollectionView

    itemView: List.Item
    emptyView: List.Empty

    events:
      click: 'rere'

    itemEvents:
      move: 'rerender'

    rerender: () ->
      @collection.sort()
      @$el.html('')
      @render()

    rere: (ev, el) ->
      console.log @collection