class SocialController < ApplicationController

	def twitter
		@consumer=OAuth::Consumer.new "y3D1eGgnppUGjKNP6C47GQ", 
                              "37WC5Xa3HnawQe5A6YIMYSsTmUSzkKuky6gOpzD2I", 
                              {:site=>"https:local:3000"}
	end

end
