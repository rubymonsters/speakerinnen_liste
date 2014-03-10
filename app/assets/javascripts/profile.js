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
