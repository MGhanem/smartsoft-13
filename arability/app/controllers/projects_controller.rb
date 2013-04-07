class ProjectsController < ApplicationController 
  # GET /projects
  # GET /projects.json
  require 'csv'
  def index
    if gamer_signed_in?
      @projects = Project.where(:owner_id => current_gamer.id)
    else
      flash[:error] = "You are not authorized to view this page"
      render 'pages/home'
    end
  end
 
  # def index
  #   if current_gamer != nil 
  #     developer = Developer.where(:gamer_id => current_gamer.id).first
  #     if developer != nil
  #       @my_projects = Project.where(:owner_id => developer.id)
  #       # @shared_projects = Project.joins(:shared_projects).where(:developer => developer.id)
  #      # @shared_projects = Project.find_by_sql("SELECT * FROM projects INNER JOIN shared_projects ON projects.id = shared_projects.project_id WHERE shared_projects.developer_id = #{developer.id}")
  #     else
  #       flash[:notice] = "Please sign up as a developer first"
  #       render 'developers/new'
  #     end
  #   else
  #     flash[:notice] = "Please sign in"
  #     render 'pages/home'
  #   end  
  # end

  # author:
  #      Salma Farag
  # description:
  #     After checking that the user is signed in, the method that calls method createproject
  #that creates the project and redirects to the project page and prints
  #an error if the data entered is invalid.
  # params:
  #     none
  # success:
  #     Creates a new project and views it in the index page
  # failure:
  #     Gives status errors

  def create
    if gamer_signed_in?
      @project = Project.createproject(params[:project],current_gamer.id)
      respond_to do |format|
        if @project.save
          format.html { redirect_to "/projects", notice: 'Project was successfully created.' }
          format.json { render json: @project, status: :created, location: @project }
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
     flash[:error] = "Please log in to view this page."
     render 'pages/home'
    end
  end

  # author:
  #      Salma Farag
  # description:
  #     A method that views the form that  instantiates an empty project object
  # after checking that the user is signed in.
  # params:
  #     none
  # success:
  #     An empty project will be instantiated
  # failure:
  #     none
  def new
    if gamer_signed_in?
      @project = Project.new
      respond_to do |format|
        format.html
        format.json { render json: @project }
      end
    else
      flash[:error] = "Please log in to view this page."
      render 'pages/home'
    end
  end

  # author:
  #      Salma Farag
  # description:
  #     A method that specifies an already existing project by its ID
  # params:
  #     none
  # success:
  #     A form that contains the existing data of the project will open from the views.
  # failure:
  #     none
  def edit
    if gamer_signed_in?
      @project = Project.find(params[:id])
    else
      flash[:error] = "You are not authorized to view this page"
    end
  end

  # author:
  #      Salma Farag
  # description:
  #     A method that checks if the fields of the form editting the project have been changed.
  #If yes, the new values will replace the old ones otherwise nothing will happen.
  # params:
  #     none
  # success:
  #     An existing project will be updated.
  # failure:
  #     The old values will be kept.
  def update
    if gamer_signed_in?
     @project = Project.find(params[:id])
     @project = Project.createcategories(@project, params([:project][:categories]))
     if @project.update_attributes(params[:project])
      redirect_to :action => "index"
      flash[:notice] = "Project has been successfully updated."
    else
      render :action => 'edit'
    end
  else
    flash[:error] = "You are not authorized to view this page"
  end
  end

  # author:
  #      Salma Farag
  # description:
  #     A method that finds a project by its ID to view it.
  # params:
  #     none
  # success:
  #     A project page will open.
  # failure:
  #     None.
  def show
    if gamer_signed_in?
      @project = Project.find(params[:id])
    else
      flash[:error] = "You are not authorized to view this page"
    end
  end
# author:
#      Khloud Khalid
# description:
#     method adds a keyword and a synonym to an existing project and if word already exists in the project updates
#     its synonym
# params:
#     project_id, word_id, synonym_id
# success:
#     keyword and synonym are added to project or synonym of word updated 
# failure:
#     object not valid (no project or word id), word already exists in project, keyword or synonym does not exist, 
#     developer trying to add word is not owner of the project nor is the project shared with him/her, not registered
#     developer, or keyword is not in the project.
  def add_word
    # if the word doesn't have synonyms redirect to follow word
    if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      # redirect_to project_path(@project_id)
      # return
      # @developer_id = Developer.find_by_gamer_id(current_gamer.id).id
      # @owner_project = Project.where(owner_id: @developer_id).all
      # # @owner_projects = Project.find_by_owner_id(Developer.find_by_gamer_id(current_gamer.id))
      # @owner_projects.each { |project| if project.id = @project_id
      #     @owned = true
      #   else
      #     @owned = false
      #   end }
      # if owned
        # check if project is shared with me too
        # check for free users, if the words exceeds 20 words
        @word_id = Keyword.find_by_name(params[:keyword]).id
        if Keyword.find_by_id(@word_id) != nil
          @synonym_id = params[:synonym_id]
          if PreferedSynonym.find_word_in_project(@project_id, @word_id)
            @edited_word = PreferedSynonym.find_by_keyword_id(@word_id) 
            @synonym_id = params[:synonym_id]
            if Synonym.find_by_id(@synonym_id) != nil
              @edited_word.synonym_id = @synonym_id
              if @edited_word.save
                flash[:notice] = "Synonym changed successfully."
                redirect_to project_path(@project_id), :flash => flash
                return
              else
                flash[:notice] = "Failed to update synonym"
                redirect_to project_path(@project_id), :flash => flash
                return
              end
            else
              flash[:notice] = "This synonym does not exist."
              redirect_to project_path(@project_id), :flash => flash
              return
            end
          else
            @added_word = PreferedSynonym.add_keyword_and_synonym_to_project(@synonym_id, @word_id, @project_id)
            if @added_word
              flash[:notice] = "You have successfully added the word to your project."
              redirect_to project_path(@project_id), :flash => flash
              return
            else
              flash[:notice] = "Word cannot be added to your project."
              redirect_to project_path(@project_id), :flash => flash
              return
            end
          end
        else
          flash[:notice] = "The word you're trying to add does not exist."
          redirect_to project_path(@project_id), :flash => flash
          return
          # render the project's page and add link to add this word to the database
        end
      # else
      #   flash[:notice] = "You can't add a word to someone else's project!"
      #   render 'pages/home'
      # end
    else
      flash[:notice] = "You have to register as a developer before trying to add a word to your project."
      render 'pages/home'
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
    @id_words_in_database_before = params[:a1]
    @id_synonyms_words_in_database_before = params[:a2]
    @id_words_not_in_database_before = params[:a3]
    @id_synonyms_words_not_in_database_before = params[:a4]
    @words_in_database_before = Array.new
    @words_not_in_database_before = Array.new
    if @id_words_in_database_before != nil
      @id_words_in_database_before.each do |id_word|
        @words_in_database_before.push(Keyword.find(id_word))
      end
    end
    if @id_words_not_in_database_before != nil
      @id_words_not_in_database_before.each do |id_word|
        @words_not_in_database_before.push(Keyword.find(id_word))
      end
    end
  end

  def add_from_csv_keywords
    id_words_project = params[:words_ids]
    id_project =  params[:id]
    id_words_in_database_before = params[:id_words_in_database_before]
    id_synonyms_words_in_database_before = params[:id_synonyms_words_in_database_before]
    id_words_not_in_database_before = params[:id_words_not_in_database_before]
    id_synonyms_words_not_in_database_before = params[:id_synonyms_words_not_in_database_before]
    if id_words_project != nil
      counter = 0
      while counter < id_words_project.size
        index = id_words_in_database_before.index(id_words_project[counter])
        if index == nil
          index = id_words_not_in_database_before.index(id_words_project[counter])
          id_synonym = id_synonyms_words_not_in_database_before[index]          
        else
          id_synonym = id_synonyms_words_in_database_before[index]
        end
        PreferedSynonym.add_keyword_and_synonym_to_project(id_synonym, id_words_project[counter], id_project)
        counter = counter+1
      end 
    end
    redirect_to action: "show", id: id_project
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
          if !PreferedSynonym.find_word_in_project(params[:project_id], keywrd.id)
            for i in 1..row.size
              Synonym.record_synonym(row[i],keywrd.id)
            end
            for i in 1..row.size
              synonm = Synonym.find_by_name(row[i], keywrd.id)
              if synonm != nil
                id_words_in_database_before.push(keywrd.id)
                id_synonyms_words_in_database_before.push(synonm.id)
                break
              end
            end
          end
        else
          @isSaved, keywrd = Keyword.add_keyword_to_database(row[0])
          if @isSaved
            if !PreferedSynonym.find_word_in_project(params[:project_id], keywrd.id)
              for i in 1..row.size
                Synonym.record_synonym(row[i],keywrd.id)
              end
              for i in 1..row.size
                synonm = Synonym.find_by_name(row[i], keywrd.id)
                if synonm != nil
                  id_words_not_in_database_before.push(keywrd.id)
                  id_synonyms_words_not_in_database_before.push(synonm.id)
                  break
                end
              end
            end
          end
        end
      end
      if id_words_in_database_before.empty? and id_words_not_in_database_before.empty?
        flash[:notice] = "There are no words to import to this project"
        redirect_to action: "show", id: params[:project_id]
      else
        redirect_to action: "choose_keywords",id: params[:project_id], a1:id_words_in_database_before ,a2:id_synonyms_words_in_database_before ,a3:id_words_not_in_database_before ,a4:id_synonyms_words_not_in_database_before 
     end
    end
  end

  def import_csv
    current_project = Project.find(params[:id])
    @project_id = current_project.id
    @message = params[:message]
  end
end