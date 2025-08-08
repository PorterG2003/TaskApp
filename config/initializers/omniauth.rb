# OmniAuth configuration for Google OAuth
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'] || 'placeholder_client_id',
           ENV['GOOGLE_CLIENT_SECRET'] || 'placeholder_secret',
           {
             scope: ['email', 'profile', 'https://www.googleapis.com/auth/calendar'],
             prompt: 'consent',
             access_type: 'offline'
           }
end

# Allow all requests in development
OmniAuth.config.allowed_request_methods = [:post, :get]

# Silence the GET warning for OAuth callbacks
OmniAuth.config.silence_get_warning = true