#encoding: UTF-8
class AdminController < ApplicationController
  layout "admin"
  require "csv"
  include AdminHelper

  before_filter :authenticate_gamer!
  before_filter :authenticate_admin!

  skip_before_filter :set_locale

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action display the admin dashboard
  # Params
  #   none
  # Success: 
  #   refreshes the page and displays the dashboard
  # Failure: 
  #   none
  def index
    render "dashboard"
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the trophies and links to remove trophies
  # Params
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   refreshes the page and displays trophies
  # Failure: 
  #   none
  def list_trophies
    @trophies_list = Trophy.order(params[:order]).page(params[:page]).per(12)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the prizes and links to remove trophies
  # Params
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   refreshes the page and displays prizes
  # Failure: 
  #   none
  def list_prizes
    @prizes_list = Prize.order(params[:order]).page(params[:page]).per(12)
  end

  # Author:
  #   karim elnaggar
  # Description:
  #   returns json of gamer emails matching autocompletion
  # params:
  #   search: a string representing the email
  # success:
  #   returns a json list of emails similar to what's currently typed
  #   in the search textbox
  # failure:
  #   returns an empty list if what's currently typed in the search textbox
  #   had no matches
  def gamer_email_autocomplete
    search_email = params[:search]
    similar_emails =
      Gamer.get_similar_emails(search_email)
    similar_emails.map! { |email| email.email }
    render json: similar_emails
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the gamers and links to make them admins
  # Params
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   refreshes the page and displays gamers
  # Failure: 
  #   none
  def list_gamers
    @list = Gamer.order(params[:order]).page(params[:page]).per(20)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the developers
  # Params
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   refreshes the page and displays developers
  # Failure: 
  #   none
  def list_developers
    @list = Developer.order(params[:order]).page(params[:page]).per(20)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the admins and links to remove them
  # Params
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   refreshes the page and displays admins
  # Failure: 
  #   none
  def list_admins
    @list = Gamer.where(admin: true).order(params[:order])
                          .page(params[:page]).per(20)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the projects of a user
  # Params
  #   developer_id: the id of the developer
  #   order: the order of the list
  #   page: the current page of the pagination
  # Success: 
  #   views a table with the projects of that user
  # Failure: 
  #   the user is not a valid developer so an error is displayed
  def list_developer_projects
    @developer = Developer.find_by_id(params[:id])
    @list = @developer.projects.order(params[:order]).page(params[:page]).per(20)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action makes a gamer an admin
  # Params
  #   id: the id of the gamer to be admin
  # Success: 
  #   redirects the new admin to list admins view and display success message
  # Failure: 
  #   the user is not a valid user so an error is displayed
  def make_admin
    if request.post?
      user = Gamer.find_by_email(params[:email])
      if user != nil
        if user.admin?
          flash[:success] = "#{user.username} مشرف بالفعل"
        else
          user.make_admin
          UserMailer.generic_email(params[:email],
            "Arability's newest admin xD",
            "Dear #{user.username}, \nWe would like to inform you that you are now \n An admin of Arability").deliver
          flash[:success] = "لقد تم اضافة #{user.username} كمشرف"
        end
        flash.keep
        redirect_to "/admin/list/admins"
      else
        flash[:error] = "لم يتم العثورعلى الحساب الذي اختارته"
        redirect_to "/admin/make_admin"
      end
    end
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action removes an admin from the admins
  # Params
  #   id: the id of the admin to be removed from admins
  # Success: 
  #   removes the admin and redirects to list admins view
  # Failure: 
  #   the user is not a valid admin so an error is displayed
  def remove_admin
    user = Gamer.find_by_id(params[:id])
    if user.admin
      if user.id == current_gamer.id
        flash[:error] = "لا يمكن مسح نفسك"
        redirect_to "/admin/list/admins"
      else
        user.remove_admin
        UserMailer.generic_email(user.email,
          "Removal from Arability admins",
          "Dear #{user.username}, \nWe would like to inform you that you are removed \n from the list of admins of Arability").deliver
        flash[:success] = "لقد تم اضافة #{user.username} كمشرف"
        flash[:success] = "لقد تم مسح #{user.username} من المشرفيين"
        flash.keep
        redirect_to "/admin/list/admins"
      end
    else
      flash[:error] = "لم يتم العثورعلى الحساب الزى اختارته"
      redirect_to "/admin/list/admins"
    end
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   wordadd action for keywords by admin
  # Params
  #   name: the name of the new keyword
  # Success: 
  #   refreshes the page and displays notification
  # Failure: 
  #   refreshes the page with error displayed
  def add_word
    if request.post?
      @name = params[:keyword][:name]
      success, @keyword = Keyword.add_keyword_to_database(@name, true)
      if success
        flash[:success] = "لقد تم ادخال كلمة #{@keyword.name} بنجاح"
        redirect_to "/admin/add/word"
      else
        flash[:error] = @keyword.errors.messages  
      end
    end
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action takes a trophy as input and creates one and stores it in
  #   the database and redirects the user to index
  # Params
  #   name: name of the trophy
  #   level: the level required to earn the trophy
  #   score: the score required to earn the trophy
  #   image: the photo thumbnail which would be displayed
  # Success:
  #   refreshes the page and displays notification
  # Failure:
  #   refreshes the page with error displayed
  def add_trophy
    if request.post?
      @name = params[:name]
      @level = params[:level]
      @score = params[:score]
      success, trophy = Trophy.add_trophy_to_database(@name,
                   @level, @score, params[:image])
      if success
        flash[:success] = "تم ادخال الانجاز #{trophy.name} بنجاح"
        redirect_to "/admin/list/trophies"
      else
        flash[:error] = trophy.errors.messages
      end
    end
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action takes a prize as input and creates one and stores it in
  #   the database and redirects the user to index
  # Params
  #   name: name of the prize
  #   level: the level required to earn the prize
  #   score: the score required to earn the prize
  #   image: the photo thumbnail which would be displayed
  # Success: 
  #   refreshes the page and displays notification
  # Failure: 
  #   refreshes the page with error displayed
  def add_prize
    if request.post?
      @name = params[:name]
      @level = params[:level]
      @score = params[:score]
      success, prize = Prize.add_prize_to_database(@name,
                 @level, @score, params[:image])
      if success
        flash[:success] = "تم ادخال جائزة #{prize.name} بنجاح"
        redirect_to "/admin/list/prizes"
      else
        flash[:error] = prize.errors.messages
      end
    end
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   delete a trophy selected by id
  # Params
  #   id the id of the trophy
  # Success: 
  #   refreshes the page and displays notification
  # Failure: 
  #   refreshes the page with error displayed
  def delete_trophy
    params[:id] = params[:id].strip
    status_trophy = Trophy.find_by_id(params[:id])
    if status_trophy.present?
      name = status_trophy.name
      status_trophy.delete
      flash[:success] = "تم مسح مدالية #{name} بنجاح"
    else
      flash[:error] = "Trophy number #{params[:id]} is not found"
    end
    flash.keep
    redirect_to "/admin/list/trophies"
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   delete a prize selected by id
  # Params
  #   id the id of the prize
  # Success: 
  #   refreshes the page and displays notification
  # Failure: 
  #   refreshes the page with error displayed
  def delete_prize
    params[:id] = params[:id].strip
    status_prize = Prize.find_by_id(params[:id])
    if status_prize.present?
      name = status_prize.name
      status_prize.delete
      flash[:success] = "تم مسح جائزة #{name} بنجاح"
    else
      flash[:error] = "Prize number #{params[:id]} is not found"
    end
    flash.keep
    redirect_to "/admin/list/prizes"
  end

  # Author:
  #   Amr Abdelraouf
  # Description:
  #   method calls parseCSV to return an array of arrays
  #   if the message is zero (file is valid and ready for insertion)
  #   uploadCSV is called and the words are inserted
  # Params:
  #   POST csvfile
  # Success:
  #   redirected to import_csv and status message is displayed
  # Failure:
  #   none
  def upload
    if request.post?
      array_of_arrays, @message = parseCSV(params[:csvfile])
      if @message == 0
        uploadCSV(array_of_arrays)
      end
    end
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could add a new category by giving the new category an
  #   arabic and english name of the category.
  # Parameters:
  #   english_name: the category's english name
  #   arabic_name: the category's arabic name.
  # Success:
  #   Category is added to database, and a flash is viewed indicating succes of
  #   add.
  # Failure: 
  #   Category is not saved due to any error in input data, and a flash is
  #   viewed indicating the error.
  def add_category
    if request.post?
      english_name = params[:english_name]
      arabic_name = params[:arabic_name]
      @arabic_name = arabic_name
      @english_name = english_name
      @success, @category = Category.add_category(english_name, arabic_name)
      if @success
        flash[:success] = "لقد تم ادخال فئة #{@category.english_name}
          /#{@category.arabic_name} بنجاح"
        redirect_to "/admin/view_categories"
      else
        flash[:error] = @category.errors.messages
      end
    end
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I should be able to view all the subscription models in
  #   database.
  # Parameters:
  #   None.
  # Success:
  #   Subscription models appear on the view in a table with all attributes.
  # Failure: 
  #   Nothing appears as there is no Subscription models in database.
  def view_subscription_models
    @models = SubscriptionModel.all
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could view all categories in database.
  # Parameters:
  #   None.
  # Success:
  #   All categories in database are viewed.
  # Failure: 
  #   No categories are in database, so nothing is viewed.
  def view_categories
    @categories = Category.all
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could delete any subscription model from database by
  #   choosing it from the view table and clicking the trash icon.
  # Parameters:
  #   model_id: id of subscription model to be deleted.
  # Success:
  #   Subscription model is deleted from database and subscription models' view
  #   appears without the deleted subscription model, and a flash appears
  #   indicating the success of deletion.
  # Failure: 
  #   None.
  def delete_subscription_model
    model_id = params[:model_id]
    model = SubscriptionModel.find(model_id)
    model.delete
    flash[:success] = "لقد تم مسح نظام الإشتراك بنجاح"
    flash.keep
    redirect_to action: "view_subscription_models"
  end 

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I should be able to view all the attributes of the
  #   subscription model needed to be edited, and the data they have.
  # Parameters:
  #   errors: list of error messages of subscription model trying to edit.
  #   model_id: id of subscription model to be edited.
  # Success:
  #   error messages appear on top of page, and attributes of subscription model
  #   to be edited appear on page, with their original data.
  # Failure: 
  #   None.
  def edit_subscription_model
    @errors = params[:errors]
    model_id = params[:model_id].to_i
    @model = SubscriptionModel.find_by_id(model_id)
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I should be able to view all the attributes of the
  #   category needed to be edited, and the data they have.
  # Parameters:
  #   errors: list of error messages of category trying to edit.
  #   category_id: id of category to be edited.
  # Success:
  #   error messages appear on top of page, and attributes of category
  #   to be edited appear on page, with their original data.
  # Failure: 
  #   None.
  def edit_category
    @errors = params[:errors]
    category_id = params[:category_id].to_i
    @category = Category.find_by_id(category_id)
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could delete any category from database by choosing it from
  #   the view table and clicking the trash icon.
  # Parameters:
  #   category_id: id of category to be deleted.
  # Success:
  #   Category is deleted from database and categories' view appears without the
  #   deleted category, and a flash appears indicating the success of deletion.
  # Failure: 
  #   None.
  def delete_category
    category_id = params[:category_id]
    category = Category.find(category_id)
    category.delete
    flash[:success] = "لقد تم مسح الفئة بنجاح"
    flash.keep
    redirect_to action: "view_categories"
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I should be able edit data of a subscription model.
  # Parameters:
  #   model_id: id of subscription model to be edited.
  #   subscription_model[name_en]: new english name that should replace original
  #   english name.
  #   subscription_model[name_ar]: new arabic name that should replace original
  #   arabic name.
  #   subscription_model[limit_search]: new limit_search that should replace
  #   original limit_search.
  #   subscription_model[limit_follow]: new limit_follow that should replace
  #   original limit_follow.
  #   subscription_model[limit_project]: new limit_project that should replace
  #   original limit_project.
  #   subscription_model[limit]: new limit that should replace
  #   original limit.
  # Success:
  #   Subscription model attributes gets updated with new data and go back to
  #   the view of all subscription models in database.
  # Failure: 
  #   Some of the Subscription model's validation prevents the model to be
  #   edited, and the errors appear on the top of the page.
  def update_subscription_model
    @model = SubscriptionModel.find(params[:model_id])
    @model.name_ar = params[:subscription_model][:name_ar]
    @model.name_en = params[:subscription_model][:name_en]
    @model.limit_search = params[:subscription_model][:limit_search]
    @model.limit_follow = params[:subscription_model][:limit_follow]
    @model.limit_project = params[:subscription_model][:limit_project]
    @model.limit = params[:subscription_model][:limit]
    if @model.save
      flash[:success] = "لقد تم تعديل نظام الإشتراك بنجاح"
      flash.keep
      redirect_to action: "view_subscription_models"
    else
      redirect_to action: "edit_subscription_model",
        errors: @model.errors.messages, model_id: @model.id
    end
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I should be able edit data of a category.
  # Parameters:
  #   category_id: id of category to be edited.
  #   category[english_name]: new english name that should replace original
  #   english name.
  #   category[arabic_name]: new arabic name that should replace original
  #   arabic name.
  # Success:
  #   Category attributes gets updated with new data and go back to
  #   the view of all categories in database.
  # Failure: 
  #   Some of the category's validation prevents the model to be
  #   edited, and the errors appear on the top of the page.
  def update_category
    @category = Category.find(params[:category_id])
    @category.english_name = params[:category][:english_name]
    @category.arabic_name = params[:category][:arabic_name]
    if @category.save
      flash[:success] = "لقد تم تعديل الفئة بنجاح"
      flash.keep
      redirect_to action: "view_categories"
    else
      redirect_to action: "edit_category",
        errors: @category.errors.messages, category_id: @category.id
    end
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could view all reported keywords/synonyms in database.
  # Parameters:
  #   None.
  # Success:
  #   All reported keywords/synonyms in database are viewed, and if none, a 
  #   message is viewed stating that.
  # Failure: 
  #   None.
  def view_reports
    @reports = Report.all
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could ignore any report by pressing the icon-ok and the
  #   word reported won't be in reports any more and will keep approved.
  # Parameters:
  #   report_id: id of report to be ignored.
  # Success:
  #   Report is ignored and removed from reports' list, an email is sent to
  #   reporter and a flash appears indicating success of operation.
  # Failure: 
  #   None.
  def ignore_report
    report_id = params[:report_id]
    report = Report.find_by_id(report_id)
    UserMailer.generic_email(Gamer.find_by_id(report.gamer_id).email,
      "report feedback on arability.com",
      "Dear #{Gamer.find_by_id(report.gamer_id).username}, \nWe would like to thank you for your feedback. But our team finds nothing inappropiate in the word you reported and was kept on our website. \nThank you \nArability team").deliver
    report.delete
    @reportAll = Report.all
    flash[:success] = "تم التصرف في البلاغ و إبقاء الكلمة"
    flash.keep
    redirect_to action: "view_reports"
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could delete any report by pressing the icon-remove and the
  #   word reported won't be in reports any more and will be unapproved.
  # Parameters:
  #   report_id: id of report to be ignored.
  # Success:
  #   Report is removed from reports' list, word gets unapproved, an email is
  #   sent to reporter and a flash appears indicating success of operation.
  # Failure: 
  #   None.
  def unapprove_word
    report_id = params[:report_id]
    report = Report.find_by_id(report_id)
    if report.reported_word_type == "Synonym"
      Synonym.disapprove_synonym(report.reported_word_id)
    else
      Keyword.disapprove_keyword(report.reported_word_id)
    end
    UserMailer.generic_email(Gamer.find_by_id(report.gamer_id).email,
      "report feedback on arability.com",
      "Dear #{Gamer.find_by_id(report.gamer_id).username}, \nWe would like to thank you for your feedback. Your report has been considered, and we found out that this word is inappropiate and have been blocked from our website. \n \nThank you \n \nArability team").deliver
    report.delete
    @reportAll = Report.all
    flash[:success] = "تم التصرف في البلاغ و إخفاء الكلمة"
    flash.keep
    redirect_to action: "view_reports"
  end

end