@OMGtd.module "Components.Form.ButtonGroup", (ButtonGroup, App, Backbone, Marionette, $, _) ->

  class ButtonGroup.View extends Marionette.ItemView
    template: 'components/form/button_group/templates/button_group'

    initialize: (data) ->
      @data = data

    makeHash: (collection) ->
      if Array.isArray(collection)
        obj = {}
        for item in collection
          obj[item] = item
        collection = obj
      collection

    serializeData: ->
      data = @data
      data.group = @makeHash @data.group
      data.name = data.name || data.label
      data.label = data.label.charAt(0).toUpperCase() + data.label.slice(1);
      data

    onRender: ->
      @selectRadio()

    selectRadio: ->
      return if !@data.selected && !@data.setFirst
      if @data.selected
        el = $("input[type='radio'][value=#{@data.selected}]", @$el)
      else
        el = $("input[type='radio']", @$el).eq(0)
      el
        .prop("checked", true)
        .parent()
        .addClass('active')