$(document).ready(function() {
  $('#editBrandModal').on('show.bs.modal', function(event) {
    var button = $(event.relatedTarget); // Button that triggered the modal
    var brandId = button.closest('tr').data('brands-id'); // Extract the brand ID from the closest 'tr' element
    var modal = $(this);
    var brandName = button.closest('tr').find('.brand-name').text(); // Extract the brand name from the closest 'tr' element

    // Make an AJAX request to fetch the brand details
    $.ajax({
      url: '/brands/' + brandId + '/edit',
      type: 'GET',
      success: function(data) {
        modal.find('#edit-brand-name').val(brandName); // Populate the form field with the brand name
        modal.find('form').attr('action', '/brands/' + brandId); // Set the form action to the appropriate brand update path
      }
    });
  });

  // Update Brand Form - Submit event handler
  $('#edit-brand-form').on('submit', function(event) {
    event.preventDefault(); // Prevent the form from submitting normally

    var form = $(this);
    var url = form.attr('action'); // Get the form action URL
    var formData = form.serialize(); // Serialize the form data

    // Submit the form using AJAX
    $.ajax({
      url: url,
      type: 'PATCH',
      data: formData,
      success: function(response) {
        console.log(response.success); // Display a success message to the user
        $('#editBrandModal').modal('hide'); // Hide the modal
        // Perform any other necessary actions on success
        
        // Update the brand name in the brand list
        var brandId = url.split('/').pop();
        var brandRow = $('tr[data-brands-id="' + brandId + '"]');
        brandRow.find('.brand-name').text(form.find('#edit-brand-name').val());
      },
      error: function(xhr, status, error) {
        console.log(xhr.responseJSON.error); // Display an error message to the user
        // Perform any other necessary actions on error
      }
    });
  });
});
