document.addEventListener('DOMContentLoaded', function() {
  const markReadButtons = document.querySelectorAll('.mark-read-button');

  markReadButtons.forEach(button => {
      button.addEventListener('click', function(event) {
          var notification_id = this.getAttribute('data-notification-id');
          let notification = "notification-" + notification_id;
          const notificationDiv = document.getElementById(notification);
          
          if (notificationDiv) {
            const form = this.closest('form');
            if (form) {
                form.submit();
            }
            notificationDiv.remove();
            var counterElement = document.getElementById('notificationCounter');
            var counter = parseInt(counterElement.textContent);
            counter -= 1;
            counterElement.textContent = counter;
          }
          
          event.preventDefault();
      });
  });
});
