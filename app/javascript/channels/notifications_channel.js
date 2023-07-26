import consumer from "./consumer"

consumer.subscriptions.create({ channel: "NotificationsChannel" }, {
  connected() {
    console.log("Connected to the notifications channel!");
  },

  disconnected() {
  },

  received(data) {
    var li = document.createElement('li');
    var priority = 'text-'+ data.notification['priority'];
    li.classList.add('notification-item');
    li.classList.add(priority);
    li.innerHTML = data.notification['message'];

    document.getElementById('notification').appendChild(li);
    
    var counterElement = document.getElementById('notificationCounter');
    var counter = parseInt(counterElement.textContent);
    counter += 1;
    counterElement.textContent = counter;
  }
});
