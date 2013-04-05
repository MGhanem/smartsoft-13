class AdminController < ActionController::Base

  require 'csv'

  before_filter :require_login
  skip_before_filter :require_login, only: [:login]

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
      flash[:error] = "You must be logged in"
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

  # author:
  #     Karim ElNaggar
  # description:
  #     checks if the user is logged in
  # params
  #     none
  # success: 
  #     returns true if the user is logged in as admin
  # failure: 
  #     none
  def logged_in?
    current_user == "admin"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     current_user method
  # params
  #     none
  # success: 
  #     returns the session variable :who_is_this
  # failure: 
  #     none
  def current_user
    session[:who_is_this]
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     create session method
  # params
  #     none
  # success: 
  #     sets the session variable :who_is_this to "admin"
  # failure: 
  #     none
  def create_session
    session[:who_is_this] = "admin"
  end

  # author:
  #     Karim ElNaggar
  # description:
  #     destroy_session method
  # params
  #     none
  # success: 
  #     unsets the session variable :who_is_this
  # failure: 
  #     none
  def destroy_session
    session[:who_is_this] = nil
  end

  def index
    @trophies_list = Trophy.all
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
        flash[:error] = "Invalid username or password"
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
    success, @keyword = Keyword.add_keyword_to_database(name, true, is_english)
    if success
      flash[:success] = "Keyword #{@keyword.name} has been created"
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
  #     score: the level required to earn the trophy
  #     rank: the score required to earn the trophy
  #     photo: the photo thumbnail which would be displayed
  # success: 
  #     refreshes the page and displays notification
  # failure: 
  #     refreshes the page with error displayed
  def addtrophy
    success, trophy = Trophy.add_trophy_to_database(params[:name], params[:score], params[:rank], params[:photo])
    if success
      flash[:success] = "Trophy #{trophy.name} has been created"
    else
      flash[:error] = trophy.errors.messages
    end
    flash.keep
    redirect_to action: "index"
  end


  def deletetrophy
    Trophy.find_by_name(params[:name]).delete
    flash[:success] = "Trophy #{params[:name]} has been deleted"
    flash.keep
    redirect_to action: "index"
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
    redirect_to action: "import_csv", message: message
  end

end