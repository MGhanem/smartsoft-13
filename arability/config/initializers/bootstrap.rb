#encoding:utf-8
Keyword.delete_all
success, click=Keyword.add_keyword_to_database("click", true)
success, sign_in=Keyword.add_keyword_to_database("sign in", true)
success, sign_up=Keyword.add_keyword_to_database("sign up", true)
success, upload=Keyword.add_keyword_to_database("upload", true)
success, download=Keyword.add_keyword_to_database("download", true)
success, loading=Keyword.add_keyword_to_database("loading", true)

word = Keyword.new
word.name = "play"
word.is_english = true
word.save

word2 = Keyword.new
word2.name = "run"
word2.is_english = true
word2.save

word3 = Keyword.new
word3.name = "fly"
word3.is_english = true
word3.save

Synonym.delete_all
a=Synonym.create(name: "دوس", keyword_id: click.id, approved: true)
b=Synonym.create(name: "إضغط", keyword_id:  click.id, approved: true)
c=Synonym.create(name: "انقر", keyword_id:  click.id, approved: true)
d=Synonym.create(name: "تسجيل الدخول", keyword_id: sign_in.id, approved: true)
e=Synonym.create(name: "دخول", keyword_id: sign_in.id, approved: true)
f=Synonym.create(name: "إنشاء حساب", keyword_id: sign_up.id, approved: true)
g=Synonym.create(name: "رفع", keyword_id: upload.id, approved: true)
h=Synonym.create(name: "تحميل", keyword_id: download.id, approved: true)
i=Synonym.create(name: "تنزيل", keyword_id: download.id, approved: true)

Gamer.delete_all
def self.add_gamer(first, last, country, age, education)
  g = Gamer.new
  g.username = first+"_"+last
  g.email = first + "@"+last+".com"
  g.password = first+"_"+last
  g.date_of_birth = age.years.ago
  g.country = country
  g.education_level = education
  g.save
  g
end

noha=add_gamer("noha", "mohamed", "Lebanon", 20, "high")
mohamed=add_gamer("mohamed", "ashraf", "Egypt", 40, "medium")
timo=add_gamer("timo", "fattouh", "Egypt", 30, "high")
kholoud=add_gamer("khloud", "khalid", "Jordan", 10, "high")
hassan=add_gamer("mosatafa", "hassan", "Jordan", 30, "high")

Developer.delete_all
timo_dev=Developer.create(first_name: "Timo", last_name: "Fattouh", gamer_id: timo.id)
noha_dev=Developer.create(first_name: "Noha", last_name: "Mohamed", gamer_id: noha.id)
hassan_dev=Developer.create(first_name: "Mostafa", last_name: "Hassan", gamer_id: hassan.id)

Vote.delete_all
Vote.record_vote(noha.id, a.id)
Vote.record_vote(noha.id, d.id)
Vote.record_vote(mohamed.id, a.id)
Vote.record_vote(mohamed.id, d.id)
Vote.record_vote(mohamed.id, h.id)
Vote.record_vote(timo.id, b.id)

hassan_dev.keywords << click
hassan_dev.keywords << sign_in

SubscriptionModel.delete_all
free=SubscriptionModel.create(name: "Free")
premium=SubscriptionModel.create(title: "Premium")
deluxe=SubscriptionModel.create(title: "Deluxe")

MySubscription.delete_all
MySubscription.create(developer_id: timo_dev.id, subscribtion_model_id: free.id)
MySubscription.create(developer_id: noha_dev.id, subscribtion_model_id: free.id)
MySubscription.create(developer_id: hassan_dev.id, subscribtion_model_id: free.id)
