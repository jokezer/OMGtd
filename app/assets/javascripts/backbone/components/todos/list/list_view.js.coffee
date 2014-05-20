@OMGtd.module "Components.Todos.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Item extends Marionette.ItemView
    tagName: 'li'
    template: 'components/todos/list/templates/todo'
    events:
      "click"             : "consolel"
      "dblclick"          : "edit"
#      "focusout"          : "close"
      "click .showMore"   : "toggleContent"
      "click .hideContent": "toggleContent"
      "click .inc-prior"  : "incPrior",
      "click .dec-prior"  : "decPrior",
#      "updated"           : "slideUp"

    tagName: "form"
    className: ""

    consolel: ->
      console.log('dsfadsfasdfdsf')

    slideUp: ->
      console.log('updated')
      @$el.hide().show('slide', {}, 'fast')

    incPrior: ->
      prior = @model.get('prior')
      if prior < 3
        @model.set({prior:++prior})
        @_savePrior()

    decPrior: ->
      prior = @model.get('prior')
      if prior >= 0
        @model.set({prior:prior-1})
        @_savePrior()

    edit: ->
      @undelegateEvents()
      editView = App.request "todos:edit", @model
      @$el.html(editView.render().el)
      $('textarea', @$el).trigger('autosize.resize')

#    close22: ->
#      saveTodo =  (view) ->
#        unless view.$el.find('.edit:focus').length
#          view.$el.removeClass('editing').addClass('saving')
#          view.$el.find('.textarea').trigger('autosize.destroy')
#          view.save()
#      _.delay(saveTodo, 1000, @);

#    save: ->
#      formData =
#        title: $('input.panel-title', @$el).val()
#        content: $('textarea.edit', @$el).val()
#
#      @model.set(formData)
#      if @model.isValid(true)
#        @render()
#        @model.save({},
#          success: (todo, jqXHR) =>
#            @render()
#            @$el.removeClass('saving')
#          error: (todo, jqXHR) =>
#            console.log(jqXHR.responseText)
#        )
#      else
##        alert('dver zapilil')

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
      data.groupedContent = @_setContent()
      data

    onRender: ->
      @_setPriorName()

    _setPriorName: ->
#      $('.panel-todo', @$el).attr('class', (i, c) ->
#        c?.replace(/\bprior-\S+/g, ''))
      priorLabel = App.request "todos:entity:prior:label", @model.get('prior')
      $('.panel-todo', @$el).addClass("prior-#{priorLabel}")

    _savePrior: ->
      @model.save({},
        success: (todo, jqXHR) =>
          @model.collection.sort()
          @render().$el.hide().show('slide', {}, 'fast')
          @trigger('priorUpd')
        error: (todo, jqXHR) =>
          console.log(jqXHR.responseText)
      )

  class List.Empty extends Marionette.ItemView
    template: 'components/todos/list/templates/empty'

  class List.Collection extends Marionette.CollectionView
    itemView: List.Item
    emptyView: List.Empty
    itemEvents:
      'priorUpd': 'rerender'
    rerender: (el, la) ->
      @$el.html('')
      @render()
      console.log(la) #do something