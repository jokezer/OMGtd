@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.LayoutView
    template: 'apps/projects/show/templates/layout'
    regions:
      projectRegion       : "#projectRegion"
      projectNavsRegion   : "#projectNavsRegion"
      createNewRegion     : "#createNewRegion"
      projectTodosRegion  : "#projectTodosRegion"

  class Show.Item extends Marionette.ItemView
    template: 'apps/projects/show/templates/item'
    className: 'panel-project'
    events:
      'click .save'      : 'save'
      'submit'           : 'save'

    onRender: ->
      $('textarea', @$el).autosize().css(resize:'none')
      #buttons todo: move this logic to model ala state machine
      state = @model.get('state')
      if state=='active'
        @addCompleteButton()
        @addDeleteButton()
      else
        @addCompleteButton()

    addCompleteButton: ->
      @_addAbstractConfirmButton
        label:    'Complete',
        symbol:   'ok-sign',
        btnClass: 'info',
        id:       'completeButton',
        callback: @destroyl

    addDeleteButton: ->
      @_addAbstractConfirmButton
        label:    'Delete',
        symbol:   'fire',
        btnClass: 'danger',
        id:       'deleteButton',
        callback: @destroyl

    addActivateButton: ->
      @_addAbstractConfirmButton
        label:    'Activate',
        symbol:   'ok-sign',
        btnClass: 'info',
        id:       'activateButton',
        callback: @destroyl

    _addAbstractConfirmButton: (data) ->
      view = App.request 'components:form:confirm_button', data
      $("##{data.id}", @$el).html(view.render().el)
      @listenTo view, 'confirm', data.callback

    destroyl: ->
      console.log 'Do magic'
      @save()


    save: (el) ->
      @listenTo @model, 'sync', (el) ->
        @render()
        @$el.removeClass "saving"
      @listenTo @model, 'server:error', (el) ->
        @render()
      @$el.addClass "saving"
      @trigger('save')
      false

    serializeData: ->
      data = @model.toJSON()
      data.errors = {} unless data.errors
      data.errorsLength = Object.keys(data.errors).length
      data

    cancel: () ->
      @model.set @model.previousAttributes()
      @render()

  class Show.NavItem extends Marionette.ItemView
    template: 'apps/projects/show/templates/nav_item'
    tagName: 'li'



  class Show.Navs extends Marionette.CollectionView
    childView: Show.NavItem
    tagName: 'ul'
    className: 'nav nav-pills'
    menus: [
      {name: 'Index'},
      {name: 'Next',       state: 'active',  group:'kind',     label:'next'},
      {name: 'Scheduled',  state: 'active',  group:'kind',     label:'scheduled'},
      {name: 'Cycled',     state: 'active',  group:'kind',     label:'cycled'},
      {name: 'Waiting',    state: 'active',  group:'kind',     label:'waiting'},
      {name: 'Someday',    state: 'active',  group:'kind',     label:'someday'},
      {name: 'Trash',      state: 'trash'},
      {name: 'Completed',  state: 'completed'},
    ]
    initialize: (data) ->
      @data = data
      @makeCollection()
      @link = data.link
      @listenTo @data.todos, 'change remove', ->
        @makeCollection()
        @render()

    onRender: ->
      @highlightLink @link

    makeCollection: ->
      baseLink = "/#/project/#{@data.project.id}"
      for group in @menus
        if group.state
          group.count = @data.todos.getGroup(group.state, group.group, group.label).length
          link  = App.request "todos:link", group.state, group.group, group.label
          group.link = baseLink + '/filter/' + link
        else
          group.link = baseLink
      @collection = new Backbone.Collection(@menus)

    highlightLink: (link) ->
      $('li', @$el).removeClass('active')
      $('a[href="' + link + '"]', @$el).parent().addClass('active')