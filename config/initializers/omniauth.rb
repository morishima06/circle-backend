# frozen_string_literal: true

OmniAuth.config.allowed_request_methods = %i[get post]
# OmniAuth.config.silence_get_warning = true
OmniAuth.config.full_host = 'http://localhost:5001'
OmniAuth.config.on_failure = proc do |env|
  Rails.logger.error "OmniAuth Error: #{env['omniauth.error']}"
  Rails.logger.error "OmniAuth Error Strategy: #{env['omniauth.error.strategy']}"
  Rails.logger.error "OmniAuth Full Environment: #{env.inspect}"
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV.fetch('GOOGLE_CLIENT_ID', nil), ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
           {

             redirect_uri: 'http://localhost:5001/api/v1/auth/google_oauth2/callback',
             callback_path: '/api/v1/auth/google_oauth2/callback'
           }
end
