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