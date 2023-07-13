$(document).ready(function() {
  $('#markAllReadButton').click(function() {
    $('.notification-item').remove();
    $('#notificationCounter').html('0');
  });
});

