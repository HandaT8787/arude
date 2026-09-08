document.addEventListener("turbo:load", function() {
  const modalEl = document.getElementById("photoModal");
  if (!modalEl) return;

  const modalImage = document.getElementById("photoModalImage");

  document.querySelectorAll(".js-photo-modal-trigger").forEach((img) => {
    img.addEventListener("click", function() {
      modalImage.src = img.src;
    });
  });
});