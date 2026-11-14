# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
class Application < Rails::Application
  # Initialize configuration defaults for originally generated Rails version.
  config.load_defaults 6.1
  config.active_record.schema_format = :sql

  config.middleware.use ActionDispatch::Cookies # クッキーを使う
  config.middleware.use ActionDispatch::Session::CookieStore
  config.middleware.use ActionDispatch::Flash
  # config.middleware.use ActionDispatch::Session::RedisStore, {
  #   servers: ["redis://localhost:6379/0/session"],
  #   key: '_app_session',
  #   expire_after: 30.days,
  #   threadsafe: false,
  #   secure: Rails.env.production?,
  #   httponly: true,
  #   same_site: :lax
  # }

  # SESSIONをREDISに保存する設定
  #  config.middleware.use ActionDispatch::Session::RedisStore,
  #  servers: ["redis://localhost:6379/0/session"],
  #   expire_after: 90.minutes,
  #   key: "_your_app_session",
  #   threadsafe: true,
  #   secure: false  # 開発環境であれば、secureはfalseにする

  # Rails.application.config.session_options[:key]

  # config.middleware.use ActionDispatch::ContentSecurityPolicy::Middleware

  # Rails.application.config.action_dispatch.cookies_same_site_protection = :none
  # config.action_dispatch.cookies_same_site_protection = :none

  # Configuration for the application, engines, and railties goes here.
  #
  # These settings can be overridden in specific environments using the files
  # in config/environments, which are processed later.
  #
  config.time_zone = 'Tokyo'
  config.active_record.default_timezone = :utc
  # config.eager_load_paths << Rails.root.join("extras")
  config.autoload_paths += %W[#{config.root}/app/services]
  config.autoload_paths += %W[#{config.root}/app/errors]
  config.active_job.queue_adapter = :sidekiq

  # Only loads a smaller set of middleware suitable for API only apps.
  # Middleware like session, flash, cookies can be added back manually.
  # Skip views, helpers and assets when generating a new resource.
  config.api_only = true

  # CORS設定を追加
  config.i18n.available_locales = [:ja]
  config.i18n.default_locale = :ja
end
