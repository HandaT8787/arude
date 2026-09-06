# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "post_swiper", to: "post_swiper.js"
pin "post_map_picker", to: "post_map_picker.js"
pin "post_map_viewer", to: "post_map_viewer.js"
pin "post_photo_modal", to: "post_photo_modal.js"