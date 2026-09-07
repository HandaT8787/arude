class VisitsController < ApplicationController
  before_action :set_post

  def new
    @visit = @post.visits.build
    Rating::RATING_CATEGORIES.each do |category|
      @visit.ratings.build(category: category)
    end
  end

  def create
    @visit = @post.visits.build(visit_params)
    @visit.user == current_user

    if @visit.save
      redirect_to @post, notice: "行ってみたを記録しました"
    else
      redirect_to new, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def visit_params
    params.requier(:visit).permit(
      :impression, :visited_at, :photos[],
      ratings_attributes: [:category, :score]
    )
  end
end
