function rate(star, max, bookID){
  for (var i = max - 1; i >= star; i--) {
    $('#star-' + i).html('&#9733;');
  }
  for (var i = 0; i < star; i++) {
    $('#star-' + i).html('&#9734;');
  }
  $('#rate-book-' + bookID).val(max - star);
}
$.fn.stars = function() {
  return $(this).each(function() {
    if ($.isNumeric($(this).html())) {
      var val = parseFloat($(this).html());
      var size = Math.max(0, (Math.min(5, val))) * 32;
      var $span = $('<span />').width(size);
      $(this).html($span);
    }
  });
}
blackStar = '<span class="review-rate">&#9733;</span>';
$.fn.rate = function() {
  return $(this).each(function() {
    var val = parseInt($(this).html());
    if (val > 0) {
      html = '';
      for (var i = 0; i < val; i++) {
        html += blackStar;
      }
      $(this).html(html);
    }
  });
}
$.fn.rating = function() {
  return $(this).each(function() {
    var val = parseInt($(this).html());
    if (val > 0) {
      html = '';
      for (var i = 0; i < val; i++) {
        html += blackStar;
      }
      $(this).html(html);
    }
  });
}
function submit_books_search_form(){
  str = $('#search_books_form').serialize();
  $.ajax({
    type: "GET",
    url: $('#search_books_form').attr('action') + '?' + str,
    dataType: "script",
    success: function(data){
    },
    error: function(error_message) {
      connect_failed.show();
    }
  });
}
function fadeOutMessage() {
  $('#flash-messages').show();
  setTimeout(function() {
    $('#flash-messages').fadeOut('slow');
  },3000);
}
function markBookAs(bookID, mark){
  markIconElement = document.getElementById('mark-' + mark + '-' + bookID);
  markIconElement.className = "loader pull-right";
  $.ajax({
    type: 'POST',
    url: '/marks?read=' + mark + '&book_id=' + bookID,
    dataType: 'script',
    success: function(data){
    },
    error: function(error_message) {
      connect_failed.show();
      markIconElement.className = 'glyphicon glyphicon-ban-circle pull-right';
    }
  });
}
function favorite(bookID){
  $.ajax({
    type: 'POST',
    url: '/favorites?book_id=' + bookID,
    success: function(data){
      if (data.save) {
        btn = $('#btn-ft-' + bookID);
        btn.attr('class', 'btn btn-warning');
        btn.attr('onclick', 'unfavorite(' + data.favorite + ',' + bookID + ')');
      }
      html = '';
      for(var message in data.messages){
        html += '<div class="alert alert-'+ message + ' alert-auto-hide">'
        + '<span>' + data.messages[message] + '</span>'
        + '<a class="close" data-dismiss="alert" href="#">'
        + '<span class="translation_missing" title="close">X</span></a>'
        + '</div>';
      }
      $('#flash-messages').html(html);
      $('#flash-messages').show();
      fadeOutMessage();
    },
    error: function(error_message) {
      connect_failed.show();
    }
  });
}
function unfavorite(favoriteID, bookID){
  $.ajax({
    type: 'DELETE',
    url: '/favorites/' + favoriteID,
    success: function(data){
      if (data.deleted) {
        btn = $('#btn-ft-' + bookID);
        btn.attr('class', 'btn btn-info');
        btn.attr('onclick', 'favorite(' + bookID + ')');
      }
      html = '';
      for(var message in data.messages){
        html += '<div class="alert alert-'+ message + ' alert-auto-hide">'
        + '<span>' + data.messages[message] + '</span>'
        + '<a class="close" data-dismiss="alert" href="#">'
        + '<span class="translation_missing" title="close">X</span></a>'
        + '</div>';
      }
      $('#flash-messages').html(html);
      $('#flash-messages').show();
      fadeOutMessage();
    },
    error: function(error_message) {
      connect_failed.show();
    }
  });
}
function deleteBook(id,strConfirm){
  if (confirm(strConfirm)) {
    $.ajax({
      type: 'DELETE',
      url: 'books/' + id,
      success: function(data){
        $("#tr_book_id_" + id).fadeOut('slow');
      },
      error: function(error_message) {
        $("#connect_failed").show();
      }
    });
  }
}
function deleteCategory(id,strConfirm){
  if (confirm(strConfirm)) {
    $.ajax({
      type: 'DELETE',
      url: 'categories/' + id,
      success: function(data){
        $("#tr_category_id_" + id).fadeOut('slow');
      },
      error: function(error_message) {
        $("#connect_failed").show();
      }
    });
  }
}
function init_config_book() {
  $('span.stars').stars();
  $('span.review-rate').rate();
  $('#search_books').keyup(function () {
    submit_books_search_form();
  });
  $('.mark-item').click(function(e) {
    e.stopPropagation();
  });
  $('#search_user_box').keyup(function () {
    key = $(this).val();
    searchUser('users?key=' + key);
  });
  $('#search_follows_box').keyup(function () {
    key = $(this).val();
    strUrl = window.location.href.split("?");
    url = strUrl[0] + '?key=' +key;
    searchUser(url);
  });
  jQuery('div.dropdown').hover(function() {
    jQuery(this).find('.dropdown-menu').stop(true, true).delay(500).fadeIn(500);
  }, function() {
    jQuery(this).find('.dropdown-menu').stop(true, true).delay(500).fadeOut(500);
  });
  fadeOutMessage();
}
$(document).ready(function() {
  init_config_book();
});
$(document).on('turbolinks:load', function() {
  init_config_book();
});
function deleteComment(id,strConfirm){
  if (confirm(strConfirm)) {
    $.ajax({
      type: 'DELETE',
      url: '/comments/' + id,
      dataType: 'script',
      success: function(data){
        $('#comment-' + id).fadeOut('slow');
      },
      error: function(error_message) {
        $("#connect_failed").show();
      }
    });
  }
}
