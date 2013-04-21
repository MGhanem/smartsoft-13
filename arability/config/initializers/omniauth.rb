 OmniAuth.config.logger = Logger.new(STDOUT)
 OmniAuth.logger.progname = "omniauth"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'y3D1eGgnppUGjKNP6C47GQ', '37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I'
  OmniAuth.config.on_failure = Proc.new { |env|
  	OmniAuth::FailureEndpoint.new(env).redirect_to_failure  
  }
end

Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '155521981280754', 'a4d4684f0554e3637085e72eaa132890'  
end

OmniAuth.config.logger = Rails.logger


