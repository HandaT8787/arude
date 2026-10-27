class HomesController < ApplicationController
  def top
    random_order = ActiveRecord::Base.connection.adapter_name == "Mysql2" ? "RAND()" : "RANDOM()"
    visible_posts = Post.visible_to(current_user)

    if my_residence = current_user.current_residence
      nearby_posts = visible_posts.where.not(latitude: nil, longitude: nil)
        .near([my_residence.latitude, my_residence.longitude], 10)
        .to_a
      
      if nearby_posts.size < 3
        nearby_posts = visible_posts.where.not(latitude: nil, longitude: nil)
        .near([my_residence.latitude, my_residence.longitude], 20)
        .to_a
      end

      if nearby_posts.size < 3
        @today_posts = visible_posts.order(random_order).limit(3)
      else
        @today_posts = nearby_posts.sample(3)
      end
    else
      @today_posts = visible_posts.order(random_order).limit(3)
    end
  end
end
