$(document).ready(function() {
  function updateNotificationCounter() {
    $.ajax({
      url: '/notifications/count',
      method: 'GET',
      success: function(response) {
        $('#notificationCounter').text(response.count);
      },
      error: function(xhr, status, error) {
        console.log('Error occurred while fetching notification count:', error);
      }
    });
  }
  updateNotificationCounter();

  setInterval(updateNotificationCounter, 10000);
});