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
    
    const notificationContent = `
      <div class="row notification-priority-${data.notification['priority']}">
        <div class="col-10">
          <div class="notification-content">
            <p class="notification-text">${data.notification['message']}</p>
            <small class="text-muted">Sent on ${data.notification['created_at']}</small>
          </div>
        </div>
      </div>
      <hr>
    `;

    notificationItem.innerHTML = notificationContent;
    modalBody.appendChild(notificationItem);

    var counterElement = document.getElementById('notificationCounter');
    var counter = parseInt(counterElement.textContent);
    counter += 1;
    counterElement.textContent = counter;
  }
});
