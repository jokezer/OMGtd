@OMGtd.module "Components.Form.ButtonConfirm", (ButtonConfirm, App, Backbone, Marionette, $, _) ->

  class ButtonConfirm.Button extends Marionette.ItemView
    template: 'components/form/button_confirm/templates/button'
    tagName: 'span'
    events:
      'click button.showConfirm'  : 'showConfirm'
      'click button.hideConfirm'  : 'hideConfirm'
      'click button.confirm'      : 'confirm'

    initialize: (data) ->
      @data = data

    serializeData: ->
      data = @data
      data

    confirm: ->
      @trigger 'confirm'

    showConfirm: ->
      buttons = $('.buttonsContainer>button.confirmButtons', @$el)
      if buttons.length then buttons.appendTo($('.confirmGroup', @$el)) else @hideConfirm()

    hideConfirm: ->
      @$el.find('button.confirmButtons').appendTo($('.buttonsContainer', @$el))
