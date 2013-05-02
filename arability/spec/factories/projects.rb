require 'spec_helper'

FactoryGirl.define do
  factory :project do |f|
  f.name "Project1"
  f.formal true
  f.minAge "18"
  f.maxAge "50"
  f.owner_id "1"
  f.category_id "13"
  f.description "Hahahahaha"
end
end

FactoryGirl.define do |f|
  factory :invalid_project do |f|
  f.name nil
end
end