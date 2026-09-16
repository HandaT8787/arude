document.addEventListener("turbo:load", function(){
  const swiperEl = document.querySelector(".post-swiper");
  if (!swiperEl) return;

  const slideCount = swiperEl.querySelectorAll(".swiper-slide").length;

  new Swiper(".post-swiper", {
    autoplay: { delay: 4000, disableOnInteraction: false, waitForTransition: false },
    loop: slideCount >= 3,
    pagination: { el: ".swiper-pagination", clickable: true },
    navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
  });
});