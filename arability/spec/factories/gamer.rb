FactoryGirl.define do 

  factory devise_scope :gamer do |g|
    g.username "trialGamer"
    g.country "Egypt"
    g.education_level "low"
    g.date_of_birth "Sun, 09 Apr 1995"
    g.gender "male"
    g.email "trialA@example.com"
    g.password "123456"
  end
end