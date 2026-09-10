module SearchesHelper
  def search_target_label
    if params[:search_type] == "user_name"
      "Users"
    elsif
      "Books"
    end
  end
end
