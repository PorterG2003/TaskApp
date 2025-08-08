# Debug database configuration in production
if Rails.env.production?
  Rails.application.config.after_initialize do
    if ENV['DATABASE_URL'].present?
      db_url = ENV['DATABASE_URL']
      # Log the database URL without sensitive parts
      safe_url = db_url.gsub(/\/\/[^:]+:[^@]+@/, '//***:***@')
      Rails.logger.info "DATABASE_URL is set: #{safe_url}"
    else
      Rails.logger.error "DATABASE_URL is NOT set!"
    end
  end
end 