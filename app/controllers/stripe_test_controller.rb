class StripeTestController < ApplicationController
  def test
    api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    if api_key.present?
      render plain: 'Stripe API key is configured correctly!'
    else
      render plain: 'Stripe API key is missing from credentials!'
    end
  end
end
