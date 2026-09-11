class MapSearchesController < ApplicationController
  def index
    @posts = Post.where.not(latitude: nil, longitude: nil)
    if my_residence = current_user.current_residence
      @center_lat = my_residence.latitude
      @center_lng = my_residence.longitude
    else
      @center_lat = 35.681236
      @center_lng = 139.767125
    end
  end
end
