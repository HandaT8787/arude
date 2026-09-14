class MapSearchesController < ApplicationController
  def index
    # 地図検索の半径設定
    @radius = params[:radius].presence || 5

    if params[:lat].present? && params[:lng].present?
      @center_lat = params[:lat].to_f
      @center_lng = params[:lng].to_f
    else
      if my_residence = current_user.current_residence
        @center_lat = my_residence.latitude
        @center_lng = my_residence.longitude
      else
        @center_lat = 35.681236
        @center_lng = 139.767125
      end
    end

    @posts = Post.where.not(latitude: nil, longitude: nil).near([@center_lat, @center_lng], @radius)
  end
end
