document.addEventListener("turbo:load", function() {
  const mapEl = document.getElementById("map-search");
  if (!mapEl) return;

  function initializeMap() {
    const postsData = JSON.parse(mapEl.dataset.posts);
    const centerLat = parseFloat(mapEl.dataset.centerLat);
    const centerLng = parseFloat(mapEl.dataset.centerLng);

    const map = new google.maps.Map(mapEl, {
      center: { lat: centerLat, lng: centerLng },
      zoom: 12,
      mapTypeControl: false,
    });

    const searchButton = document.getElementById("search-here-button");
    if (searchButton) {
      searchButton.addEventListener("click", function() {
        const center = map.getCenter();
        const lat = center.lat();
        const lng = center.lng();

        document.getElementById("map-search-lat").value = lat
        document.getElementById("map-search-lng").value = lng
        
        searchButton.closest("form").submit();
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
  }

  if (typeof google !== "undefined" && google.maps) {
    initializeMap();
  } else {
    document.addEventListener("google-maps-ready", initializeMap, { once: true });
  }
});