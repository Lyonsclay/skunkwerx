# if document.URL == "http://localhost:3000/admin/malone_tunes"

ready = ->
	tuneIDS = $('#tune_ids').data('tune-ids')
	console.log tuneIDS
	$.post '/admin/freshbooks/tunes_create',
		tune_ids: tuneIDS
		(data) -> $('.notice').append "Succesfully sent data:-/"
