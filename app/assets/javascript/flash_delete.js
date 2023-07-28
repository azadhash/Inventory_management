function hideFlashMessage() {
  setTimeout(function() {
    $('#flash-messages').fadeOut('slow');
  }, 2000);
}

$(document).ready(function() {
  hideFlashMessage();
});