class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
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
# author:
#      Khloud Khalid
# description:
#     method adds a keyword and a synonym to an existing project by creating a new ProjectWord object 
# params:
#     project_id, word_id, synonym_id
# success:
#     keyword and synonym are added to project (new ProjectWord object created) 
# failure:
#     object not valid (no project or word id), word already exists in project, keyword does not exist, 
#     developer trying to add word is not owner of the project nor is the project shared with him/her, not registered
#     developer.
  def add_word
    # if he word doesn't have synonyms redirect to follow word
    if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      if Project.find_by_developer_id(Developer.find_by_gamer_id(current_gamer.id)).find_by_id(@project_id) != nil
        # check of project is shared with me too
        @word_id = params[:word_id]
        if Keyword.find_by_id(@word_id) != nil
          if ProjectWord.find_by_project_id(@project_id).find_by_keyword_id(@word_id) == nil
            @synonym_id = params[:synonym_id]
            # check for free users, if the words exceeds 20 words
            @added_word = ProjectWord.new(@word_id, @project_id, @synonym)
            if @added_word.save
              flash[:notice] = "You have successfully added the word to your project."
              # render the project's page
            else
              flash[:notice] = "Word cannot be added to your project."
              # render the project's page
            end
          else
            flash[:notice] = "Don't you remember you already added this word to your project?"
            # render the project's page
          end
        else
          flash[:notice] = "The word you're trying to add does not exist."
          # render the project's page and add link to add this word to the database
        end
      else
        flash[:notice] = "You can't add a word to someone else's project!"
        render 'pages/home'
      end
    else
      flash[:notice] = "You have to register as a developer before trying to add a word to your project."
      render 'pages/home'
    end
  end
# author:
#      Khloud Khalid
# description:
#     method changes the chosen synonym of a keyword in a certain project
# params:
#     project_id, word_id, synonym_id
# success:
#     synonym updated successfully
# failure:
#     keyword or synonym does not exist, keyword is not in the project, developer trying to add word is not owner 
#     of the project nor is the project shared with him/her, not registered developer.
  def change_synonym
    if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      if Project.find_by_developer_id(Developer.find_by_gamer_id(current_gamer.id)).find_by_id(@project_id) != nil
        # check of project is shared with me too
        @word_id = params[:word_id]
        if Keyword.find_by_id(@word_id) != nil
          @edited_word = ProjectWord.find_by_keyword_id(@word_id).find_by_project_id(@project_id)
          if  @edited_word != nil
            @synonym_id = params[:synonym_id]
            if Synonym.find_by_id(@synonym_id) != nil
              @edited_word.synonym_id = @synonym_id
              if @edited_word.save
                flash[:notice] = "Synonym changed successfully."
                # render the project's page
              else
                flash[:notice] = "Failed to update synonym"
                # render the project's page
              end
            else
              flash[:notice] = "This synonym does not exist."
              # render project's page
            end
          else
            flash[:notice] = "This word is not in the project."
            # render project's page
          end
        else
          flash[:notice] = "This word does not exist."
          # render the project's page and add link to add this word to the database
        end
      else
        flash[:notice] = "You can't edit someone else's project!"
        render 'pages/home'
      end
    else
      flash[:notice] = "You have to register as a developer before trying to change the synonym of this word."
      render 'pages/home'
    end
  end
# author:
#      Khloud Khalid
# description:
#     method removes a given word from a project
# params:
#     project_id, word_id
# success:
#     word removed successfully
# failure:
#     keyword does not exist or is not in the project, developer trying to remove word is not owner 
#     of the project nor is the project shared with him/her, not registered developer.
  def remove_word
     if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      if Project.find_by_developer_id(Developer.find_by_gamer_id(current_gamer.id)).find_by_id(@project_id) != nil
        # check of project is shared with me too
        @word_id = params[:word_id]
        if Keyword.find_by_id(@word_id) != nil
          @removed_word = ProjectWord.find_by_keyword_id(@word_id).find_by_project_id(@project_id)
          if  @removed_word != nil
            @removed_word.destroy
            flash[:notice] = "Word removed successfully."
            # render project's page
          else
            flash[:notice] = "This word is not in the project."
            # render project's page
          end
        else
          flash[:notice] = "The word you're trying to remove does not exist."
          # render the project's page and add link to add this word to the database
        end
      else
        flash[:notice] = "You can't remove a word from someone else's project!"
        render 'pages/home'
      end
    else
      flash[:notice] = "You have to register as a developer before trying to remove a word from your project."
      render 'pages/home'
    end
  end
end