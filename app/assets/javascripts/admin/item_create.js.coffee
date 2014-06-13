# $(document).on 'ready page:load', ->

# if document.URL == "http://localhost:3000/admin/malone_tunes"
# tuneIDS = $('#tune_ids').data('tune-ids')
# alert tuneIDS

ready = ->
	tuneIDS = $('#tune_ids').data('tune-ids')
	console.log tuneIDS
	$.post '/admin/freshbooks/tunes_create',
		tune_ids: tuneIDS
		(data) -> $('.notice').append "Succesfully sent data:-/"

$(document).ready(ready)
$(document).on('page:load', ready)