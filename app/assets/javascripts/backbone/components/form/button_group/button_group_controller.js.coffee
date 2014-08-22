@OMGtd.module "Components.Form.ButtonGroup", (ButtonGroup, App, Backbone, Marionette, $, _) ->

  class ButtonGroup.Controller extends App.Controllers.Base

    initialize: (data) ->
      @data = data
      @data.group = @makeHash data.group

    getAppropriateView: ->
      if Object.keys(@data.group).length < 7
        return @getButtonGroupView()
      @getSelectView()


    getSelectView: ->
      new ButtonGroup.Select @data

    getButtonGroupView: ->
      new ButtonGroup.ButtonGroup @data

    makeHash: (collection) ->
      if Array.isArray(collection)
        obj = {}
        for item in collection
          obj[item] = item
        collection = obj
      collection

  App.reqres.setHandler "components:form:select_button_group", (data) ->
    collection = new ButtonGroup.Controller data
    collection.getAppropriateView data