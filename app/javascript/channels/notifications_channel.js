import consumer from "./consumer"

consumer.subscriptions.create({ channel: "NotificationsChannel" }, {
  connected() {
    console.log("Connected to the notifications channel!");
  },

  disconnected() {
  },

  received(data) {
    const modalBody = document.getElementById('modalBody');
    const notificationItem = document.createElement('div');
    notificationItem.className = 'notification-item';
    const notification = data.notification;
    
    const notificationContent = `
      <div class="notification-item" id="notification-${notification.id}">
        <div class="row notification-priority-${notification.priority}">
          <div class="col-10">
            <div class="notification-content">
              <p class="notification-text">${notification.message}</p>
              <small class="text-muted">Sent on ${new Date(notification.created_at).toLocaleString('en-US', { month: 'long', day: 'numeric', year: 'numeric', hour: 'numeric', minute: 'numeric' })}</small>
              <button class="btn btn-sm add-btn mark-read-button" id="mark_${notification.id}" data-notification_id="${notification.id}">
                <i class="fa-solid fa-check"></i> Mark read
              </button>
            </div>
          </div>
        </div>
        <hr>
      </div>
    `;
    notificationItem.innerHTML = notificationContent;
    modalBody.appendChild(notificationItem);

    const markReadButton = notificationItem.querySelector(`#mark_${notification.id}`);
    markReadButton.addEventListener('click', handleMarkReadButtonClick);

    var counterElement = document.getElementById('notificationCounter');
    var counter = parseInt(counterElement.textContent);
    counter += 1;
    counterElement.textContent = counter;
  }
});


const handleMarkReadButtonClick = function(event) {
  var notification_id = this.getAttribute('data-notification_id');
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
};

