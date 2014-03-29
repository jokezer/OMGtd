ready = ->
  jQuery ->
    #panel shows when _todo prior updated
    $(".panel-todo").on("ajax:success", (e, data, status, xhr) ->
      $(this).hide('slide', {}, 'fast', ->
        $(this).css('visibility', 'hidden').show()))
    
    $('.datetimepicker').datetimepicker({mask: '9999-19-39 29:59', format: 'Y-m-d H:i'});
    $(".draggable").draggable({
      revert: "invalid",
      containment: "document",
      cursor: "move"
      opacity: 0.7
      zIndex: 100
      cursorAt: { top: 10, left: 10 },
      helper: (event) ->
        title = $(this).find("h5.panel-title").text()
        $("<span class='label label-default'>" + title + "</div>")
    })
    $(".droppable").droppable({
      accept: (e) ->
        $this = $(this)
        group = $this.attr('group')
        field_value = $this.attr('group_value')
        return false if group == 'kind' && field_value == e.attr('kind') && e.attr('state') == 'active'
        return false if group == 'state' && field_value == e.attr('state')
        return false if group == 'calendar' && field_value == e.attr('calendar') && e.attr('state') == 'active'
        return false if group == 'context' && field_value == e.attr('context')
        return false if group == 'project' && field_value == e.attr('project')
        true
      activeClass: "ui-state-hover",
      hoverClass: "ui-state-active",
      activate: (event, ui) ->
        false
      drop: (event, ui) ->
        group = $(this).attr('group')
        group_value = $(this).attr('group_value')
        todo_id = ui.draggable.attr("todo_id")
        $modal = $("#modal")
        $("#move_due").hide()
        $("#move_due").val('')
        if group == 'kind' && group_value in ['scheduled', 'cycled']
          $("#move_due").val(ui.draggable.attr("due"))
          console.log(ui.draggable)
          $("#move_due").datetimepicker({mask: '9999-19-39 29:59', format: 'Y-m-d H:i'})

          $("#move_due").show()
        $("#move_todo_id").val(todo_id)
        $("#move_group").val(group)
        $("#move_group_value").val(group_value)
        $("#message").text("move to #{group} #{group_value}?")
        $modal.modal()
    })
    $("#move_form").on("ajax:send", ->
      $("#modal").modal('hide')
    )


$(document).ready(ready)
$(document).on('page:load', ready)