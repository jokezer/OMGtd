@OMGtd.module "Components.Todos.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Item extends Marionette.ItemView
    template: 'components/todos/list/templates/todo'
    events:
      "dblclick"          : "edit"
      "click .showMore"   : "toggleContent"
      "click .hideContent": "toggleContent"
#      "click .inc-prior"  : "incPrior",
#      "click .dec-prior"  : "decPrior",

    slideUp: ->
      console.log('updated')
      @$el.hide().show('slide', {}, 'fast')

#    incPrior: ->
#      prior = @model.get('prior')
#      if prior < 3
#        @model.set({prior:++prior})
#        @_savePrior()
#
#    decPrior: ->
#      prior = @model.get('prior')
#      if prior >= 0
#        @model.set({prior:prior-1})
#        @_savePrior()

    edit: ->
      unless @$el.find('.panel-todo').hasClass('saving')
        @undelegateEvents()
        edit = App.request "todos:edit", @model
        @listenTo edit, "cancel", @cancelEdit
        @listenTo edit, "done",   @successEdit
        @$el.html(edit.form.render().el)
        $('textarea', @$el).trigger('autosize.resize')

    cancelEdit: ->
      @undelegateEvents()
      @render()
      @delegateEvents()

    successEdit: ->
      @cancelEdit()
      @$el.find('.panel-todo').addClass('saving')
      @listenTo @model, "successSave", ->
        App.reloadPage()

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
#      $('.panel-todo', @$el).attr('class', (i, c) ->
#        c?.replace(/\bprior-\S+/g, ''))
      priorLabel = App.request "todos:entity:prior:label", @model.get('prior')
      $('.panel-todo', @$el).addClass("prior-#{priorLabel}")

#    _savePrior: ->
#      @model.save({},
#        success: (todo, jqXHR) =>
#          @model.collection.sort()
#          @render().$el.hide().show('slide', {}, 'fast')
#          @trigger('priorUpd')
#        error: (todo, jqXHR) =>
#          console.log(jqXHR.responseText)
#      )

  class List.Empty extends Marionette.ItemView
    template: 'components/todos/list/templates/empty'

  class List.Collection extends Marionette.CollectionView
    itemView: List.Item
    emptyView: List.Empty
    itemEvents:
      'priorUpd': 'rerender'
    rerender: (el, la) ->
      console.log(@collection)
      @$el.html('')
      @render()
