class ApplicationController < ActionController::Base
  # Ensure CSRF protection is enabled
  protect_from_forgery with: :exception

  def default_url_options
    { host: 'localhost', port: 3000 }
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  # These methods were added but are not needed since we're using the Admin model directly
  # Removing them to avoid confusion

  protected

  def configure_permitted_parameters
    # Add address fields to sign up and account update
    address_fields = %i[name address city province province_id]

    devise_parameter_sanitizer.permit(:sign_up, keys: address_fields)
    devise_parameter_sanitizer.permit(:account_update, keys: address_fields)
  end
end
