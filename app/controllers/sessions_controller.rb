class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:omniauth]
  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    
    if user.persisted?
      session[:user_id] = user.id
      redirect_to tasks_path, notice: "Welcome back, #{user.display_name}!"
    else
      redirect_to root_path, alert: 'There was an error signing you in.'
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'You have been signed out.'
  end
end
