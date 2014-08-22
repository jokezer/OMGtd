@OMGtd.module "Components.Form.ButtonGroup", (ButtonGroup, App, Backbone, Marionette, $, _) ->

  class ButtonGroup.Controller extends App.Controllers.Base

    getButtonGroupView: (data) ->
      new ButtonGroup.View data

  App.reqres.setHandler "components:form:button_group", (data) ->
    collection = new ButtonGroup.Controller
    collection.getButtonGroupView(data)