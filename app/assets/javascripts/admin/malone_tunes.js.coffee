jQuery ->
  blank = "\n<option value=\"0\"></option>"
  models = $('#model_id').html()
  $('#model_id').empty()
  engines = $('#engine_id').html()
  $('#engine_id').empty()
  $('#years_id').empty()

  $('#make_id').change ->
    if $('#make_id')
      make = $('#make_id :selected').text()
    options = blank + $(models).filter("optgroup[label=#{make}]").html()
    console.log(options)
    if options
      $('#model_id').html(options)
    else
      $('#model_id').empty()
  $('#model_id').change ->
    model = $('#model_id :selected').text()
    options = blank + $(engines).filter("optgroup[label=#{model}]").html()
    console.log(options)
    if options
      $('#engine_id').html(options)
    else
      $('#engine_id').empty()
  $('#engine_id').change ->
    $('#engine_selected').val($('#engine_id').text().trim())
    years = JSON.parse($('#engine_id option:selected').val())
    console.log(years)
    $("#years_id").html("<option>#{years[0] + '-' + years[1]}</option>")
