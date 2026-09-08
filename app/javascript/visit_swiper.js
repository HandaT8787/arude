document.addEventListener("turbo:load", function(){
  document.querySelectorAll(".visit-swiper").forEach((el) => {
    const slideCount = el.querySelectorAll(".swiper-slide").length

    new Swiper(el, {
      autoplay: { delay: 4000, disableOnInteraction: false, waitForTransition: false },
      loop: slideCount >= 3,
      pagination: { el: el.querySelector(".swiper-pagination"), clickable: true },
      navigation: {
        nextEl: el.querySelector(".swiper-button-next"),
        prevEl: el.querySelector(".swiper-button-prev")
      },
    });
  });
});