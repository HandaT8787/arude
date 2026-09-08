document.addEventListener("turbo:load", function(){
  const swiperEl = document.querySelector(".post-swiper");
  if (!swiperEl) return;

  new Swiper(".post-swiper", {
    autoplay: { delay: 4000, disableOnInteraction: false, waitForTransition: false },
    loop: true,
    loopAdditionalSlides: 1,
    pagination: { el: ".swiper-pagination", clickable: true },
    navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
  });
});