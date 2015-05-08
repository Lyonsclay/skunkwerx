# manage engine/model/years selections.
do ($, window) ->
  jQuery ->
    blank = "\n<option value=\"0\"></option>"
    model = $('#select_vehicle_model_id')
    models = model.html()
    model.empty()
    engine = $('#select_vehicle_engine_id')
    engines = engine.html()
    engine.empty()
    year = $('#select_vehicle_year_range')
    years = year.html()
    year.empty()
    $('#select_vehicle_make_id').change ->
      make_selected = $('#select_vehicle_make_id :selected').text()
      options = blank + $(models).filter("optgroup[label=#{make_selected}]").html()
      model.html(options)
      model.change ->
        model_selected = $('#select_vehicle_model_id :selected')
        model_text = model_selected.text()
        model_id = model_selected.val()
        options = blank + $(engines).filter("optgroup[label=#{model_text}]").html()
        engine.html(options)
        engine.change ->
          engine_selected = $('#select_vehicle_engine_id :selected').val()
          selections_model = $(years).filter("optgroup[label=#{model_id}]")
          selections = selections_model.children().filter("option[value=#{engine_selected}]")
          options = blank + selections.parent().html()
          year.html(options)
          year.change ->
            year_selected = $('#select_vehicle_year_range :selected').text()
            $('#year_selected')[0].value = year_selected
