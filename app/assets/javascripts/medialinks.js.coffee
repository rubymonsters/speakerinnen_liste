jQuery ->
  $('#medialinks_list').sortable
    axis: 'y'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'), =>
        if $(this).hasClass('de')
          $("#messages").text('Die Reihenfolge wurde gespeichert!')
        else
          $("#messages").text('References sort order saved!')
      )

jQuery ->
  $("ul").tooltip()
