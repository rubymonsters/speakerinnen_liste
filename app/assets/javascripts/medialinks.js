jQuery(function() {
  return $('#medialinks_list').sortable({
    axis: 'y',
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'), (function(_this) {
        return function() {
          if ($(_this).hasClass('de')) {
            return $("#messages").text('Die Reihenfolge wurde gespeichert!');
          } else {
            return $("#messages").text('References sort order saved!');
          }
        };
      })(this));
    }
  });
});

$(function() {
    $( "#medialinks_list li" ).tooltip({
      position: {
        my: "center bottom-20",
        at: "center top",
        using: function( position, feedback ) {
          $( this ).css( position );
          $( "<div>" )
            .addClass( "arrow" )
            .addClass( feedback.vertical )
            .addClass( feedback.horizontal )
            .appendTo( this );
        }
      }
    });
  });
