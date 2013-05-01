Rails.application.config.middleware.use OmniAuth::Builder do
  # configuring twitter
  provider :twitter, "y3D1eGgnppUGjKNP6C47GQ", "37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I"
  # configuring facebook
  provider :facebook, "155521981280754", "a4d4684f0554e3637085e72eaa132890",
  {scope: "email, offline_access, publish_stream",
  	client_options: {ssl: {ca_path: "/etc/ssl/certs"}}}
  # configuring google
  provider :google_oauth2, ENV["758114528235-0mo96viuvhnhsjh9p35p0vi0oipq6p19.apps.googleusercontent.com"],
   ENV["IpxEsz-L1mu8fm4UV07qSpcp"]
  OmniAuth.config.on_failure = Proc.new { |env|
  	OmniAuth::FailureEndpoint.new(env).redirect_to_failure  
  }
end

OmniAuth.config.logger = Rails.logger
# OmniAuth.config.logger = Logger.new(STDOUT)
# OmniAuth.logger.progname = "omniauth"
