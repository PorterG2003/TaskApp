class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :priority, inclusion: { in: 1..5 }
  
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :by_priority, -> { order(:priority, :created_at) }
  scope :by_due_date, -> { order(:due_date, :created_at) }
  
  def overdue?
    due_date && due_date < Date.current && !completed?
  end
  
  def priority_label
    case priority
    when 1 then "Low"
    when 2 then "Medium"
    when 3 then "High"
    when 4 then "Urgent"
    when 5 then "Critical"
    else "Unknown"
    end
  end
  
  def priority_color
    case priority
    when 1 then "bg-green-100 text-green-800"
    when 2 then "bg-blue-100 text-blue-800"
    when 3 then "bg-yellow-100 text-yellow-800"
    when 4 then "bg-orange-100 text-orange-800"
    when 5 then "bg-red-100 text-red-800"
    else "bg-gray-100 text-gray-800"
    end
  end

  def priority_color_variant
    case priority
    when 1 then :success
    when 2 then :primary
    when 3 then :warning
    when 4 then :warning
    when 5 then :danger
    else :secondary
    end
  end
end
