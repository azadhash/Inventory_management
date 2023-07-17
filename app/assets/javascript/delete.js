$(document).on('click', '.delete-button', function(e) {
  e.preventDefault();
  
  var entityId = $(this).data('entityId');
  var entityType = $(this).data('entityType');
  
  if (confirm('Are you sure you want to delete this ' + entityType + '?')) {
    var csrfToken = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      url: `/${entityType}/${entityId}`,
      method: 'delete',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      success: function(data) {
        if (data.hasOwnProperty('success')) {
          $(`tr[data-${entityType}-id="${entityId}"]`).remove();
          $('#flash-messages').html('<div class="alert alert-success alert-dismissible fade show" role="alert">' +
            data.success +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
            '</div>');
        } else {
          $('#flash-messages').html('<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
            'An error occurred while deleting ' + entityType + '. Please try again.' +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
            '</div>');
        } 
      },
      error: function(xhr, status, error) {
        var errorMessage = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : 'An error occurred while deleting ' + entityType + '. Please try again.';
        $('#flash-messages').html('<div class="alert alert-danger alert-dismissible fade show" role="alert">' +
          errorMessage +
          '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
          '</div>');
      }
    });
  }
});
