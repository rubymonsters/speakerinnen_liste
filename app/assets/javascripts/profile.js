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

// show the more/less toggle only for medialink descriptions that are cut off
$(document).ready(function() {
  $('.medialink-card__description').each(function() {
    if (this.scrollHeight > this.clientHeight) {
      $(this).next('.medialink-card__toggle').removeClass('d-none');
    }
  });

  $('.medialink-card__toggle').click(function() {
    var description = $(this).prev('.medialink-card__description');
    description.toggleClass('is-expanded');
    $(this).text(description.hasClass('is-expanded') ? $(this).data('less') : $(this).data('more'));
  });
});

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
console.log(tooltipTriggerList)
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})
