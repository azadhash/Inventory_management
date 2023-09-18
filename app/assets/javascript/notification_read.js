$(document).ready(function() {
  $(".mark-read-button").on("click", function() {
    var notificationId = $(this).data("notification_id");
    console.log(notificationId);
    var buttonElement = $(this);

    $.ajax({
      url: "/notifications/mark/" + notificationId,
      method: "PATCH",
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: function(response) {
        let notification = "notification-" + notificationId;
        const notificationDiv = document.getElementById(notification);

        if (notificationDiv) {
          notificationDiv.remove();
          var counterElement = document.getElementById('notificationCounter');
          var counter = parseInt(counterElement.textContent);
          counter -= 1;
          counterElement.textContent = counter;
        }
      },
      error: function(xhr, status, error) {
        console.error("AJAX Error:", error);
      },
      complete: function() {
        buttonElement.prop('disabled', false);
      }
    });
    buttonElement.prop('disabled', true);
  });
});
