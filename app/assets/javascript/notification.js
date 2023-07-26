$(document).on('click', '#markAllReadButton', function() {
  $('.notification-item').remove();
  $('#notificationCounter').html('0');
});
