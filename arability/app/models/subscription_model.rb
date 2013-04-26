class SubscriptionModel < ActiveRecord::Base
	has_many :my_subscriptions
  attr_accessible :name_en, :name_ar, :limit_search, :limit_follow, :limit_project ,:limit

  def name
    self.send("name_#{I18n.locale}")
  end
end
