# frozen_string_literal: true

# app/controllers/base_controller.rb
class BaseController < ApplicationController
  protect_from_forgery with: :null_session
end
