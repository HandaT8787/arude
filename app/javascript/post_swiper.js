document.addEventListener("turbo:load", function(){
  const swiperEl = document.querySelector(".post-swiper");
  if (!swiperEl) return;

  new Swiper(".post-swiper", {
    loop: true,
    pagination: { el: ".swiper-pagination", clickable: true },
    navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
  });
});