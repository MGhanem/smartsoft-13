Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/store/filesystem'

  provider :twitter, "y3D1eGgnppUGjKNP6C47GQ", "37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I"

  provider :facebook, "155521981280754", "a4d4684f0554e3637085e72eaa132890",
    {scope: "email, offline_access, publish_stream",
  	client_options: {ssl: {ca_path: "/etc/ssl/certs"}}}

  provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google',
    :identifier => 'https://www.google.com/accounts/o8/id'

  provider :google_oauth2, "758114528235-3b33edh32qsu3mfnqpqd3n1v9e3ov4ql.apps.googleusercontent.com",
    "ittGQy5A3HcGMG2lXnNQ3t_X"

  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure  
  }
end

OmniAuth.config.logger = Rails.logger