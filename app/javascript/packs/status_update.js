$(document).ready(function() {
  $('form[data-remote="true"]').on('ajax:success', function(event, data, status, xhr) {
    var issueId = $(this).data('issue-id');
    var statusCell = $('#status-cell-' + issueId);

    if (data && typeof data.status !== 'undefined') {
      if (data.status) {
        statusCell.html('<span class="text-success">Resolved</span>');
      } else {
        statusCell.html('<span class="text-warning">Pending</span>');
      }
    } else {
      console.log('Error: invalid response');
    }
  });
});
