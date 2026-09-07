document.addEventListener("turbo:load", function() {
  const mapEl = document.getElementById("post-map");
  if (!mapEl) return;

  const lat = parseFloat(mapEl.dataset.lat);
  const lng = parseFloat(mapEl.dataset.lng);

  if (isNaN(lat) || isNaN(lng)) return;

  const position = { lat: lat, lng: lng };

  const map = new google.maps.Map(mapEl, {
    center: position,
    zoom: 15,
    mapTypeControl: false,
  });

  new google.maps.Marker({
    position: position,
    map: map,
  });
});