function like(url, method){
  method == null ? type = 'post' : type = method ;
  console.log(type);
  $.ajax({
    type: type,
    url: url,
    dataType: 'script',
    success: function(data){
    },
    error: function(error_message) {
      console.log(error_message);
      connect_failed.show();
    }
  });
}
