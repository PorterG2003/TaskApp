class CalendarController < ApplicationController
  before_action :authenticate_user!
  before_action :set_events, only: [:index]
  def generate_task
    event = calendar_service.get_event(params[:calendar_id], params[:event_id])
    existing_task = current_user.tasks.find_by(calendar_event_id: event.id)

    task = if existing_task
      flash.now[:alert] = "A task for this event already exists"
      existing_task
    else
      CalendarEventTaskGenerator.new(event, current_user).generate
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("flash", partial: "shared/flash"),
          turbo_stream.replace(
            "calendar_event_#{params[:event_id]}", 
            partial: "events/event_card", 
            locals: { 
              event: event,
              calendar_id: params[:calendar_id],
              existing_task: task
            }
          )
        ]
      end
    end
  rescue Google::Apis::ClientError => e
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = "Could not create task: #{e.message}"
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
      end
    end
  end

  private

  def calendar_service
    @calendar_service ||= GoogleCalendarService.new(current_user)
  end

  def index
  end

  private

  def set_events
    # Initialize @events to empty array by default
    @events = []

    begin
      @date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    rescue ArgumentError
      @date = Time.zone.today
      flash.now[:alert] = "Invalid date parameter, showing current week"
    end

    @week_start = @date.beginning_of_week
    @week_end = @date.end_of_week
    
    start_time = @week_start.beginning_of_day.in_time_zone
    end_time = @week_end.end_of_day.in_time_zone

    begin
      @events = calendar_service.list_events(start_time: start_time, end_time: end_time) || []
    rescue => e
      Rails.logger.error("Failed to fetch calendar events: #{e.message}")
      flash.now[:alert] = "Could not fetch calendar events. Please try again later."
    end
  end
end