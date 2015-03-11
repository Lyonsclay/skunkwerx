# Manage engine/model/years selections.
do ($, window) ->
  jQuery ->
    blank = "\n<option value=\"0\"></option>"
    model = $('#add_from_list_model_id')
    models = model.html()
    model.empty()
    engine = $('#add_from_list_engine_id')
    engines = engine.html()
    engine.empty()
    years = $('#add_from_list_years_id')
    years.empty()
    $('#add_from_list_make_id').change ->
      if $('#add_from_list_make_id')
        make_selected = $('#add_from_list_make_id :selected').text()
      options = blank + $(models).filter("optgroup[label=#{make_selected}]").html()
      if options
        model.html(options)
        engine.empty()
        years.empty()
    model.change ->
      model_selected = $('#add_from_list_model_id :selected').text()
      options = blank + $(engines).filter("optgroup[label=#{model_selected}]").html()
      if options
        engine.empty()
        years.empty()
        engine.html(options)
    engine.change ->
      $('#engine_selected').val($('#add_from_list_engine_id :selected').text().trim())
      years_selected = JSON.parse($('#add_from_list_engine_id option:selected').val())
      $("#add_from_list_years_id").html("<option>#{years_selected[0] + '-' + years_selected[1]}</option>")

