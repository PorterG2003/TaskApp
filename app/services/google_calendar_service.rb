require "google/apis/calendar_v3"
require "googleauth"

class GoogleCalendarService
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

  def initialize(user)
    @user = user
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = "TaskApp"
    @service.authorization = build_authorization
  end

  def list_events(start_time:, end_time:)
    events = @service.list_events(
      "primary",
      single_events: true,
      order_by: "startTime",
      time_min: start_time.iso8601,
      time_max: end_time.iso8601
    )
    events.items || []
  rescue Google::Apis::AuthorizationError
    refresh_token!
    retry
  rescue StandardError => e
    Rails.logger.error("Google Calendar list_events error: #{e.class}: #{e.message}")
    []
  end

  def get_event(calendar_id, event_id)
    @service.get_event(calendar_id || "primary", event_id)
  rescue Google::Apis::AuthorizationError
    refresh_token!
    retry
  rescue StandardError => e
    Rails.logger.error("Google Calendar get_event error: #{e.class}: #{e.message}")
    raise
  end

  private

  attr_reader :user

  def build_authorization
    auth = Signet::OAuth2::Client.new(
      client_id: ENV["GOOGLE_CLIENT_ID"],
      client_secret: ENV["GOOGLE_CLIENT_SECRET"],
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: SCOPE
    )
    auth.access_token = user.google_token
    auth.refresh_token = user.google_refresh_token
    auth
  end

  def refresh_token!
    auth = build_authorization
    auth.fetch_access_token!
    user.update!(google_token: auth.access_token)
    @service.authorization = auth
  end
end