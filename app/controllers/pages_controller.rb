class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def offline
  end
  
  def migrate
    # Add debugging
    Rails.logger.info "Migration attempt with key: #{params[:key]}"
    Rails.logger.info "Expected key: #{ENV['MIGRATION_SECRET_KEY']}"
    Rails.logger.info "Production environment: #{Rails.env.production?}"
    
    # Only allow in production and with a secret key
    if Rails.env.production? && params[:key] == ENV['MIGRATION_SECRET_KEY']
      begin
        Rails.logger.info "Starting migration..."
        Rake::Task["deploy:migrate"].invoke
        Rails.logger.info "Migration completed successfully"
        render json: { status: "success", message: "Database migration completed" }
      rescue => e
        Rails.logger.error "Migration failed: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        render json: { status: "error", message: e.message }, status: 500
      end
    else
      Rails.logger.warn "Migration unauthorized - key mismatch or not production"
      render json: { status: "error", message: "Unauthorized" }, status: 401
    end
  end
end
