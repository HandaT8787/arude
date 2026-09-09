class HomesController < ApplicationController
  def top
    @today_posts = Post.order("RANDOM()").limit(3)
  end
end
