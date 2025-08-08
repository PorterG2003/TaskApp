namespace :deploy do
  desc "Run database migrations for deployment"
  task migrate: :environment do
    puts "Starting database migration..."
    
    begin
      # Check if database exists
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "Database connection successful"
    rescue => e
      puts "Database connection failed: #{e.message}"
      puts "Creating database..."
      Rake::Task["db:create"].invoke
    end
    
    puts "Running migrations..."
    Rake::Task["db:migrate"].invoke
    
    puts "Verifying tables..."
    if ActiveRecord::Base.connection.table_exists?('users')
      puts "✅ Users table exists"
    else
      puts "❌ Users table does not exist"
    end
    
    if ActiveRecord::Base.connection.table_exists?('tasks')
      puts "✅ Tasks table exists"
    else
      puts "❌ Tasks table does not exist"
    end
    
    puts "Database migration completed!"
  end
end 