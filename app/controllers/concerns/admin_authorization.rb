module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :require_admin!
  end

  private

  def require_admin!
    redirect_to root_path unless current_user.is_admin?
  end

end