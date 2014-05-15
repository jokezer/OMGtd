@OMGtd.module "TodosApp.List", (List, App, Backbone, Marionette, $, _) ->

  class List.Item extends Marionette.ItemView
    tagName: 'li'
    template: 'todos/list/templates/todo'
    events:
      "dblclick" : "edit"
      "focusout" : "close"
      "click .showMore"   : "toggleContent"
      "click .hideContent"   : "toggleContent"
      "click .inc-prior"   : "incPrior",
      "click .dec-prior"   : "decPrior",

    tagName: "form"
    className: "draggable panel panel-default panel-todo"

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
      unless @$el.hasClass('editing')
        @$el.addClass('editing')
        @$el.find('textarea').autosize().trigger('autosize.resize')
        @$el.find('input').focus()

    close: ->
      saveTodo =  (view) ->
        unless view.$el.find('.edit:focus').length
          view.$el.removeClass('editing').addClass('saving')
          view.$el.find('.textarea').trigger('autosize.destroy')
          view.save()
      _.delay(saveTodo, 1000, @);

    #todo merge with new_view?
    save: ->
      formData =
        title: $('input.panel-title', @$el).val()
        content: $('textarea.edit', @$el).val()

      @model.set(formData)
      if @model.isValid(true)
        @model.save({},
          success: (todo, jqXHR) =>
            @render()
            @$el.removeClass('saving')
          error: (todo, jqXHR) =>
            console.log(jqXHR.responseText)
        )
      else
        alert('dver zapilil')

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

    onBeforeRender: ->
      @_setPriorName()
#      @$el.html(@template(data))
#      return this

    _setPriorName: ->
      @$el.attr('class', (i, c) ->
        c.replace(/\bprior-\S+/g, ''))
      @$el.addClass("prior-#{Gtd.Models.Todo.priors[@model.get('prior')]}")

    _savePrior: ->
      @model.save({},
        success: (todo, jqXHR) =>
          @model.collection.sort()
          @render().$el.hide().show('slide', {}, 'fast')
          @trigger('priorUpd')
        error: (todo, jqXHR) =>
          console.log(jqXHR.responseText)
      )

  class List.Collection extends Marionette.CollectionView
    itemView: List.Item
    itemEvents:
      'priorUpd': 'rerender'
    rerender: (el, la) ->
      @$el.html('')
      @render()
      console.log(la)