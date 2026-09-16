class HomesController < ApplicationController
  def top
    random_order = ActiveRecord::Base.connection.adapter_name == "Mysql2" ? "RAND()" : "RANDOM()"

    if my_residence = current_user.current_residence
      nearby_posts = Post.where.not(latitude: nil, longitude: nil)
        .near([my_residence.latitude, my_residence.longitude], 10)
      
      if nearby_posts.count < 3
        nearby_posts = Post.where.not(latitude: nil, longitude: nil)
        .near([my_residence.latitude, my_residence.longitude], 20)
      end

      if nearby_posts.count < 3
        @today_posts = Post.order(random_order).limit(3)
      else
        @today_posts = nearby_posts.order(random_order).limit(3)
      end
    else
      @today_posts = Post.order(random_order).limit(3)
    end
  end
end
