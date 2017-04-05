$(function() {
  $(".add-tag-trigger").click(function() {
    var nameOfTag    = $(this).html();
    var existingTags = $("#tag-field-new").val();
    //check if tag is in the list of tags
    if (existingTags.indexOf(nameOfTag) < 0) {
      if (existingTags.length == 0) {
        $("#tag-field-new").val(nameOfTag);
      } else {
        $("#tag-field-new").val(existingTags+' '+nameOfTag);
      }
      $(this).removeClass("badge-inverse");
    } else {
      var newTags = existingTags.replace(nameOfTag, "").replace(/  /g, " ");
      $("#tag-field-new").val(newTags);
      $(this).addClass("badge-inverse");
    }
  });
});

$(document).ready(function() {
  var topics = $('#availableTags li').map(function(index, li) {
    return $(li).text();
  });
  $('#profile_topic_list').tagit({availableTags: topics});
});

$(document).ready(function(){

  var engine = new Bloodhound({
    name: 'fullname-search',
    // remote: '/profiles_typeahead?q=mar',
    remote: {
      url: '/profiles_search?q=mar',
      filter: function(response) {
        console.log("response: ", response);
        return response;
      }
    },
    datumTokenizer: function(d) {
      console.log("d.val: ", d.val);
      return Bloodhound.tokenizers.whitespace(d.val);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace
  });

  engine.initialize();


  $('.typeahead').typeahead(
    {
      minLength: 2,
      highlight: true,
      hint: true // If the input should display the top result hinted in the input box.
    },
    {
      name: 'fullname-search',
      displayKey: 'text',
      // displayKey: function(names) {
      //   console.log("these are the names !!!!!!!!!!", names);
      //   return names;
      // },
      source: function(query, callback) {
        callback([{"text":"Maren Jackwerth","score":1.0},{"text":"Maren Martschenko","score":1.0},{"text":"Maren Heltsche","score":1.0}]);
      }
      // source: function(query, callback) {
      //   callback(engine);
      // }
      // source: engine.ttAdapter()
    }
  );
});
