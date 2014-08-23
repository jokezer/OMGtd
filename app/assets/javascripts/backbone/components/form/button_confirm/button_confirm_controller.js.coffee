@OMGtd.module "Components.Form.ButtonConfirm", (ButtonConfirm, App, Backbone, Marionette, $, _) ->

  class ButtonConfirm.Controller extends App.Controllers.Base

    initialize: (data) ->
      @data = data

    getButtonView: ->
      new ButtonConfirm.Button @data

  App.reqres.setHandler "components:form:confirm_button", (data) ->
    collection = new ButtonConfirm.Controller data
    collection.getButtonView data