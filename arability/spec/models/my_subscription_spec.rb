#encoding: UTF-8
require 'spec_helper'

describe MySubscription do
  let(:developer){
		developer=Developer.new
    developer.verified = true
    developer.gamer_id= 1
    developer.save
    puts "dev : #{developer.to_json}"
    developer

  }

  let(:project){
    project = Project.new
    project.name = "banking"
    project.minAge = 19
    project.maxAge = 25
    project.owner_id = developer.id
    project.save
    project   
  }

  let(:submodel){
    submodel = SubscriptionModel.new
    submodel.limit=50
    submodel.limit_search=50
    submodel.limit_follow=50
    submodel.limit_project=1
    submodel.save
    submodel
  }

  let(:my_sub){
    MySubscription.choose(developer.id, submodel.id)
    puts "dev_id : #{developer.id}"
    my_sub = MySubscription.where(:developer_id => developer.id).first
    my_sub
  }

  it "developer can choose subscription model" do
    result = MySubscription.choose(developer.id, submodel.id)
    expect(result).to eq(true)
  end
  it "follow permission is given" do 
    result = my_sub.get_permission_follow
    expect(result).to eq(true)
  end

  it "check if the developer can add more projects" do
    puts "#{my_sub.to_json}"
    result = my_sub.get_projects_limit
    expect(result).to eq(true)
  end
   it "add permission is given" do 
    result = my_sub.max_add_word(project.id)
    expect(result).to eq(true)
  end
   it "search permission is given" do 
    keyword = Keyword.create(name: "click", approved: true)
    result = my_sub.get_max_words(keyword.id)
    expect(result).to eq(true)
  end
end