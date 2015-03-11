// On document load execute code for directions to business.
$(document).on('page:change', function() {
  // Only load script if on contact page.
  if ($('#map_canvas').length){

    // Create new map with infowindow and marker. //

    // Attempt to get the new google maps look.- doesn't work
    google.maps.visualRefresh = true;
    // New map with a map_canvas ( width, height ) and options.
    var map_canvas = document.getElementById('map_canvas');
    // Latlng for buisiness hardcoded.
    var myLatlng = new google.maps.LatLng(38.2005064, -85.7106286);
    var map_options = {
      center: myLatlng,
      zoom: 12,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: true
    }
    var map = new google.maps.Map(map_canvas, map_options);

    // Create infowindow with content text.
    var infowindow = new google.maps.InfoWindow({
        content: "Skunkwerx Performance LLC"
    });

    // Create new marker for business address.
    var marker = new google.maps.Marker({
      position: myLatlng,
      map: map,
      title: 'Skunkwerx Performance'
    });
    // Add event listener for click that reveals infowindow.
    google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map,marker);
    });

    // Using DirectionsService to display directions.

    // Create new instance of DirectionsService and DirectionsRenderer.
    var directionsDisplay;
    var directionsService = new google.maps.DirectionsService();
    function initialize() {
      directionsDisplay = new google.maps.DirectionsRenderer();

      // Using the instance of Map that was created upon document load.
      directionsDisplay.setMap(map);
      directionsDisplay.setPanel(document.getElementById("directionsPanel"));
    }

    // Get the user address, send request to DirectionsService,
    // and display result on current map.
    function calcRoute() {
      var start = document.getElementById("address").value;
      //var end = document.getElementById("end").value;
      var request = {
        origin: start,
        destination: myLatlng,
        provideRouteAlternatives: false,
        travelMode: google.maps.TravelMode.DRIVING,
        unitSystem: google.maps.UnitSystem.IMPERIAL
      };
      directionsService.route(request, function(result, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(result);
        }
      });
    }

    // Run code on button click.
    $('input[type="button"][value="Get Directions"]').click(function(){
      initialize();
      calcRoute();
    });
  }
});




