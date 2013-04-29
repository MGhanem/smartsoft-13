#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery
  layout "admin"
  require "csv"
  include AdminHelper

  before_filter :authenticate_gamer!
  before_filter :authenticate_admin!

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
  #  none
  # Success: 
  #   refreshes the page and displays trophies
  # Failure: 
  #   none
  def list_trophies
    @trophies_list = Trophy.order(params[:order]).page(params[:page]).per(2)
  end

  # Author:
  #   Karim ElNaggar
  # Description:
  #   this action lists the prizes and links to remove trophies
  # Params
  #  none
  # Success: 
  #   refreshes the page and displays prizes
  # Failure: 
  #   none
  def list_prizes
    @prizes_list = Prize.order(params[:order]).page(params[:page]).per(2)
  end

  def list_gamers
    @list = Gamer.order(params[:order]).page(params[:page]).per(5)
  end

  def list_developers
    @list = Developer.order(params[:order]).page(params[:page]).per(5)
  end

  def list_admins
    @list = Gamer.where(:admin => true).order(params[:order])
                          .page(params[:page]).per(5)
  end

  def list_projects
    @list = Project.order(params[:order]).page(params[:page]).per(5)
  end

  def make_admin
    user = Gamer.find_by_id(params[:id])
    if user != nil
      user.admin = true
      user.save
      flash[:success] = "لقد تم اضافة #{user.username} كمشرف"
      flash.keep
      redirect_to "/admin/list/admins"
    else
      flash[:error] = "لم يتم العثورعلى الحساب الزى اختارته"
      redirect_to "/admin/list/gamers"
    end
  end

  def remove_admin
    user = Gamer.find_by_id(params[:id])
    if user.admin
      user.admin = false
      user.save
      flash[:success] = "لقد تم مسح #{user.username} من المشرفيين"
      flash.keep
      redirect_to "/admin/list/admins"
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

end