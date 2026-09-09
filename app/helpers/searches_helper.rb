module SearchesHelper
  def search_target_label
    if params[:search_type] == "user_name"
      "Users"
    else
      "Books"
    end
  end
end
