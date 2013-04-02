class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  require 'csv'
  
  # author: 
  #   Mohamed Tamer 
  # description: 
  #   function shows all the projects of a certain developer
  # params: 
  #   none
  # returns:
  #   on success: returns an array of projects of the developer currently logged in.
  #   on failure: notifies the user that he can't see this page.
  def index
 	  developer = Developer.where(:gamer_id => current_gamer.id).first
  	if developer.present?
  		@projects = Project.where(:developer_id => developer.id)
  	else
  		flash[:notice] = "You are not authorized to view this page"
  	end
  end

# author:
#      Salma Farag
# description:
#     A method that calls method createproject that creates the project and redirects to the
#project page and prints an error if the data entered is invalid
# params:
#     none
# success:
#     Creates a new project and views it in the index page
# failure:
#     Gives status errors

  def create
    @project = Project.createproject(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to "/projects", notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

# author:
#      Salma Farag
# description:
#     A method that views the form that  instantiates an empty project object
# params:
#     none
# success:
#     An empty project will be instantiated
# failure:
#     none
  def new
    @project = Project.new

    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def choose_keywords
    @words_in_database_before = params[:a1]
    @synonyms_words_in_database_before = params[:a2]
    @words_not_in_database_before = params[:a3]
    @synonyms_words_not_in_database_before = params[:a4]
  end

  def upload
    arr_of_arrs, message = parseCSV(params[:csvfile])
    if message != 0
      redirect_to action: "import_csv", message: message
    end
    words_in_database_before = Array.new
    synonyms_words_in_database_before = Array.new
    words_not_in_database_before = Array.new
    synonyms_words_not_in_database_before = Array.new
    arr_of_arrs.each do |row|
      if Keyword.keyword_exists?(row[0])
        keywrd = Keyword.find(row[0])
        for i in 1..row.size
          Synonym.recordsynonym(row[i],keywrd.id)
        end
        for i in 1..row.size
          synonm = Synonym.find(row[i], keywrd.id)
          if synonm != nil
            words_in_database_before.push(keywrd)
            synonyms_words_in_database_before.push(synonm)
            break
          end
        end
      else
        @isSaved, keywrd = Keyword.add_keyword_to_database(row[0])
        if @isSaved
          for i in 1..row.size
            Synonym.recordsynonym(row[i],keywrd.id)
          end
          for i in 1..row.size
            synonm = Synonym.find(row[i], keywrd.id)
            if synonm != nil
              words_not_in_database_before.push(keywrd)
              synonyms_words_not_in_database_before.push(synonm)
              break
            end
          end
        end
      end
    end
    redirect_to action: "choose_keywords", a1:words_in_database_before ,a2:synonyms_words_in_database_before ,a3:words_not_in_database_before ,a4:synonyms_words_not_in_database_before 
  end

  def import_csv
    @message = params[:message]
    if @message == 0
      redirect_to action: "choose_keywords"
    end
  end
end