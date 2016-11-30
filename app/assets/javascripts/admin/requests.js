function approveRequest(id,approve) {
  updateRequest(id,'processed',approve);
}
function bought(id,bought) {
  updateRequest(id,'bought',bought);
}
function updateRequest(id,attribute,value) {
  $.ajax({
    type: 'PUT',
    url: 'requests/' + id + '/?' + attribute +'=' + value,
    dataType: 'script',
    success: function(data){
      $("#connect_failed").hide();
    },
    error: function(error_message) {
      $("#connect_failed").show();
    },
  });
}
function deleteRequest(id,strConfirm){
  if (confirm(strConfirm)) {
    $.ajax({
      type: 'DELETE',
      url: 'requests/' + id,
      success: function(data){
        $("#tr_request_id_" + id).fadeOut('slow');
      },
      error: function(error_message) {
        $("#connect_failed").show();
      }
    });
  }
}
