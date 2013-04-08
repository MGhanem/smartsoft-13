#encoding: UTF-8
class AdminController < ApplicationController

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
  #     a function that checks if the user is logged in and redirects him to /admin/index
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
    @fargs = params[:fargs]
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
  def addword
    name = params[:keyword][:name]
    is_english = params[:keyword][:is_english]
    success, @keyword = Keyword.add_keyword_to_database(name, false, is_english)
    if success
      flash[:success] = "لقد تم ادخال كلمة #{@keyword.name} بنجاح"
    else
      flash[:error] = @keyword.errors.messages
    end
    flash.keep
    redirect_to action: "index"
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
  def addtrophy
    params[:name] = params[:name].strip
    params[:level] = params[:level].strip
    params[:score] = params[:score].strip
    success, trophy = Trophy.add_trophy_to_database(params[:name], params[:level], params[:score], params[:image])
    if success
      flash[:success] = "تم ادخال مدالية #{trophy.name} بنجاح"
    else
      flash[:error] = trophy.errors.messages
      flash[:errortype] = "addtrophy"
    end
    flash.keep
    if success
      redirect_to action: "index"
    else
      redirect_to action: "index", anchor: "admin-add-trophy", fargs: {addtrophy: params}
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
  def addprize
    params[:name] = params[:name].strip
    params[:level] = params[:level].strip
    params[:score] = params[:score].strip
    success, prize = Prize.add_prize_to_database(params[:name], params[:level], params[:score], params[:image])
    if success
      flash[:success] = "تم ادخال جائزة #{prize.name} بنجاح"
    else
      flash[:error] = prize.errors.messages
      flash[:errortype] = "addprize"
    end
    flash.keep
    if success
      redirect_to action: "index"
    else
      redirect_to action: "index", anchor: "admin-add-prize", fargs: {addprize: params}
    end
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
  #   this function loads a view which allows the user to import a csv file and lists the rules for uploading
  #   in addition when a file is uploaded it gives the user feedback whether the file was successfully
  #   uploaded or not and gives the reason why not
  # params:
  #   GET message is feedback message
  # success:
  #   displays upload button, rules and feedback message (if applicable)
  # failure:
  #   no failure
  def import_csv
    @message = params[:message]
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
    redirect_to action: "index", anchor: "admin-import-csv-file", message: message
  end

end