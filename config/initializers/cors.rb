# frozen_string_literal: true

allowed_origins =
  if Rails.env.production?
    [ENV.fetch('FRONTEND_URL')]
  else
    ['http://localhost:3000']
  end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end
