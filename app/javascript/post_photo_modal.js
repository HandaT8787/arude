document.addEventListener("turbo:load", function() {
  const modalEl = document.getElementById("photoModal");
  if (!modalEl) return;

  const modalImage = document.getElementById("photoModalImage");

  document.querySelectorAll(".post-carousel-img").forEach((img) => {
    img.addEventListener("click", function() {
      modalImage.src = img.src;
    });
  });
});