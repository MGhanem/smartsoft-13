Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter, "y3D1eGgnppUGjKNP6C47GQ", "37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I"

  provider :facebook, "155521981280754", "a4d4684f0554e3637085e72eaa132890",
    {scope: "email, offline_access, publish_stream",
  	client_options: {ssl: {ca_path: "/etc/ssl/certs"}}}

  provider :google_oauth2, ENV["GOOGLE_ID"], ENV["GOOGLE_SECRET"],
           {
             scope: "userinfo.email,userinfo.profile,plus.me,http://gdata.youtube.com",
             approval_prompt: "auto"
           }

  OmniAuth.config.on_failure = Proc.new { |env|
    OmniAuth::FailureEndpoint.new(env).redirect_to_failure  
  }
end

OmniAuth.config.logger = Rails.logger