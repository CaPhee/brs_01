function slider(index){
  nextIndex = index + 1;
  if (index == 4) {
    nextIndex = 0;
  }
  $("#slider-show").html($('#slide-element-' + index).html());
  $("#slider-show").fadeIn(1000, function() {
    setTimeout(function() {
      $("#slider-show").fadeOut(2000, function() {
        slider(nextIndex);
      });
    },5000);
  });
}

$(document).ready(function() {
  slider(0);
});
$(document).on('turbolinks:load', function() {
  slider(0);
});
