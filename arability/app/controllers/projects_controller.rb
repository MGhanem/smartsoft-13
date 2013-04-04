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
    @projects = Project.all
 	  # developer = Developer.where(:gamer_id => current_gamer.id).first
  	# if developer.present?
  	# 	@projects = Project.where(:developer_id => developer.id)
  	# else
  	# 	flash[:notice] = "You are not authorized to view this page"
  	# end
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

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def choose_keywords
    id_words_in_database_before = params[:a1]
    id_synonyms_words_in_database_before = params[:a2]
    id_words_not_in_database_before = params[:a3]
    id_synonyms_words_not_in_database_before = params[:a4]
    @words_in_database_before = Array.new
    @words_not_in_database_before = Array.new
    id_words_in_database_before.each do |id_word|
      @words_in_database_before.push(Keyword.find(id_word))
    end
    id_words_not_in_database_before.each do |id_word|
      @words_not_in_database_before.push(Keyword.find(id_word))
    end

  end

  def add_from_csv_keywords

  end

  def upload
    arr_of_arrs, message = parseCSV(params[:csvfile])
    if message != 0
      redirect_to action: "import_csv", id: params[:project_id], message: message
    else
      id_words_in_database_before = Array.new
      id_synonyms_words_in_database_before = Array.new
      id_words_not_in_database_before = Array.new
      id_synonyms_words_not_in_database_before = Array.new
      arr_of_arrs.each do |row|
        keywrd = Keyword.find_by_name(row[0])
        if keywrd != nil
          for i in 1..row.size
            Synonym.record_synonym(row[i],keywrd.id)
          end
          for i in 1..row.size
            synonm = Synonym.find(row[i], keywrd.id)
            if synonm != nil
              id_words_in_database_before.push(keywrd.id)
              id_synonyms_words_in_database_before.push(synonm.id)
              break
            end
          end
        else
          @isSaved, keywrd = Keyword.add_keyword_to_database(row[0])
          if @isSaved
            for i in 1..row.size
              Synonym.record_synonym(row[i],keywrd.id)
            end
            for i in 1..row.size
              synonm = Synonym.find(row[i], keywrd.id)
              if synonm != nil
                id_words_not_in_database_before.push(keywrd.id)
                id_synonyms_words_not_in_database_before.push(synonm.id)
                break
              end
            end
          end
        end
      end
      redirect_to action: "choose_keywords",id: params[:project_id], a1:words_in_database_before ,a2:synonyms_words_in_database_before ,a3:words_not_in_database_before ,a4:synonyms_words_not_in_database_before 
    end
  end

  def import_csv
    current_project = Project.find(params[:id])
    @project_id = current_project.id
    @message = params[:message]
  end
end