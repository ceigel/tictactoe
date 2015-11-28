window.set_callbacks = ->
  $('[data-clickable="true"]').click( (e) ->
    link = $(this).attr("data-link")
    console.log(link)
    $.ajax(
          type: 'POST'
          method: 'PATCH'
          url: link
    )
  )

$(document).on 'ready page:load', window.set_callbacks
