jQuery(function() {
  return $('#medialinks__list').sortable({
    axis: 'y',
    update: function() {
      return $.post($(this).data('update-url'), $(this).sortable('serialize'), (function(_this) {
        return function() {
          if ($(_this).hasClass('de')) {
            return $("#medialinks__list--sort-message").text('Die Reihenfolge wurde gespeichert!');
          } else {
            return $("#medialinks__list--sort-message").text('References sort order saved!');
          }
        };
      })(this));
    }
  });
});
