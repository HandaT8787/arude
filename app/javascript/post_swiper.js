document.addEventListener("turbo:load", function(){
  const swiperEl = document.querySelector(".post-swiper");
  if (!swiperEl) return;

  console.log("Swiper初期化開始");

  new Swiper(".post-swiper", {
    autoplay: { delay: 4000, disableOnInteraction: false, waitForTransition: false },
    rewind: true,
    pagination: { el: ".swiper-pagination", clickable: true },
    navigation: { nextEl: ".swiper-button-next", prevEl: ".swiper-button-prev" },
  });
});