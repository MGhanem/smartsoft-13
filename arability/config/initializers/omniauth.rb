Rails.application.config.middleware.use OmniAuth::Builder do  
	require 'openid/store/filesystem'
	provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'   
end