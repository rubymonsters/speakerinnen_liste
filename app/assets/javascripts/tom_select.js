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
      clearAfterSelect: true, // remove the typed "klima" after picking "klimabewegung"
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

  // the loaded suggestion that equals the given text, ignoring upper and lower case
  function findSuggestion(select, text) {
    var lowerText = text.toLowerCase();
    return Object.values(select.options).find(function(option) {
      return option.text.toLowerCase() === lowerText;
    });
  }

  // autocomplete for the header and home search
  document.querySelectorAll('.search-autocomplete').forEach(function(input) {
    var searchSelect = new TomSelect(input, {
      create: true,
      createOnBlur: true,
      addPrecedence: true,
      refreshThrottle: 0,
      persist: false,
      maxItems: 1,
      // keep commas in the search term ("social media, ai"), a text field can't contain line breaks
      delimiter: '\n',
      maxOptions: 20,
      valueField: 'text',
      labelField: 'text',
      searchField: 'text',
      // don't offer the typed text when a suggestion only differs in upper and lower case
      createFilter: function(text) {
        return !findSuggestion(this, text);
      },
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
    // typing "klima" and leaving the field (e.g. clicking the search button) uses the suggestion "Klima"
    var createItem = searchSelect.createItem;
    searchSelect.createItem = function(text, callback) {
      var suggestion = findSuggestion(this, text || this.inputValue());
      if (!suggestion) return createItem.apply(this, arguments);
      this.setTextboxValue();
      this.addItem(suggestion.text);
      if (typeof callback === 'function') callback();
      return true;
    };
  });
});
