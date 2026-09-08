document.addEventListener("turbo:load", function () {
  const RATY_IMAGE_PATH = "https://cdn.jsdelivr.net/npm/jquery-raty-js@2.8.0/lib/images/";

  // 入力用
  const starEls = document.querySelectorAll(".rating-star");
  starEls.forEach((el) => {
    const scoreFieldId = el.dataset.scoreField;
    const scoreInput = document.getElementById(scoreFieldId);

    $(el).raty({
      path: RATY_IMAGE_PATH,
      score: scoreInput.value || 0,
      half: false,
      click: function (score) {
        scoreInput.value = score;
      },
    });
  });

  // 表示用
  const readonlyStarEls = document.querySelectorAll(".rating-star-readonly");
  readonlyStarEls.forEach((el) => {
    $(el).raty({
      path: RATY_IMAGE_PATH,
      score: el.dataset.score,
      readOnly: true,
      half: false,
      size: 16,
    });
  });
});