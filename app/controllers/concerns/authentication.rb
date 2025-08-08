module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to_login
    end
  end

  def redirect_to_login
    redirect_to root_path, alert: "Please sign in to access this page"
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end
end