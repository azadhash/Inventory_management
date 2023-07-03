import consumer from "./consumer"

consumer.subscriptions.create({ channel: "NotificationsChannel" }, {
  connected() {
    console.log("Connected to the notifications channel!");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var li = document.createElement('li');
    var a = document.createElement('a');
    a.className = 'dropdown-item';
    a.href = '#';
    a.textContent = data.notification['message'];

    li.appendChild(a);

      document.getElementById('notification').appendChild(li);

    // Called when there's incoming data on the websocket for this channel
  }
});
