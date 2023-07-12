window.initMap = function() {
  // Use HTML5 geolocation to get the user's current position
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var currentLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      var map = new google.maps.Map(document.getElementById('map'), {
        center: currentLocation,
        zoom: 15
      });

      var request = {
        location: currentLocation,
        radius: '5000',  // 5km
        type: ['hospital', 'doctor'],  // 整形外科を含む病院と医師を検索
        keyword: ['整形外科', '総合病院']  // '整形外科'と'総合病院'を含む場所を検索
      };

      var service = new google.maps.places.PlacesService(map);
      service.nearbySearch(request, callback);

      function callback(results, status) {
        if (status === google.maps.places.PlacesServiceStatus.OK) {
          for (var i = 0; i < results.length; i++) {
            createMarker(results[i]);
          }
        }
      }

      function createMarker(place) {
        var placeLoc = place.geometry.location;
        var markerIcon = {
          url: 'https://maps.google.com/mapfiles/marker_green.png',  // Change marker color to green
          scaledSize: new google.maps.Size(50, 50)  // Decrease marker size
        };
        var marker = new google.maps.Marker({
          map: map,
          position: placeLoc,
          icon: markerIcon,
          animation: google.maps.Animation.DROP
        });

        var infowindow = new google.maps.InfoWindow();
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.setContent(place.name);
          infowindow.open(map, marker);
        });
      }
    }, function(error) {
      // 現在位置の取得に失敗した時の処理
      console.error('Error occurred in geolocation: ' + error.message);
    });
  } else {
    // Browser doesn't support Geolocation
    console.log("Geolocation is not supported by this browser.");
  }
}
