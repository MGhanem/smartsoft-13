 OmniAuth.config.logger = Logger.new(STDOUT)
 OmniAuth.logger.progname = "omniauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'y3D1eGgnppUGjKNP6C47GQ', '37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I'
  # provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'

  OmniAuth.config.on_failure = Proc.new { |env|
  	OmniAuth::FailureEndpoint.new(env).redirect_to_failure
  }

  OmniAuth.config.logger = Rails.logger
end
