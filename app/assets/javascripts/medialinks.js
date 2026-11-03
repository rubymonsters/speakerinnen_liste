document.addEventListener('DOMContentLoaded', function() {
  var list = document.getElementById('medialinks__list');
  if (!list) return;

  new Sortable(list, {
    direction: 'vertical',
    onUpdate: function() {
      // same format as jQuery UI's sortable('serialize'): medialink[]=12&medialink[]=15
      var params = new URLSearchParams();
      list.querySelectorAll(':scope > li[id^="medialink_"]').forEach(function(item) {
        params.append('medialink[]', item.id.replace('medialink_', ''));
      });
      var csrfToken = document.querySelector('meta[name="csrf-token"]');

      fetch(list.dataset.updateUrl, {
        method: 'POST',
        headers: { 'X-CSRF-Token': csrfToken ? csrfToken.content : '' },
        body: params
      }).then(function(response) {
        if (!response.ok) return;
        var message = list.classList.contains('de') ? 'Die Reihenfolge wurde gespeichert!' : 'References sort order saved!';
        document.getElementById('medialinks__list--sort-message').textContent = message;
      });
    }
  });
});
