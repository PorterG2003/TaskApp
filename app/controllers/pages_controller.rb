class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def offline
  end
  
  def migrate
    # Only allow in production and with a secret key
    if Rails.env.production? && params[:key] == ENV['MIGRATION_SECRET_KEY']
      begin
        Rake::Task["deploy:migrate"].invoke
        render json: { status: "success", message: "Database migration completed" }
      rescue => e
        render json: { status: "error", message: e.message }, status: 500
      end
    else
      render json: { status: "error", message: "Unauthorized" }, status: 401
    end
  end
end
