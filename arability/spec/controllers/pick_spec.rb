# encoding: utf-8
require "spec_helper"
require "request_helpers"
include RequestHelpers
include Warden::Test::Helpers
# include Devise::TestHelpers

describe MySubscriptionController do
	 let(:submodel){
    submodel = SubscriptionModel.new
    # submodel.name_en="Free"
    # submodel.name_ar="مجانا"
    submodel.limit=50
    submodel.limit_search=50
    #submodel.limit_add=50
    submodel.limit_follow=50
    submodel.limit_project=1
    submodel.save
    submodel
	}

	it "should make devloper choose his subscription model" do
		 developer = create_logged_in_developer()
         login_gamer(developer.gamer)
		 get :pick, :my_subscription => submodel.id 
		 model = gamer.developer.MySubscription.id
		 expect(model).to eq (true)
	end
end