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
      new google.maps.Marker({
        position: { lat: post.latitude, lng: post.longitude },
        map: map,
      });
    });
  }

  if (typeof google !== "undefined" && google.maps) {
    initializeMap();
  } else {
    document.addEventListener("google-maps-ready", initializeMap, { once: true });
  }
});