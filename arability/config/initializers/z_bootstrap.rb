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
premium=SubscriptionModel.create(name: "Premium")
deluxe=SubscriptionModel.create(name: "Deluxe")

project = Project.new
project.name = "Read"
project.minAge = "19"
project.maxAge = "50"
project.description = "This project is awesome"
project.owner_id = timo_dev.id
project.save

project1 = Project.new
project1.name = "HSBC"
project1.minAge = "30"
project.maxAge = "40"
project1.description = "This project includes information about all the banks in egypt"
project1.owner_id = timo_dev.id
project1.save

project2 = Project.new
project2.name = "Fun Integrated"
project2.minAge = "30"
project2.maxAge = "60"
project2.description = "Our website is all about games and entertainment for both children and adults..."
project2.owner_id = noha_dev.id
project2.save


Trophy.delete_all
t1= Trophy.new(name: "أول كلمة", level: 1, score: 1, image_file_name: "big_89eaf3e487fe47e4fc467c23735e6c5332280449.jpg", image_content_type: "image/jpeg", image_file_size: 628755, image_updated_at: "2013-04-11 18:21:23")
t1.id = 1
t1.save

t2 = Trophy.new(name: "تبشمت", level: 1, score: 1, image_file_name: "10Lf29161.png", image_content_type: "image/png", image_file_size: 54152, image_updated_at: "2013-04-11 18:45:49")
t2.id =2
t2.save

t3 = Trophy.new(name: "شتمتبش", level: 1, score: 1, image_file_name: "5L30ba5f.png", image_content_type: "image/png", image_file_size: 40637, image_updated_at: "2013-04-11 18:46:05")
t3.id = 3
t3.save

t4 = Trophy.new(name: "يتيتش", level: 1, score: 1, image_file_name: "images.jpg", image_content_type: "image/jpeg", image_file_size: 4312, image_updated_at: "2013-04-11 18:46:22")
t4.id=4
t4.save

t5 = Trophy.new(name: "ابسشام", level: 1, score: 1, image_file_name: "images_(1).jpg", image_content_type: "image/jpeg", image_file_size: 8423, image_updated_at: "2013-04-11 18:46:38")
t5.id=5
t5.save

Prize.delete_all
t1 = Prize.new(name: "أول كلمة", level: 1, score: 1, image_file_name: "big_89eaf3e487fe47e4fc467c23735e6c5332280449.jpg", image_content_type: "image/jpeg", image_file_size: 628755, image_updated_at: "2013-04-11 18:21:23")
t1.id = 1
t1.save

t2 = Prize.new(name: "تبشمت", level: 1, score: 1, image_file_name: "10Lf29161.png", image_content_type: "image/png", image_file_size: 54152, image_updated_at: "2013-04-11 18:45:49")
t2.id = 2
t2.save

t3 = Prize.new(name: "شتمتبش", level: 1, score: 1, image_file_name: "5L30ba5f.png", image_content_type: "image/png", image_file_size: 40637, image_updated_at: "2013-04-11 18:46:05")
t3.id = 3
t3.save

t4 = Prize.new(name: "يتيتش", level: 1, score: 1, image_file_name: "images.jpg", image_content_type: "image/jpeg", image_file_size: 4312, image_updated_at: "2013-04-11 18:46:22")
t4.id = 4
t4.save

t5 = Prize.new(name: "ابسشام", level: 1, score: 1, image_file_name: "images_(1).jpg", image_content_type: "image/jpeg", image_file_size: 8423, image_updated_at: "2013-04-11 18:46:38")
t5.id = 5
t5.save
