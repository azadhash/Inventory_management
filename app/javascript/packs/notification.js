// $(document).ready(function() {
//   function updateNotificationCounter() {
//     $.ajax({
//       url: '/notifications/count',
//       method: 'GET',
//       success: function(response) {
//         $('#notificationCounter').text(response.count);
//       },
//       error: function(xhr, status, error) {
//         console.log('Error occurred while fetching notification count:', error);
//       }
//     });
//   }
//   updateNotificationCounter();
//   setInterval(updateNotificationCounter, 10000);
// });
// Add an event listener to the "Mark All as Read" button
$(document).ready(function() {
  $('#markAllReadButton').click(function() {
    $('.notification-item').remove();
    $('#notificationCounter').html('0');
  });
});

