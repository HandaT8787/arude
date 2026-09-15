class HomesController < ApplicationController
  def top
    @today_posts = Post.order("RAND()").limit(3)
  end
end
