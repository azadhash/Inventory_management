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
        if (data.success) {
          $(`tr[data-${entityType}-id="${entityId}"]`).remove();
          if ($('.table-info').length === 0) {
            var numCols = $('thead tr.table-primary th').length;
            $('.entities-list').append('<tr id="notFound"><td colspan="' + numCols + '" class="text-center">No ' + entityType + ' found.</td></tr>');                        
          }
          $('#flash-messages').html('<div class="alert alert-success alert-dismissible fade show" role="alert">' +
            data.success +
            '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
            '</div>');
        } else {
          alert(data.error);
        }
      }
    });
  }
});
