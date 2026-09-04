document.addEventListener("turbo:load", function() {
  const mapEl = document.getElementById("post-map-picker");
  if (!mapEl) return;

  const latField = document.getElementById("post_latitude");
  const lngField = document.getElementById("post_longitude");
  const locationButton = document.getElementById("use-current-location");

  // 既存の値があればそこを初期位置にする、なければ東京駅付近をデフォルトにする
  const initialLat = parseFloat(latField.value) || 35.68
  const initialLng = parseFloat(lngField.value) || 139.7673

  const map = new google.maps.Map(mapEl, {
    center: { lat: initialLat, lng: initialLng },
    zoom: 15,
  });

  let marker = null;

  function placeMarker(position) {
    if (marker) {
      marker.setPosition(position);
    } else {
      marker = new google.maps.Marker({
        position: position,
        map: map,
        draggable: true,
      });
      marker.addListener("dragend", function() {
        updateFields(marker.getPosition());
      });
    }
    updateFields(position);
  }

  function updateFields(position) {
    latField.value = position.lat();
    lngField.value = position.lng();
  }

  // すでに緯度経度が入っている場合（編集時）は最初からピンを立てる
  if (latField.value && lngField.value) {
    placeMarker(new google.maps.LatLng(initialLat, initialLng));
  }

  // 地図をクリックしたらピンを立てる
  map.addListener("click", function (event) {
    placeMarker(event.latLng);
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
          placeMarker(currentPos);
        },
        function() {
          alert("現在地を取得できませんでした");
        }
      );
    });
  }
});