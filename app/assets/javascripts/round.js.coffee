window.set_callbacks = ->
  $('[data-clickable="true"]').click( (e) ->
    link = $(this).attr("data-link")
    $(this).text($(this).attr("data-next"))
    $.ajax(
      type: 'POST'
      method: 'PATCH'
      url: link
    )
  )

$(document).on 'ready page:load', window.set_callbacks
