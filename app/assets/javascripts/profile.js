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
  var stuffSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: {
        url: '/profiles_typeahead?q=%QUERY',
        wildcard: '%QUERY'
      },
  });

  $('.typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 3
  },
  {
    name: 'autocomplete',
    display: 'text',
    source: stuffSuggest,
    limit: 20
  });
});


$(document).ready(function() {
  if ($('.wizard-stepper').length === 0) return;

  var currentStep = 1;
  var totalSteps = 4;

  function showStep(step) {
    $('.wizard-step').hide();
    $('.wizard-step[data-step="' + step + '"]').show();

    $('.wizard-step-nav').removeClass('active completed');
    for (var i = 1; i < step; i++) {
      $('.wizard-step-nav[data-step-nav="' + i + '"]').addClass('completed');
    }
    $('.wizard-step-nav[data-step-nav="' + step + '"]').addClass('active');

    if (step <= 1) {
      $('#wizard-prev').hide();
    } else {
      $('#wizard-prev').show();
    }

    if (step >= totalSteps) {
      $('#wizard-next').hide();
      $('#wizard-submit').removeClass('d-none').show();
    } else {
      $('#wizard-next').show();
      $('#wizard-submit').addClass('d-none').hide();
    }

    $('#wizard-step-counter').text('Schritt ' + step + ' von ' + totalSteps);
    currentStep = step;
    $('html, body').animate({ scrollTop: $('.wizard-stepper').offset().top - 80 }, 300);
  }

  $('#wizard-next').on('click', function() {
    if (currentStep < totalSteps) showStep(currentStep + 1);
  });

  $('#wizard-prev').on('click', function() {
    if (currentStep > 1) showStep(currentStep - 1);
  });

  $('.wizard-step-nav').on('click', function() {
    var target = parseInt($(this).data('step-nav'));
    if (target >= 1 && target <= totalSteps) showStep(target);
  });

  showStep(1);
});

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
console.log(tooltipTriggerList)
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})
