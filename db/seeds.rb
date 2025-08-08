# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing tasks
Task.destroy_all

# Create sample tasks
sample_tasks = [
  {
    title: "Complete project proposal",
    description: "Write a comprehensive project proposal for the new client including timeline, budget, and deliverables.",
    priority: 4,
    due_date: 2.days.from_now,
    completed: false
  },
  {
    title: "Review pull requests",
    description: "Review and merge outstanding pull requests from the development team.",
    priority: 3,
    due_date: 1.day.from_now,
    completed: false
  },
  {
    title: "Update documentation",
    description: "Update the API documentation with the latest changes.",
    priority: 2,
    due_date: 1.week.from_now,
    completed: false
  },
  {
    title: "Team meeting preparation",
    description: "Prepare agenda and materials for next week's team meeting.",
    priority: 2,
    due_date: 3.days.from_now,
    completed: true
  },
  {
    title: "Database backup",
    description: "Perform weekly database backup and verify integrity.",
    priority: 5,
    due_date: Date.current,
    completed: false
  },
  {
    title: "Code refactoring",
    description: "Refactor the authentication module to improve performance.",
    priority: 3,
    due_date: 2.weeks.from_now,
    completed: false
  },
  {
    title: "Client call",
    description: "Weekly check-in call with the client to discuss progress.",
    priority: 3,
    due_date: Date.yesterday,
    completed: true
  },
  {
    title: "Setup CI/CD pipeline",
    description: "Configure continuous integration and deployment pipeline for the new project.",
    priority: 4,
    due_date: 1.week.from_now,
    completed: false
  }
]

sample_tasks.each do |task_data|
  Task.create!(task_data)
end

puts "Created #{Task.count} sample tasks!"
puts "Pending tasks: #{Task.pending.count}"
puts "Completed tasks: #{Task.completed.count}"
