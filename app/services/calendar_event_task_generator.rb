class CalendarEventTaskGenerator
  def initialize(event, user)
    @event = event
    @user = user
  end

  def generate
    Task.create!(
      title: generate_title,
      description: generate_description,
      due_date: @event.start.date_time || @event.start.date,
      user: @user,
      status: "pending",
      calendar_event_id: @event.id
    )
  end

  private

  def generate_title
    @event.summary
  end

  def generate_description
    description = []
    
    # Add event description if present
    description << @event.description if @event.description.present?
    
    # Add time information
    if @event.start.date_time
      start_time = @event.start.date_time.strftime("%I:%M %p")
      end_time = @event.end.date_time.strftime("%I:%M %p")
      description << "Time: #{start_time} - #{end_time}"
    end
    
    # Add location if present
    description << "Location: #{@event.location}" if @event.location.present?
    
    # Add link to event
    description << "Calendar Event Link: #{@event.html_link}" if @event.html_link.present?
    
    # Join all parts with line breaks
    description.join("\n\n")
  end
end