// switches between the german and english fields on the profile and feature forms
document.addEventListener('DOMContentLoaded', function() {
  var locales = ['de', 'en'];

  locales.forEach(function(locale) {
    var tab = document.getElementById('show-' + locale);
    if (!tab) return;

    tab.addEventListener('click', function() {
      locales.forEach(function(other) {
        var shown = other === locale;
        document.getElementById('edit-' + other).classList.toggle('d-block', shown);
        document.getElementById('edit-' + other).classList.toggle('d-none', !shown);
        document.getElementById('show-' + other).classList.toggle('active', shown);
      });
    });
  });
});
