$(document).on('click', '#markAllReadButton', function() {
  $('.notification-item').remove();
  $('#notificationCounter').html('0');
});
function goBack() {
  window.history.back();
}