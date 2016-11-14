// begin new project
$(document).on("change", "#language", function() {
  var language = $(this).val()

  if (language.length > 0) {
    $("#catalog_id").prop('disabled', false)
  } else {
    $("#catalog_id").prop('disabled', true)
    return
  }

  var catalog_id = "#" + language + "_catalog"

  $("#catalog_id").html( $(catalog_id).html() )

  $("#project_category_id").val('')
  $("#project_category_id option").addClass('hidden')
  $("#project_category_id option:first").removeClass('hidden')
})

$(document).on("change", "#language", function() {
  var identity = $(this).val()

  var project_identity = $("#project_identity")

  if (identity == 'rails') {
    project_identity.val('gem')
  } else if (identity == 'laravel') {
    project_identity.val('package')
  } else if (identity == 'swift') {
    project_identity.val('pod')
  } else {
    project_identity.val('unknow')
  }
})

$(document).on("change", "#catalog_id", function() {
  var catalog = $(this).val()

  if (catalog.length > 0) {
    $("#project_category_id").prop('disabled', false)
  } else {
    $("#project_category_id").prop('disabled', true)
    return
  }

  $("#project_category_id option").addClass('hidden')

  var category_id = "." + "catalog-" + catalog
  $(category_id).removeClass('hidden')

  $("#project_category_id").val('')
  $("#project_category_id option:first").removeClass('hidden')
})
// end new project
