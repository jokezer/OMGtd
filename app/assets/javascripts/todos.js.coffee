##= require hamlcoffee
ready = ->
  jQuery ->
    sidebar = $('#left-sidebar-region')
    showSidebar = $('#showSidebar')
    showSidebar.on('click', ->
      sidebar.toggleClass('visible-lg-block'))
    $(document).mouseup((e) ->
      if (!sidebar.is(e.target)) && !showSidebar.is(e.target) && sidebar.has(e.target).length == 0
        sidebar.addClass('visible-lg-block'))
$(document).ready(ready)
$(document).on('page:load', ready)
