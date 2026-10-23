document.addEventListener('DOMContentLoaded', function() {
  // topic input on the profile form
  var topicInput = document.getElementById('profile_topic_list');
  if (topicInput) {
    var topics = Array.from(document.querySelectorAll('#availableTags li')).map(function(li) {
      return { value: li.textContent, text: li.textContent };
    });
    var topicSelect = new TomSelect(topicInput, {
      options: topics,
      create: true,
      addPrecedence: true,
      refreshThrottle: 0, // so a quick Enter after typing never picks a stale suggestion
      persist: false,
      delimiter: ',',
      plugins: ['remove_button']
    });
    // Enter adds the typed topic (also when the dropdown is closed) and never submits the profile form
    topicSelect.control_input.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        if (!event.defaultPrevented) topicSelect.createItem();
        event.preventDefault();
      }
    });
  }

  // profile and feature selects in the admin area
  document.querySelectorAll('#select_profile, #select_feature').forEach(function(select) {
    new TomSelect(select, {
      placeholder: 'Click here',
      plugins: ['remove_button']
    });
  });

  // autocomplete for the header and home search
  document.querySelectorAll('.search-autocomplete').forEach(function(input) {
    new TomSelect(input, {
      create: true,
      createOnBlur: true,
      addPrecedence: true,
      refreshThrottle: 0,
      persist: false,
      maxItems: 1,
      maxOptions: 20,
      valueField: 'text',
      labelField: 'text',
      searchField: 'text',
      shouldLoad: function(query) {
        return query.length >= 3;
      },
      load: function(query, callback) {
        fetch('/profiles_typeahead?q=' + encodeURIComponent(query), { headers: { Accept: 'application/json' } })
          .then(function(response) { return response.json(); })
          .then(function(suggestions) {
            callback(suggestions.filter(function(suggestion) { return suggestion.text; }));
          })
          .catch(function() { callback(); });
      },
      // make the current search term editable like in a normal text field
      onFocus: function() {
        if (this.items.length) {
          var value = this.items[0];
          this.clear();
          this.setTextboxValue(value);
        }
      },
      // search right away when a suggestion is picked, but not when the
      // typed text is turned into an item on blur (e.g. clicking the search button)
      onChange: function(value) {
        if (value && this.isFocused) this.input.form.submit();
      },
      render: {
        option_create: function(data, escape) {
          return '<div class="create">' + escape(data.input) + '</div>';
        },
        no_results: null
      }
    });
  });
});
