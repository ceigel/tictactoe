window.set_callbacks = ->
  $('[data-clickable="true"]').click( (e) ->
    link = $(this).attr("data-link")
    $(this).text($(this).attr("data-next"))
    setTimeout( ->
      $.ajax(
        type: 'POST'
        method: 'PATCH'
        url: link
      )
    , 500)
  )

$(document).on 'ready page:load', window.set_callbacks
