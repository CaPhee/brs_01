function openContentTimeline(id){
  $('.user-tabs').attr('class', 'user-tabs');
  $('#' + id).attr('class', 'user-tabs active');
  $('.user-content').hide();
  $('#' + id + '-content').show();
}
function changeSelectedTag(){
  if (window.location.href.indexOf('page_activities') > -1){
    openContentTimeline('user-activities');
  }
  if (window.location.href.indexOf('page_read_books') > -1){
    openContentTimeline('user-read_books');
  }
  if (window.location.href.indexOf('page_reading_books') > -1){
    openContentTimeline('user-reading_books');
  }
  if (window.location.href.indexOf('page_favorites') > -1){
    openContentTimeline('user-favorites');
  }
}
$(document).ready(function() {
  changeSelectedTag();
});
$(document).on('turbolinks:load', function() {
  changeSelectedTag();
});
