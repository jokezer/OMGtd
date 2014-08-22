@OMGtd.module "Components.Form.ButtonGroup", (ButtonGroup, App, Backbone, Marionette, $, _) ->

  class ButtonGroup.ButtonGroup extends Marionette.ItemView
    template: 'components/form/button_group/templates/button_group'
    tagName: 'span'

    initialize: (data) ->
      @data = data

    serializeData: ->
      data = @data
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

  class ButtonGroup.Select extends Marionette.ItemView
    template: 'components/form/button_group/templates/select'
    className: 'selectForm'
    tagName: 'span'

    initialize: (data) ->
      @data = data

    serializeData: ->
      data = @data
      data.name = data.name || data.label
      data.label = data.label.charAt(0).toUpperCase() + data.label.slice(1);
      data

    onRender: ->
      @selectOption()

    selectOption: ->
      return if !@data.selected
      $("option[value=#{@data.selected}]", @$el).attr(selected:'selected')