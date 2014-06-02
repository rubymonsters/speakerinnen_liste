jQuery ->
  $('#medialinks_list').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'), ->
        $("#messages").text('References sort order saved!')
      )