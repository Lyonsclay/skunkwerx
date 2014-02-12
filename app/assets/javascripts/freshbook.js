$(document).ready(function () {
        if (!window.btoa) window.btoa = base64.encode;
        var postData = '<?xml version="1.0" encoding="utf-8"?><request method="client.list"></request>';
        $.ajax({
            type: "POST",
            url: "https://vikkisoft.freshbooks.com/api/2.1/xml-in",
            data: postData,
            cache: false,
            crossDomain: true,
            dataType: "xml",
            headers: {
                'Authorization': make_base_auth('e8195ab979fec886600e104eb3d80522', 'X'),
                'content-type': 'application/x-www-form-urlencoded'
            },
            success: function (d) {
                alert("success");
                alert(d.text);
            },
            error: function (e, textStatus, errorThrown) {
                alert("error");
                alert(textStatus);
                alert(errorThrown);
            },
            complete: function (xhr, status) {
                alert(xhr.responseText);
            }
        });
    });
         function make_base_auth(user, password) {
             var tok = user + ':' + password;
             var hash = window.btoa(tok);
             return "Basic " + hash;
         }



// if ($('#get_item_list').size) {

// 	$(document).on('ready page:load', function() {

// 		var xmlDocument = '<request method="item.list"><page>1</page><per_page></per_page><folder>active</folder></request>';
// 		var url = "https://skunkwerxperformanceautomotivellc.freshbooks.com/api/2.1/xml-in";

// var client = new XMLHttpRequest()
// 		client.open("GET", url)
// 		client.onreadystatechange = function(data) {
// 			alert(data);
// 		}
// 		beforeSend : function(xhr) {
// 			xhr.setRequestHeader('Authorization ', make_base_auth());
// 	  }

// 		// var originRequest = $.ajax({
// 		// 	type: 'GET',
// 		// 	url: url,
// 		// 	origin: "localhost:3000"
// 		// });

// 		// originRequest.done(function(msg) {
// 		// 	alert(msg);
// 		// });

// 		// var xmlRequest = $.ajax({
// 	 //    type: 'GET',
// 	 //    url: url,
// 	 //    processData: false,
// 	 //    data: xmlDocument,
// 	 //    beforeSend: function (xhr) {
// 	 //        xhr.setRequestHeader('Authorization ', make_base_auth());
// 	 //    },
// 		// });

// 		var user="9060c77f9995a67283430a2fb07d35d1"
// 		var password;
// 		function make_base_auth(user, password) {
// 		    var tok = user + ':' + password;
// 		    var hash = btoa(tok);
// 		    return 'Basic ' + hash;
// 		};

// 		xmlRequest.done(function(msg) {
// 			alert(msg);
// 		});
// 	});
// });