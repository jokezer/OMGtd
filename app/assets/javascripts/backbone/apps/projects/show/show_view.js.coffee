@OMGtd.module "ProjectsApp.Show", (Show, App, Backbone, Marionette, $, _) ->

  class Show.Layout extends Marionette.Layout
    template: 'apps/projects/show/templates/layout'
    regions:
      projectRegion       : "#projectRegion"
      projectNavsRegion   : "#projectNavsRegion"
      createNewRegion     : "#createNewRegion"
      projectTodosRegion  : "#projectTodosRegion"

  class Show.Item extends Marionette.ItemView
    template: 'apps/projects/show/templates/item'
    events:
      'click a.save'      : 'save'

    onRender: ->
      $('textarea', @$el).autosize()

    save: ->
      @trigger('save')


  class Show.NavItem extends Marionette.ItemView
    template: 'apps/projects/show/templates/nav_item'
    tagName: 'li'



  class Show.Navs extends Marionette.CollectionView
    itemView: Show.NavItem
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
      @collection = @makeCollection()

    makeCollection: ->
      baseLink = "/#/project/#{@data.project.id}"
      for group in @menus
        if group.state
          group.count = @data.todos.getGroup(group.state, group.group, group.label).length
          link  = App.request "todos:link", group.state, group.group, group.label
          group.link = baseLink + '/filter/' + link
        else
          group.link = baseLink
      new Backbone.Collection(@menus)