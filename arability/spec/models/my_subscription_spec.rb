require 'spec_helper'

describe MySubscription do
  let(:developer){
		developer=Developer.new
    # developer.first_name="Nourhan"
    # developer.last_name="Hassan"
    developer.verified = true
    developer.gamer_id= 1
    developer.save
    developer
	}

  let(:submodel){
    submodel = SubscriptionModel.new
    submodel.name="Free"
    submodel.limit=50
    submodel.limit_search=50
    #submodel.limit_add=50
    submodel.limit_follow=50
    submodel.limit_project=1
    submodel.save
    submodel
	}

  let(:my_sub){
    MySubscription.choose(developer.id, submodel.id)
    my_sub = MySubscription.where(:developer_id => developer.id).first
    my_sub
	}

	it "developer can choose subscription model" do
		result = MySubscription.choose(developer.id, submodel.id)
		expect(result).to eq(true)

	end
end