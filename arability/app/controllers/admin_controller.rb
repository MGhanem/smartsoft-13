#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery
  require 'csv'

  layout 'admin'

  include AdminHelper

  before_filter :require_login
  skip_before_filter :require_login, only: [:login, :logout]

  before_filter :check_login, only: [:login]

  # author:
  #     Karim ElNaggar
  # description:
  #     a filter that makes sure the user is logged in
  # params
  #     none
  # success: 
  #     if the user is not logged in redirect to login
  # failure: 
  #     none
  def require_login
    unless logged_in?
      flash[:error] = "يجب تسجيل الدخول"
      redirect_to action: "login"
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     a function that checks if the user is logged in and 
  #     redirects him to /admin/index
  # params
  #     none
  # success: 
  #     redirect to index if the user is logged in
  # failure: 
  #     none
  def check_login
    if logged_in?
      redirect_to action: "index"
    end
  end

  def index
    @message = params[:message]
    @fargs = params[:fargs]
    @trophies_list = Trophy.all
    @prizes_list = Prize.all
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     login action for admin
  # params
  #     username: the username for the admin
  #     password: the password for the admin
  # success: 
  #     redirects to admin/index
  # failure: 
  #     refreshes the page with error displayed
  def login
    if request.post?
      if params[:username] == "admin" && params[:password] == "admin"
        create_session
        redirect_to action: "index"
      else
        flash[:error] = "اسم المستخدم او كلمة السر غير صحيحة"
        @username = params[:username]
      end
    end
  end
  
  # author:
  #     Karim ElNaggar
  # description:
  #     wordadd action for keywords by admin
  # params
  #     name: the name of the new keyword
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def add_word
    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]
    success, @keyword = Keyword.add_keyword_to_database(name, true, is_english)
    if success
      flash[:success] = "لقد تم ادخال كلمة #{@keyword.name} بنجاح"
      flash[:successtype] = "addword"
      flash.keep
      redirect_to action: "index", anchor: "admin-add-word"
    else
      flash[:error] = @keyword.errors.messages
      flash[:errortype] = "addword"
      flash.keep
      redirect_to action: "index", anchor: "admin-add-word", fargs: params
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     this action takes a trophy as input and creates one and stores it in
  #     the database and redirects the user to index
  # params
  #     name: name of the trophy
  #     level: the level required to earn the trophy
  #     score: the score required to earn the trophy
  #     image: the photo thumbnail which would be displayed
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def add_trophy
    params[:name] = params[:name].strip
    params[:level] = params[:level].strip
    params[:score] = params[:score].strip
    success, trophy = Trophy.add_trophy_to_database(params[:name],
                 params[:level], params[:score], params[:image])
    if success
      flash[:success] = "تم ادخال الانجاز #{trophy.name} بنجاح"
      flash[:successtype] = "addtrophy"
    else
      flash[:error] = trophy.errors.messages
      flash[:errortype] = "addtrophy"
    end
    flash.keep
    if success
      redirect_to action: "index", anchor: "admin-list-trophies"
    else
      redirect_to action: "index", anchor: "admin-add-trophy", 
                  fargs: {addtrophy: params}
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     this action takes a prize as input and creates one and stores it in
  #     the database and redirects the user to index
  # params
  #     name: name of the prize
  #     level: the level required to earn the prize
  #     score: the score required to earn the prize
  #     image: the photo thumbnail which would be displayed
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def add_prize
    params[:name] = params[:name].strip
    params[:level] = params[:level].strip
    params[:score] = params[:score].strip
    success, prize = Prize.add_prize_to_database(params[:name],
               params[:level], params[:score], params[:image])
    if success
      flash[:success] = "تم ادخال جائزة #{prize.name} بنجاح"
      flash[:successtype] = "addprize"
    else
      flash[:error] = prize.errors.messages
      flash[:errortype] = "addprize"
    end
    flash.keep
    if success
      redirect_to action: "index", anchor: "admin-list-prizes"
    else
      redirect_to action: "index", anchor: "admin-add-prize", 
                  fargs: {addprize: params}
    end
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     delete a trophy selected by id
  # params
  #     id the id of the trophy
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def delete_trophy
    params[:id] = params[:id].strip
    status_trophy = Trophy.find_by_id(params[:id])
    if status_trophy.present?
      name = status_trophy.name
      status_trophy.delete
      flash[:success] = "تم مسح مدالية #{name} بنجاح"
      flash[:successtype] = "deletetrophy"
    else
      flash[:error] = "Trophy number #{params[:id]} is not found"
    end
    flash.keep
    redirect_to action: "index", anchor: "admin-list-trophies"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     delete a prize selected by id
  # params
  #     id the id of the prize
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def delete_prize
    params[:id] = params[:id].strip
    status_prize = Prize.find_by_id(params[:id])
    if status_prize.present?
      name = status_prize.name
      status_prize.delete
      flash[:success] = "تم مسح جائزة #{name} بنجاح"
      flash[:successtype] = "deleteprize"
    else
      flash[:error] = "Prize number #{params[:id]} is not found"
    end
    flash.keep
    redirect_to action: "index", anchor: "admin-list-prizes"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     admin logout action
  # params
  #     none
  # success: 
  #     redirects the user to /admin/login page
  # failure: 
  #     none
  def logout
    destroy_session
    redirect_to action: "login"
  end

  # author:
  #   Amr Abdelraouf
  # description:
  #   method calls parseCSV to return an array of arrays
  #   if the message is zero (file is valid and ready for insertion)
  #   uploadCSV is called and the words are inserted
  # params:
  #   POST csvfile
  # success:
  #   redirected to import_csv and status message is displayed
  # failure:
  #   none
  def upload
    array_of_arrays, message = parseCSV(params[:csvfile])
    if message == 0
      uploadCSV(array_of_arrays)
    end
    redirect_to action: "index", anchor: "admin-import-csv-file", 
                message: message
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could add a new category by giving the new category an
  #   arabic and english name of the category
  # Parameters:
  #   english_name: the category's english name
  #   arabic_name: the category's arabic name
  # Success:
  #   Category is added to database, and a flash is viewed indicating succes of
  #   add
  # Failure: 
  #   Category is not saved due to any error in input data, and a flash is
  #   viewed indicating the error
  def add_category
    if request.post?
      english_name = params[:english_name]
      arabic_name = params[:arabic_name]
      success, @category = Category.add_category_to_database_if_not_exists(english_name, arabic_name)
      if success
        flash[:success] = "لقد تم ادخال فئة #{@category.english_name}
          /#{@category.arabic_name} بنجاح"
        flash.keep
        redirect_to action: 'add_category'
      else
        flash[:error] = @category.errors.messages
        flash.keep
        redirect_to action: 'add_category'
      end
    else
      render 'admin/add_category'
    end
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could view all categories in database
  # Parameters:
  #   None
  # Success:
  #   All categories in database are viewed
  # Failure: 
  #   No categories are in database, so nothing is viewed
  def all_category
    @categories = Category.all
  end

  # Author:
  #   Omar Hossam
  # Description:
  #   As an admin, I could delete any category from database by choosing it from
  #   the view table and clicking the trash icon
  # Parameters:
  #   category_id: id of category to be deleted
  # Success:
  #   Category is deleted from database and categories' view appears without the
  #   deleted category, and a flash appears indicating the success of deletion
  # Failure: 
  #   None
  def delete_category
    category_id = params[:category_id]
    category = Category.find(category_id)
    category.delete
    flash[:success] = "لقد تم مسح الفئة بنجاح"
    flash.keep
    redirect_to action: 'all_category'
  end

end
