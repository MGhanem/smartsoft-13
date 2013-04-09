# encoding: UTF-8
class ProjectsController < BackendController
  include ApplicationHelper
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
    if current_gamer != nil 
      developer = Developer.where(:gamer_id => current_gamer.id).first
      if developer != nil
        @my_projects = Project.where(:owner_id => developer.id)
        # @shared_projects = developer.projects_shared
      else
        flash[:notice] = t(:projects_index_error1)
        render 'developers/new'
      end
    else
      flash[:error] = t(:projects_index_error2)
      render 'pages/home'
    end
  end

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
    if developer_signed_in?
      @project = Project.createproject(params[:project],current_developer.id)
      @categories = Project.printarray(@project.categories)
      respond_to do |format|
        if @project.save
          format.html { redirect_to "/developers/projects", notice: 'Project was successfully created.' }
          format.json { render json: @project, status: :created, location: @project }
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    else
     developer_unauthorized
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
    if developer_signed_in?
      @project = Project.new
      @categories = @project.categories
      respond_to do |format|
        format.html
        format.json { render json: @project }
      end
    else
      developer_unauthorized
      render 'pages/home'
    end
  end

  def share
    @project = Project.find(params[:id])
  end

  def share_project_with_developer
    @project = Project.find(params[:id])
    gamer = Gamer.find_by_email(params[:email])
    if(!gamer.present?)
      flash[:notice] = "Email doesn't exist"
    else
      developer = Developer.find_by_gamer_id(gamer.id)
      if developer == nil
        flash[:notice] = "Email address is for gamer, not a developer"
      else

        developer.projects_shared << @project
        if(developer.save)
          flash[:notice] = "Project has been shared successfully with #{developer.name}"
        else
          flash[:notice] = "Failed to share project with developer"
        end
      end
    end
    render "projects/share"
  end

  def remove_developer_from_project
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    project.developers_shared.delete(dev)
    project.save
    flash[:notice] = "Developer Unshared!"
   redirect_to "/projects"
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
    if developer_signed_in?
      @project = Project.find(params[:id])
    else
      developer_unauthorized
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
    if developer_signed_in?
      @project = Project.find(params[:id])
      @project = Project.createcategories(@project, params[:project][:categories])
      if @project.update_attributes(params.except(:categories,:utf8, :_method,
      :authenticity_token, :project, :commit, :action, :controller, :locale, :id))
        redirect_to :action => "index"
        flash[:notice] = "Project has been successfully updated."
      else
        render :action => 'edit'
      end
    else
      developer_unauthorized
    end
  end

 # author:Noha hesham
 # Description:
 #   finds the project by its id then destroys it
 # params:
 #   none
 # success:
 #   a pop up appears and makes sure the user wants to
 #   delete the project by choosing ok the 
 #   project is successfully deleted 
 # failure:
 #   project is not deleted
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def show
    @projects = Project.where(:owner_id => current_developer.id)
    @project = Project.find(params[:id])
    if @projects.include?(@project)
      @words = []
      @synonyms = []
      @words_synonyms = PreferedSynonym.where(:project_id => params[:id])
      @words_synonyms.each do |word_synonym|
        word = Keyword.find(word_synonym.keyword_id)
        syn = Synonym.find(word_synonym.synonym_id)
        @words.push(word)
        @synonyms.push(syn)
      end
    else
      redirect_to :action => "index"
      developer_unauthorized
    end
  end

  # add words and their synonym from the imported csv file to the project 
  #
  # == Parameters:
  # words_ids::
  #   array of hashes of word id and their corresponding synonym id
  #
  # id::
  #   current project id
  #
  # == Success return:
  # adds the word and synonym to project and redirects back to project
  #
  # == Failure return :  
  # if the array size is bigger than the word_search of that developer nothing is added
  #
  # @author Mohamed Tamer
  def add_from_csv_keywords
    id_words_project = params[:words_ids]
    project_id =  params[:id]
    if id_words_project != nil
      words_synonyms_array = [id_words_project].map {|x| x.split("|")}
      if Developer.where(:gamer_id => current_gamer.id).first.my_subscription.word_search.to_i < id_words_project.size
        flash[:error] = t(:java_script_disabled)
      else
        words_synonyms_array.each do |word_syn|
          if PreferedSynonym.add_keyword_and_synonym_to_project(word_syn[1], word_syn[0], project_id)

          end
        end
      end
    end
    redirect_to action: "show", id: project_id
  end
  
  # calls parseCSV that returns an array of arrays containing the words and synonyms and checks if these words
  # are new to database or not and accordingly puts them in the corresponding array of new words or and checks the number 
  # of synonyms and the synonyms accepted for each word
  #
  # == Parameters:
  # csvfile::
  #   the csv file the user imported
  #
  # id::
  #   the project id
  #
  # == Success return:
  # returnas an array of words existing in database before, their synonyms, num of those synonyms and array of words new to database, their synonyms and the number of those synonyms
  #
  # == Failure return :  
  # redirect back to the import_csv view with the error message
  #
  # @author Mohamed Tamer
  def choose_keywords
    arr_of_arrs, message = parseCSV(params[:csvfile])
    project_id =  params[:id]
    if message != 0
      if message == 1
        flash[:error] = t(:upload_file_error1)
      end
      if message == 2
        flash[:error] = t(:upload_file_error2)
      end
      if message == 3
        flash[:error] = t(:upload_file_error3)
      end
      if message == 4
        flash[:error] = t(:upload_file_error4)
      end
      redirect_to action: "import_csv", id: project_id
    else
      @id_words_in_database_before = Array.new
      @id_synonyms_words_in_database_before = Array.new
      @id_words_not_in_database_before = Array.new
      @id_synonyms_words_not_in_database_before = Array.new
      @num_synonyms_words_in_database_before = Array.new
      @num_synonyms_words_not_in_database_before = Array.new
      arr_of_arrs.each do |row|
        keywrd = Keyword.find_by_name(row[0])
        if keywrd != nil
          if !PreferedSynonym.find_word_in_project(project_id, keywrd.id)
            for i in 1..row.size
              Synonym.record_synonym(row[i],keywrd.id)
            end
            counter = 0
            for i in 1..row.size
              synonm = Synonym.find_by_name(row[i], keywrd.id)
              if synonm != nil
                counter = counter + 1
                @id_synonyms_words_in_database_before.push(synonm.id)
              end
            end
            if counter > 0
              @id_words_in_database_before.push(keywrd.id)
              @num_synonyms_words_in_database_before.push(counter)
            end
          end
        else
          @isSaved, keywrd = Keyword.add_keyword_to_database(row[0])
          if @isSaved
            if !PreferedSynonym.find_word_in_project(project_id, keywrd.id)
              for i in 1..row.size
                Synonym.record_synonym(row[i],keywrd.id)
              end
              counter = 0
              for i in 1..row.size
                synonm = Synonym.find_by_name(row[i], keywrd.id)
                if synonm != nil
                  counter = counter + 1
                  @id_synonyms_words_not_in_database_before.push(synonm.id)
                end
              end
              if counter > 0
                @id_words_not_in_database_before.push(keywrd.id)
                @num_synonyms_words_not_in_database_before.push(counter)
              end
            end
          end
        end
      end
      if @id_words_in_database_before.empty? and @id_words_not_in_database_before.empty?
        flash[:notice] = t(:upload_file_error5)
        redirect_to action: "show", id: project_id
      else
        if  Developer.where(:gamer_id => current_gamer.id).first.respond_to?("my_subscription")
          @words_remaining = Developer.where(:gamer_id => current_gamer.id).first.my_subscription.word_search.to_i
        else
          @words_remaining = 150
        end
        @words_in_database_before = Array.new
        @words_not_in_database_before = Array.new
        if @id_words_in_database_before != nil
          @id_words_in_database_before.each do |id_word|
            @words_in_database_before.push(Keyword.find(id_word))
          end
          @all_synonyms_words_in_database_before = Array.new
          @id_synonyms_words_in_database_before.each do |id_syn|
            synonym = Synonym.find(id_syn)
            @all_synonyms_words_in_database_before.push(synonym)
          end
          @id_first_synonyms_words_in_database_before = Array.new
          counter = 0
          @num_synonyms_words_in_database_before.each do |num_syns|
            @id_first_synonyms_words_in_database_before.push(@id_synonyms_words_in_database_before[counter])
            counter = counter + num_syns.to_i
          end
        end
        if @id_words_not_in_database_before != nil
          @id_words_not_in_database_before.each do |id_word|
            @words_not_in_database_before.push(Keyword.find(id_word))
          end
          @all_synonyms_words_not_in_database_before = Array.new
          @id_synonyms_words_not_in_database_before.each do |id_syn|
            synonym = Synonym.find(id_syn)
            @all_synonyms_words_not_in_database_before.push(synonym)
          end
          @id_first_synonyms_words_not_in_database_before = Array.new
          counter = 0
          @num_synonyms_words_not_in_database_before.each do |num_syns|
            @id_first_synonyms_words_not_in_database_before.push(@id_synonyms_words_not_in_database_before[counter])
            counter = counter + num_syns.to_i
          end
        end
      end
    end
  end

  # add words and their synonym from the imported csv file to the project 
  #
  # == Parameters:
  # words_ids::
  #   array of hashes of word id and their corresponding synonym id
  #
  # id::
  #   current project id
  #
  # == Success return:
  # adds the word and synonym to project and redirects back to project
  #
  # == Failure return :  
  # if the array size is bigger than the word_search of that developer nothing is added
  #
  # @author Mohamed Tamer
  def add_from_csv_keywords
    id_words_project = params[:words_ids]
    project_id =  params[:id]
    if id_words_project != nil
      words_synonyms_array = [id_words_project].map {|x| x.split("|")}
      if Developer.where(:gamer_id => current_gamer.id).first.my_subscription.word_search.to_i < id_words_project.size
        flash[:error] = t(:java_script_disabled)
      else
        words_synonyms_array.each do |word_syn|
          if PreferedSynonym.add_keyword_and_synonym_to_project(word_syn[1], word_syn[0], project_id)

          end
        end
      end
    end
    redirect_to action: "show", id: project_id
  end
  
  # finds the project and renders the view
  #
  # == Parameters:
  # id::
  #   the project id
  #
  # == Success return:
  #  loads the view
  #
  # == Failure return :  
  # no failure
  #
  # @author Mohamed Tamer
  def import_csv
    current_project = Project.find(params[:id])
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
        # check if project owner or is shared with me too
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
                flash[:notice] = t(:Synonym_changed_successfully)
                redirect_to project_path(@project_id), :flash => flash
                return
              else
                flash[:notice] = t(:Failed_to_update_synonym)
                redirect_to project_path(@project_id), :flash => flash
                return
              end
            else
              flash[:notice] = t(:synonym_does_not_exist)
              redirect_to project_path(@project_id), :flash => flash
              return
            end
          else
            @added_word = PreferedSynonym.add_keyword_and_synonym_to_project(@synonym_id, @word_id, @project_id)
            if @added_word
              flash[:notice] = t(:successfully_added_word_to_project)              
              redirect_to project_path(@project_id), :flash => flash
              return
            else
              flash[:notice] = t(:failed_to_add_word_to_project)
              redirect_to project_path(@project_id), :flash => flash
              return
            end
          end
        else
          flash[:notice] = t(:word_does_not_exist)
          redirect_to project_path(@project_id), :flash => flash
          return
          # render the project's page and add link to add this word to the database
        end
    else
      flash[:notice] = "You have to register as a developer before trying to add a word to your project."
      render 'pages/home'
    end
  end
end
