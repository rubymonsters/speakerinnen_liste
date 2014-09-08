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

$(function() {
  $('.add-empty-medialink-form').click(function() {
    var copy = $('.empty-medialink-form').clone(true);
    (function (copy) {
      copy.removeClass('hidden empty-medialink-form');
      copy.addClass('new-item');
      copy.addClass('ui-sortable-handle');
      copy.on('click', '.btn-delete', function() {
        copy.remove();
      });
      copy.find('input,textarea').removeAttr('disabled');
      $('.all-links').append(copy);
    })(copy);
  });

  $('.all-links').on('click', '.existing-item .btn-delete', function () {
    var button = $(this);
    var parent = button.parent().parent();
    var id = parent.find('[name="medialinks[][id]"]').val();
    var profileId = $('[name="profile.id"]').val();
    $.ajax({
      'url': '/profiles/'+profileId+'/medialinks/'+id+'.json',
      'method': 'delete'
    }).success(function() {
      parent.remove();
    }).error(function () {
      console.log("failed to remove medialink by id: "+id);
    });
  });

  $(function() {
    $( ".ui-sortable" ).sortable();
    $( ".ui-sortable" ).disableSelection();
  });
});
