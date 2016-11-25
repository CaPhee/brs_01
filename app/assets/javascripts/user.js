function openContentTimeline(id){
  $('.user-tabs').attr('class', 'user-tabs');
  $('#' + id).attr('class', 'user-tabs active');
  $('.user-content').hide();
  $('#' + id + '-content').show();
}
