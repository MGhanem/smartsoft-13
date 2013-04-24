#encoding: UTF-8
class AdminController < ApplicationController
  protect_from_forgery
  require 'csv'

  layout 'admin'

  include AdminHelper

  before_filter :authenticate_gamer!
  before_filter :authenticate_admin!

  def index
    render "dashboard"
  end

  def list_trophies
    @trophies_list = Trophy.all
    render "list-trophies"
  end

  def list_prizes
    @prizes_list = Prize.all
    render "list-prizes"
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
      @fargs = {keyword: params}
      success, @keyword = Keyword.add_keyword_to_database(name, true, is_english)
      if success
        flash[:success] = "لقد تم ادخال كلمة #{@keyword.name} بنجاح"
        flash[:successtype] = "addword"
        flash.keep
        redirect_to "/admin/add/word"
      else
        flash[:error] = @keyword.errors.messages
        flash[:errortype] = "addword"
        flash.keep
        redirect_to "/admin/add/word", fargs: @fargs
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
      @fargs = {addtrophy: params}
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
        redirect_to "/admin/list/trophies"
      else
        render "add-trophy"
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
      @fargs = {addprize: params}
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
        redirect_to "/admin/list/prizes"
      else
        render "add-prize"
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
    redirect_to "/admin/list/trophies"
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
    redirect_to "/admin/list/prizes"
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
      array_of_arrays, @message = parseCSV(params[:csvfile])
      if @message == 0
        uploadCSV(array_of_arrays)
      end
      render "import-csv-file"
    else
      render "import-csv-file"
    end
  end

end
