# encoding: UTF-8
class ProjectsController < BackendController
  include ApplicationHelper
  # GET /projects
  # GET /projects.json
  before_filter :authenticate_gamer!
  before_filter :authenticate_developer!
  before_filter :developer_can_see_this_project?, :only => [:import_csv, :show, :add_from_csv_keywords, :choose_keywords]

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
    
  # author: 
  #    Mohamed Tamer
  # description:
  #    function shows all the projects that a certain developer owns and the projects shared with him
  # Params:
  #    current_gamer: the current logged in gamer, will be nil if there is no logged in gamer
  # Success:
  #    returns array of projects that the developer own and the projects shared with him
  # Failure:
  #    redirects to developers/new if the current gamer doesn't have a developer account of sign in page if there is no logged in gamerdef index
  def index  
    if current_gamer != nil 
      developer = Developer.where(:gamer_id => current_gamer.id).first
      if developer != nil
        @my_projects = Project.where(:owner_id => developer.id)
        @shared_projects = developer.projects_shared
      else
        flash[:notice] = "من فضلك سجل كمطور"
        redirect_to developers_new_path
      end
    else
      flash[:error] = t(:projects_index_error2)
      redirect_to new_gamer_session_path      
    end
  end


  # Author:
  #   Salma Farag
  # Description:
  #   After checking that the user is signed in, the method that calls method createproject
  #   that creates the project and redirects to the project page and prints
  #   an error if the data entered is invalid.
  # Params:
  #   None
  # Success:
  #   Creates a new project and views it in the index page
  # Failure:
  #   Gives status errors
  def create
    if developer_signed_in?
      @project = Project.createproject(params[:project],current_developer.id)
      respond_to do |format|
        if @project.save
          format.html { redirect_to "/developers/projects",
            notice: I18n.t('views.project.flash_messages.project_was_successfully_created') }
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

  # Author:
  #    Salma Farag
  # Description:
  #   A method that views the form that  instantiates an empty project object
  #   after checking that the user is signed in.
  # Params:
  #   None
  # Success:
  #   An empty project will be instantiated
  # Failure:
  #   None
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

  # Author:
  #  Noha Hesham
  # Description:
  #  finds the project by the params id
  # Params:
  #  none
  # success:
  #  project is found 
  # failure:
  #  none
  def share
    @project = Project.find(params[:id])
  end

  # Author:
  #   Salma Farag
  # Description:
  #   A method that specifies an already existing project by its ID
  # Params:
  #   None
  # Success:
  #   A form that contains the existing data of the project will open from the views.
  # Failure:
  #   None
  def edit
    if developer_signed_in?
      @project = Project.find(params[:id])
      @categories = Project.printarray(@project.categories)
    else
      developer_unauthorized
    end
  end

  # Author:
  #   Salma Farag
  # Description:
  #   A method that checks if the fields of the form editting the project have been changed.
  #   If yes, the new values will replace the old ones otherwise nothing will happen.
  # Params:
  #   None
  # Success:
  #   An existing project will be updated.
  # Failure:
  #   The old values will be kept.
  def update
    if developer_signed_in?
      @project = Project.find(params[:id])
      @project = Project.createcategories(@project, params[:project][:categories])
      if @project.update_attributes(params[:project].except(:categories,:utf8, :_method,
        :authenticity_token, :project, :commit, :action, :controller, :locale, :id))
        redirect_to :action => "index"
        flash[:notice] = I18n.t('views.project.flash_messages.project_was_successfully_updated')
      else
        render :action => 'edit'
      end
    else
      developer_unauthorized
    end
  end


  # Author:
  #    Salma Farag
  # Description:
  #   A method that finds the projects of the current developer and then checks for a certain project
  #   and finds the words and synonyms of this project then inserts each into an array then redirects to the
  #   projects index.
  # Params:
  #   None
  # Success:
  #   An project will be showed with its words and synonyms.
  # Failure:
  #   None.
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
  



  def remove_developer_from_project
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    project.developers_shared.delete(dev)
    project.save
    flash[:notice] = "Developer Unshared!"
   redirect_to "/projects"
  end

  
  # Author:
  #   Mohamed Tamer
  # Description:
  #   calls parseCSV that returns an array of arrays containing the words and synonyms and checks if these words
  #   are new to database or not and accordingly puts them in the corresponding array of new words or and checks the number 
  #   of synonyms and the synonyms accepted for each word
  # Params:
  #   csvfile: the csv file the user imported
  #   id: the project id
  # Success:
  #   returns an array of words existing in database before, their synonyms, num of those synonyms and array of words new to database, their synonyms and the number of those synonyms
  # Failure:
  #   redirect back to the import_csv view with the error message
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
      if @id_words_in_database_before.empty? && @id_words_not_in_database_before.empty?
        flash[:notice] = t(:upload_file_error5)
        redirect_to action: "show", id: project_id
      else
        if Developer.where(:gamer_id => current_gamer.id).first.my_subscription != nil
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

  # author:
  #   Mohamed tamer
  # description:
  #   add words and their synonym from the imported csv file to the project 
  # Params:
  #   words_ids: array of hashes of word id and their corresponding synonym id
  #   id: current project id
  # Success:
  #   returns adds the word and synonym to project and redirects back to project
  # Failure: 
  #   if the array size is bigger than the word_search of that developer nothing is added
  def add_from_csv_keywords
    id_words_project = params[:words_ids]
    project_id =  params[:id]
    if id_words_project != nil
      words_synonyms_array = id_words_project.map {|x| x.split("|")}
      if Developer.where(:gamer_id => current_gamer.id).first.my_subscription != nil
        if Developer.where(:gamer_id => current_gamer.id).first.my_subscription.word_search.to_i < id_words_project.size
          flash[:error] = t(:java_script_disabled)
          redirect_to action: "show", id: project_id
          return
        end
      end
      words_synonyms_array.each do |word_syn|
        if PreferedSynonym.add_keyword_and_synonym_to_project(word_syn[1], word_syn[0], project_id)
          if Developer.where(:gamer_id => current_gamer.id).first.my_subscription != nil
            MySubscription.decrement_word_search
          end
        end
      end
    end
    redirect_to action: "show", id: project_id
  end
  
  # Author:
  #   Mohamed Tamer
  # Description: 
  #   finds the project and renders the view
  # Params:
  #   id: the project id
  # Success:
  #   loads the view
  # Failure:
  #   no failure
  def import_csv
    current_project = Project.find(params[:id])
  end

# author:
#   Khloud Khalid
# description:
#   method adds a keyword and a synonym to an existing project and if word already exists in the project updates
#   its synonym
# params:
#   project_id, word_id, synonym_id
# success:
#   keyword and synonym are added to project or synonym of word updated 
# failure:
#   object not valid (no project or word id), word already exists in project, keyword or synonym does not exist.
  def add_word
    #raise Exception , "dsjafhd"
    if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      #raise Exception, params[:synonym_id]
      #raise Exception , params
      @word_id = Keyword.find_by_name(params[:keyword]).id
      #raise Exception , params[:keyword]
      if Keyword.find_by_id(@word_id) != nil
        @synonym_id = params[:synonym_id]
        if PreferedSynonym.find_word_in_project(@project_id, @word_id)
          #kk@edited_word = PreferedSynonym.find_by_keyword_id(@word_id) 
          @edited_word = PreferedSynonym.where(project_id:@project_id, keyword_id:@word_id).first
          #hena ho
          #raise Exception , @edited_word.inspect
          @synonym_id = params[:synonym_id]
          if Synonym.find_by_id(@synonym_id) != nil
            @edited_word.synonym_id = @synonym_id
            #raise Exception , params
            if @edited_word.save
              flash[:success] = t(:Synonym_changed_successfully)
              redirect_to project_path(@project_id), flash: flash
              return
            else
              flash[:notice] = t(:Failed_to_update_synonym)
              redirect_to project_path(@project_id), flash: flash
              return
            end
          else
            flash[:notice] = t(:synonym_does_not_exist)
            redirect_to project_path(@project_id), flash: flash
            return
          end
        else
          @added_word = PreferedSynonym.add_keyword_and_synonym_to_project(@synonym_id, @word_id, @project_id)
          if @added_word
            flash[:success] = t(:successfully_added_word_to_project)              
            redirect_to project_path(@project_id), flash: flash
            return
          else
            flash[:notice] = t(:failed_to_add_word_to_project)
            redirect_to project_path(@project_id), flash: flash
            return
          end
        end
      else
        flash[:notice] = t(:word_does_not_exist)
        redirect_to project_path(@project_id), flash: flash
        return
      end
    end
  end

  def change_synonym
    @project_id = params[:project_id].to_i
    @synonym_id = params[:synonym_id].to_i
    #raise Exception, @synonym_id
    keyword_object = Synonym.find(@synonym_id).keyword
    @keyword = keyword_object.name
    #@keyword = params[:keyword]
    #add_word and return
    redirect_to projects_add_word_path(project_id: @project_id, 
      synonym_id: @synonym_id, keyword: @keyword )
  end

  def quick_add
    @project_id = params[:project_id].to_i
    @synonym_id = params[:synonym_id].to_i
    #raise Exception, @synonym_id
    #@synonym_id = 8
    #raise Exception , @project_id
    #keyword_object = Synonym.find(@synonym_id).keyword
    @keyword = params[:keyword]
    add_word and return
    #redirect_to projects_add_word_path(project_id: @project_id, 
     # synonym_id: @synonym_id, keyword: @keyword )
  end

  def load_synonyms
    project_id = params[:project_id].to_i
    @project = Project.find(project_id)
    synonym_id = params[:project_id].to_i
    keyword = params[:word]
    keyword_object = Keyword.find_by_name(keyword)
    @keyword_synonyms = []
    if keyword_object
      @keyword_synonyms = Synonym.where(keyword_id: keyword_object.id)
    end
  end 
  
  def project_keyword_autocomplete
    keyword = params[:keyword_search]
    similar_keywords = Keyword.get_similar_keywords(keyword, [])
    similar_keywords.map! { |keyword| keyword.name }
    render json: similar_keywords
  end 


# author:
#   Khloud Khalid
# description:
#   method removes a given word from a project
# params:
#   project_id, word_id
# success:
#   word removed successfully
# failure:
#   keyword does not exist or is not in the project, not registered developer.
  def remove_word
    if Developer.find_by_gamer_id(current_gamer.id) != nil 
      @project_id = params[:project_id]
      @word_id = params[:word_id]
      @removed_word = PreferedSynonym.where(keyword_id: @word_id).all
      @removed_word.each do |word| 
        if word.project_id = @project_id
          @remove = word
        end 
      end
      if  @remove != nil
        @remove.destroy
        flash[:success] = t(:word_removed_successfully)
        redirect_to project_path(@project_id), flash: flash
      else
        flash[:notice] = t(:word_does_not_exist)
        redirect_to project_path(@project_id), flash: flash
      end
    end
  end


  
  # author:
#      Khloud Khalid
# description:
#   method exports words and synonyms of a given project to a .csv file
# params:
#   project_id
# success:
#   data exported successfully
# failure:
#   project does not exist, not registered developer.
  def export_to_csv 
    if Developer.find_by_gamer_id(current_gamer.id) != nil
      @project_id = params[:project_id]
      if Project.find_by_id(@project_id) != nil   
        @exported_data = PreferedSynonym.where(project_id: @project_id).all
        csv_string = CSV.generate do |csv|
          if @exported_data != []
            @exported_data.each do |word|
              @keyword = Keyword.find_by_id(word.keyword_id).name
              @synonym = Synonym.find_by_id(word.synonym_id).name
              csv << [@keyword, @synonym]
            end
          else
            flash[:notice] = t(:no_words)
            redirect_to project_path(@project_id), flash: flash
            return
          end
        end         
        send_data csv_string,
        type: "text/csv; charset=iso-8859-1; header=present",
        disposition: "attachment; filename=project_data.csv" 
      else
        flash[:notice] = t(:no_project)
        render "pages/home"
      end
    else
      flash[:notice] = t(:not_developer)
      render "pages/home"
    end
  end 
end
