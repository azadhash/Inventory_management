$(document).ready(function() {
  fetchData(); 
  $('#category-select').on('change', function() {
    fetchData();
  });
  function fetchData() {
    var selectedCategoryId = $('#category-select').val();
    if (selectedCategoryId) {
      $.ajax({
        url: '/categories/fetch',
        type: 'GET',
        data: { category_id: selectedCategoryId },
        dataType: 'json',
        success: function(response) {
          $('#result-container').text(response.storage);
        },
        error: function() {
          $('#result-container').empty();
        }
      });
    } else {
      $('#result-container').empty();
    }
  }
});
