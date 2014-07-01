
$(document).ready(function() {
  $('#settings_inherit_tracker_id').click(function() {
    if ($('#settings_inherit_tracker_id').is(':checked')) {
      $('#settings_default_tracker_id').hide();
      $('#settings_default_tracker_id_label').hide();
    } else {
      $('#settings_default_tracker_id').show();
      $('#settings_default_tracker_id_label').show();
    }
  });
    
  if ($('#settings_inherit_tracker_id').is(':checked')) {
    $('#settings_default_tracker_id').hide();
    $('#settings_default_tracker_id_label').hide();
  }
});
