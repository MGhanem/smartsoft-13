#encoding:utf-8
namespace :db do
  desc "Insert random data into the database"
  task populate: :environment do
    Keyword.delete_all
    success, click=Keyword.add_keyword_to_database("click", true, categories:[Category.find(1),Category.find(2),Category.last])
    success, sign_in=Keyword.add_keyword_to_database("sign in", true, categories:[Category.first, Category.find(3)]
    success, sign_up=Keyword.add_keyword_to_database("sign up", true, categories:[Category.last])
    success, upload=Keyword.add_keyword_to_database("upload", true)
    success, download=Keyword.add_keyword_to_database("download", true)
    success, loading=Keyword.add_keyword_to_database("loading", true)
    success, username=Keyword.add_keyword_to_database("username", true)
    success, password=Keyword.add_keyword_to_database("password", true)
    share=Keyword.create(name: "share", approved: true, is_english: true)
    post=Keyword.create(name: "post", approved: true, is_english: true)
    poke=Keyword.create(name: "poke", approved: true, is_english: true)
    subscribe=Keyword.create(name: "subscribe", approved: true, is_english: true)
    broadcast=Keyword.create(name: "broadcast", approved: true, is_english: true)
    compile=Keyword.create(name: "compile", approved: true, is_english: true)
    like=Keyword.create(name: "like", approved: true, is_english: true)
    find=Keyword.create(name: "find", approved: true, is_english: true)
    search=Keyword.create(name: "search", approved: true, is_english: true)
    hide=Keyword.create(name: "hide", approved: true, is_english: true)
    onshor=Keyword.create(name: "أنشر", approved: true, is_english: false)
    doss=Keyword.create(name: "دوس", approved: true, is_english: false)
    yagebony=Keyword.create(name: "يعجبني", approved: true, is_english: false)
    arbya=Keyword.create(name: "عربية", approved: true, is_english: false)
    marhala=Keyword.create(name: "مرحلة", approved: true, is_english: false)
    edadat=Keyword.create(name: "إعدادات", approved: true, is_english: false)
    engazat=Keyword.create(name: "انجازات", approved: true, is_english: false)

    Category.delete_all
    test_category = Category.create(english_name: "test", arabic_name: "إختبار")
    Category.create(english_name: "Banking", arabic_name: "بنكية")
    Category.create(english_name: "Hospital", arabic_name: "مستشفى")
    Category.create(english_name: "Social Networking", arabic_name: "تواصل إجتماعي")

    test_category.keywords << click

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
    a=Synonym.create(name: "دوس", keyword_id: click.id, approved: true, is_formal: false)
    b=Synonym.create(name: "إضغط", keyword_id:  click.id, approved: true, is_formal: true)
    c=Synonym.create(name: "انقر", keyword_id:  click.id, approved: true, is_formal: true)
    d=Synonym.create(name: "تسجيل الدخول", keyword_id: sign_in.id, approved: true, is_formal: true)
    e=Synonym.create(name: "دخول", keyword_id: sign_in.id, approved: true, is_formal: true)
    f=Synonym.create(name: "إنشاء حساب", keyword_id: sign_up.id, approved: true, is_formal: true)
    g=Synonym.create(name: "رفع", keyword_id: upload.id, approved: true, is_formal: true)
    h=Synonym.create(name: "تحميل", keyword_id: download.id, approved: true, is_formal: true)
    i=Synonym.create(name: "تنزيل", keyword_id: download.id, approved: true, is_formal: true)
    j=Synonym.create(name: "أسم المستخدم", keyword_id: username.id, approved: true, is_formal: true)
    j=Synonym.create(name: "كلمة السر", keyword_id: password.id, approved: true, is_formal: true)

    j=Synonym.create(name: "تحميل", keyword_id: loading.id, approved: true, is_formal: true)
    k=Synonym.create(name: "استني", keyword_id: loading.id, approved: true, is_formal: false)
    l=Synonym.create(name: "شارك", keyword_id: share.id, approved: true, is_formal: true)
    m=Synonym.create(name: "اشترك", keyword_id: share.id, approved: true, is_formal: true)
    n=Synonym.create(name: "بووست", keyword_id: post.id, approved: true, is_formal: false)
    o=Synonym.create(name: "يلكز", keyword_id: poke.id, approved: true, is_formal: true)
    p=Synonym.create(name: "تابع", keyword_id: subscribe.id, approved: true, is_formal: true)
    q=Synonym.create(name: "اشترك", keyword_id: subscribe.id, approved: true, is_formal: true)
    w=Synonym.create(name: "انتشروا", keyword_id: broadcast.id, approved: true, is_formal: true)
    x=Synonym.create(name: "كومبيل", keyword_id: compile.id, approved: true, is_formal: false)
    y=Synonym.create(name: "يعجبني", keyword_id: like.id, approved: true, is_formal: true)
    z=Synonym.create(name: "احبه", keyword_id: like.id, approved: true, is_formal: true)

    a1=Synonym.create(name: "ابحث", keyword_id: find.id, approved: true, is_formal: true)
    a2=Synonym.create(name: "دور", keyword_id: find.id, approved: true, is_formal: false)
    a3=Synonym.create(name: "دورلي", keyword_id: search.id, approved: true, is_formal: false)
    a4=Synonym.create(name: "سيرش", keyword_id: search.id, approved: true, is_formal: false)
    a5=Synonym.create(name: "انشر", keyword_id: onshor.id, approved: true, is_formal: true)
    a6=Synonym.create(name: "اضغط", keyword_id: doss.id, approved: true, is_formal: true)
    a7=Synonym.create(name: "احب ده", keyword_id: yagebony.id, approved: true, is_formal: false)
    a8=Synonym.create(name: "مركبة", keyword_id: arbya.id, approved: true, is_formal: true)
    a9=Synonym.create(name: "سيتنجس", keyword_id: edadat.id, approved: true, is_formal: false)
    a9=Synonym.create(name: "انجاز كتير", keyword_id: engazat.id, approved: true, is_formal: false)
    b1=Synonym.create(name: "يحمل", keyword_id: loading.id, approved: true, is_formal: true)
    b2=Synonym.create(name: "لودينج", keyword_id: loading.id, approved: true, is_formal: false)
    b3=Synonym.create(name: "شاريكوا", keyword_id: share.id, approved: true, is_formal: true)
    b4=Synonym.create(name: "دوررليا", keyword_id: find.id, approved: true, is_formal: false)
    b5=Synonym.create(name: "ابحثلي", keyword_id: search.id, approved: true, is_formal: true)
    b5=Synonym.create(name: "سيرشلي", keyword_id: search.id, approved: true, is_formal: false)

    Gamer.delete_all
    def self.add_gamer(first, last, gender, country, age, education)
      g = Gamer.new
      g.username = first+"_"+last
      g.gender = gender
      g.email = first + "@"+last+".com"
      g.password = first+"_"+last
      g.date_of_birth = age.years.ago
      g.country = country
      g.education_level = education
      g.confirmed_at = Time.now
      g.save
      g
    end

    def self.make_admin(user)
        user.admin = true
        user.save
    end

    noha=add_gamer("noha", "mohamed", "female", "Lebanon", 20, "School")
    mohamed=add_gamer("mohamed", "ashraf", "male", "Egypt", 40, "University")
    smart=add_gamer("developer", "smartsoft", "male", "Egypt", 30, "University")
    timo=add_gamer("timo", "fattouh", "male", "Egypt", 30, "Graduate")
    kholoud=add_gamer("khloud", "khalid", "female", "Jordan", 10, "School")
    hassan=add_gamer("mosatafa", "hassan", "male", "Jordan", 30, "Graduate")
    amr=add_gamer("amr", "raoof", "male", "Iraq", 30, "Graduate")
    karim=add_gamer("karim", "gmail", "male", "Egypt", 77, "Graduate")
    make_admin(karim)

    Report.delete_all
    success, report1=Report.create_report(smart, upload)
    success, report2=Report.create_report(karim, a)
    success, report3=Report.create_report(timo, n)

    Developer.delete_all
    timo_dev=Developer.create(gamer_id: timo.id)
    timo_dev=Developer.create(gamer_id: smart.id)
    noha_dev=Developer.create(gamer_id: noha.id)
    hassan_dev=Developer.create(gamer_id: hassan.id)

    Vote.delete_all
    Vote.record_vote(noha.id, a.id)
    Vote.record_vote(noha.id, d.id)
    Vote.record_vote(mohamed.id, a.id)
    Vote.record_vote(mohamed.id, d.id)
    Vote.record_vote(mohamed.id, h.id)
    Vote.record_vote(timo.id, b.id)
    Vote.record_vote(timo.id, h.id)
    Vote.record_vote(timo.id, d.id)
    Vote.record_vote(amr.id, c.id)
    Vote.record_vote(amr.id, h.id)
    Vote.record_vote(amr.id, f.id)

    hassan_dev.keywords << click
    hassan_dev.keywords << sign_in

    SubscriptionModel.delete_all

    free=SubscriptionModel.create(name_en: "Free", name_ar: "مجاني", limit_search: 20, limit_follow: 20, limit: 20, limit_project: 20, limit: 500)
    premium=SubscriptionModel.create(name_en: "Premium", name_ar: "ممتاز", limit_search: 200, limit_follow: 200, limit: 20, limit_project: 100, limit: 2000)
    deluxe=SubscriptionModel.create(name_en: "Deluxe", name_ar: "فاخر", limit_search: 300, limit_follow: 300, limit: 20, limit_project: 300, limit: 5000)

    MySubscription.choose(timo_dev.id, SubscriptionModel.first.id)
    project = Project.new
    project.name = "Read"
    project.minAge = "19"
    project.maxAge = "50"
    project.description = "This project is awesome"
    project.owner_id = timo_dev.id
    project.save

    PreferedSynonym.create(project_id: project.id, keyword_id: click.id, synonym_id: a.id)
    PreferedSynonym.create(project_id: project.id, keyword_id: sign_in.id, synonym_id: d.id)

    project1 = Project.new
    project1.name = "HSBC"
    project1.minAge = "30"
    project.maxAge = "40"
    project1.description = "This project includes information about all the banks in egypt"
    project1.owner_id = timo_dev.id
    project1.save

    PreferedSynonym.create(project_id: project1.id, keyword_id: click.id, synonym_id: b.id)
    PreferedSynonym.create(project_id: project1.id, keyword_id: sign_in.id, synonym_id: e.id)
    PreferedSynonym.create(project_id: project1.id, keyword_id: download.id, synonym_id: h.id)

    project2 = Project.new
    project2.name = "Fun Integrated"
    project2.minAge = "30"
    project2.maxAge = "60"
    project2.description = "Our website is all about games and entertainment for both children and adults..."
    project2.owner_id = noha_dev.id
    project2.save

    PreferedSynonym.create(project_id: project1.id, keyword_id: click.id, synonym_id: c.id)
    PreferedSynonym.create(project_id: project1.id, keyword_id: sign_in.id, synonym_id: e.id)
    PreferedSynonym.create(project_id: project1.id, keyword_id: download.id, synonym_id: i.id)

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
  end
end
