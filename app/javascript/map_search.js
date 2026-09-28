document.addEventListener("turbo:load", function() {
  const mapEl = document.getElementById("map-search");
  if (!mapEl) return;

  function initializeMap() {
    const postsData = JSON.parse(mapEl.dataset.posts);
    const centerLat = parseFloat(mapEl.dataset.centerLat);
    const centerLng = parseFloat(mapEl.dataset.centerLng);
    const locationButton = document.getElementById("use-current-location");

    const map = new google.maps.Map(mapEl, {
      center: { lat: centerLat, lng: centerLng },
      zoom: 12,
      mapTypeControl: false,
    });

    const searchButton = document.getElementById("search-here-button");

    function searchAtMapCenter() {
      const center = map.getCenter();
      const lat = center.lat();
      const lng = center.lng();
      document.getElementById("map-search-lat").value = lat
      document.getElementById("map-search-lng").value = lng
          
      searchButton.closest("form").submit();
    };

    if (searchButton) {
      searchButton.addEventListener("click", function() {
        searchAtMapCenter();
      });
    };
    
    postsData.forEach(function(post) {
      const marker = new google.maps.Marker({
        position: { lat: post.latitude, lng: post.longitude },
        map: map,
      });

      const infoWindow = new google.maps.InfoWindow({
        content: `<div style="max-width:200px;">
          <strong>${post.title}</strong><br>
          <a href="/posts/${post.id}">詳細を見る</a>
        </div>`,
      });

      marker.addListener("click", function () {
        infoWindow.open(map, marker);
      });
    });

    // 「現在地を使う」ボタン
    if (locationButton) {
      locationButton.addEventListener("click", function() {
        if (!navigator.geolocation) {
          alert("このブラウザは現在地の取得に対応していません");
          return;
        }
        navigator.geolocation.getCurrentPosition(
          function (pos) {
            const currentPos = new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude);
            map.setCenter(currentPos);
            map.setZoom(12);
            searchAtMapCenter();
          },
          function() {
            alert("現在地を取得できませんでした");
          }
        );
      });
    }
  }

  if (typeof google !== "undefined" && google.maps) {
    initializeMap();
  } else {
    document.addEventListener("google-maps-ready", initializeMap, { once: true });
  }
});