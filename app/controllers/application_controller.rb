class ApplicationController < ActionController::Base
  # CSRF protection is enabled by default in Rails
  # This ensures it's explicitly configured
  protect_from_forgery with: :exception
end
