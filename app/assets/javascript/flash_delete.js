function hideFlashMessage() {
  setTimeout(function() {
    $('#flash-messages').fadeOut('slow');
  }, 2000); // 5000 milliseconds (5 seconds)
}

// Trigger the function when the page is ready
$(document).ready(function() {
  hideFlashMessage();
});