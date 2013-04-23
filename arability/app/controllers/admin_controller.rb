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
    render "dashboard"
  end

  def list_trophies
    @message = params[:message]
    @fargs = params[:fargs]
    @trophies_list = Trophy.all
    @prizes_list = Prize.all
    render "list-trophies"
  end

  def list_prizes
    @message = params[:message]
    @fargs = params[:fargs]
    @trophies_list = Trophy.all
    @prizes_list = Prize.all
    render "list-prizes"
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
    if request.post?
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
    else
      render "add-word"
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
    if request.post?
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
    else
      render "add-trophy"
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
    if request.post? 
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
    else
      render "add-prize"
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
    if request.post?
      array_of_arrays, message = parseCSV(params[:csvfile])
      if message == 0
        uploadCSV(array_of_arrays)
      end
      redirect_to action: "index", anchor: "admin-import-csv-file", 
                  message: message
    else
      render "import-csv-file"
    end
  end

end
