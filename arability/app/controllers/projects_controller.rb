# encoding: UTF-8
class ProjectsController < BackendController
  include ApplicationHelper
  include SearchHelper
  # GET /projects
  # GET /projects.json
  before_filter :authenticate_gamer!
  before_filter :authenticate_developer!
  before_filter :developer_can_see_this_project?,
  only: [:import_csv, :show, :add_from_csv_keywords, :choose_keywords, :edit, :update,
    :view_recommended_words, :get_recommended_words, :share]
  before_filter :can_access_project?,
  only: [:add_word_inside_project, :removed_word, :export_to_csv, :export_to_xml, :export_to_json]

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
    temp_projects = Project.where(owner_id: current_developer.id)
    if !temp_projects.include?(@project)
      flash[:error] = t(:developer_cant_see_project)
      redirect_to projects_path
      return
    end
    @project.destroy
    respond_to do |format|
      format.html { redirect_to action: "index",controller: "projects"}
      format.json { head :no_content }
      flash[:success] = t(:project_delete)
    end
  end

  # Author:
  #   Kareem Ali
  # Description:
  #   Tests whether this the current_developer has followed this keyword
  #   or not.
  # Params:
  #   project_id: containing the id of the project from this keyword has
  #   been searched for.
  #   keyword: containing the nae of the keyword for the which the user might
  #   follow
  # Success:
  #   returns true if the keyword has been followed and the it's id
  # Failure:
  #   returns false if the keyword is not followed by the developer and it's id
  def test_followed_keyword
    @project_id = params[:project_id]
    keyword = params[:keyword]
    if keyword
      searched_keyword = Keyword.where(name: keyword).first
      @searched_keyword_id = searched_keyword.id
      @is_followed = is_following(@searched_keyword_id)
    end
    render "projects/test_followed_keyword.js"
  end

  # Author:
  #   Kareem Ali
  # Description:
  #   follows or unfollows a keyword which has no synonyms when the developer
  #   searches for it inside the project
  # Params:
  #   project_id: containing the id of the project from this keyword has
  #   been searched for.
  #   keyword_id: containing the id of the keyword for the which the user might
  #   follow
  #   is_followed: a string containing "true" if the keyword is previously
  #   followed or "false" if the keyword is not followed
  # Success:
  #   returns the flash of the keyword has been successfully unfollowed and
  #   redirects to the project page
  # Failure:
  #   returns the flash of the keyword has been successfully followed and
  #   redirects to the project page
  def follow_unfollow
    project_id = params[:project_id]
    developer = current_developer
    is_followed = params[:is_followed]
    if params[:keyword_id] != nil
      keyword_ids = developer.keyword_ids
      keyword = Keyword.find(params[:keyword_id])
      if is_followed == "true"
        developer.unfollow(params[:keyword_id])
        flash[:success] = t(:unfollow_keyword_alert) + " " + keyword.name
        redirect_to project_path(project_id), flash: flash
      elsif is_followed == "false"
        developer.follow(params[:keyword_id])
        flash[:success] = t(:follow_keyword_alert) + " " + keyword.name
        redirect_to project_path(project_id), flash: flash
      end
    end
  end

  # author:
  #   Mohamed Tamer
  # description:
  #   Function shows all the projects that a certain developer owns and the projects shared with him
  # Params:
  #   current_gamer: the current logged in gamer, will be nil if there is no logged in gamer
  # Success:
  #   Returns array of projects that the developer own and the projects shared with him
  # Failure:
  #   None
  def index
    @developer = Developer.where(gamer_id: current_gamer.id).first
    @my_projects = Project.where(owner_id: @developer.id)
    @shared_projects = @developer.projects_shared
  end

  # Author:
  #   Salma Farag
  # Description:
  #   A method that views the form that checks if the developer is signed in and has not exceeded the
  #   max number of projects allowed and instantiates an empty project
  #   after checking that the user is signed in.
  # Params:
  #   None
  # Success:
  #   An empty project will be instantiated
  # Failure:
  #   If not signed in he will be redirected to the sign in page.
  #   If he's exceeded the max number for projects, he will be redirected to the subscription model page.
  def new
    if current_developer.my_subscription.get_projects_limit
      @project = Project.new
      respond_to do |format|
        format.html
        format.json { render json: @project }
      end
    else
        redirect_to choose_sub_path
        flash[:notice] = t(:exceeded_project_limit)
    end
  end

  # Author:
  #   Salma Farag
  # Description:
  #   After checking that the user is signed in, the method that calls method create_project
  #   that creates the project and redirects to the project page and prints
  #   an error if the data entered is invalid.
  # Params:
  #   :description: about the project
  #   :formal: formal/slang boolean value
  #   :maxAge: maximum age
  #   :minAge: minimum age
  #   :name: name of the project
  #   :category: project category
  #   :country
  #   :education_level
  #   :gender m/f boolean value
  # Success:
  #   Creates a new project and views it in the index page
  # Failure:
  #   Gives status errors
  def create
    @project = Project.new(params[:project].except(:category))
    @project = Project.createproject(params[:project],current_developer.id)
    respond_to do |format|
      if @project.save
        format.html { redirect_to "/developers/projects",
          flash: { success: I18n.t('views.project.flash_messages.project_was_successfully_created') } }
          format.json { render json: @project, status: :created, location: @project }
      else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
      end
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
    gamers_ids = Developer.pluck(:gamer_id)
    @usernames_and_emails = Gamer.where(:id => gamers_ids).map{|gamer|gamer.username + " " + gamer.email}
  end

  # Author:
  #   Salma Farag
  # Description:
  #   A method that specifies an already existing project by its ID
  # Params:
  #   :description: about the project
  #   :formal: formal/slang boolean value
  #   :maxAge: maximum age
  #   :minAge: minimum age
  #   :name: name of the project
  #   :category: project category
  #   :country
  #   :education_level
  #   :gender m/f boolean value
  # Success:
  #   A form that contains the existing data of the project will open from the views.
  # Failure:
  #   None
  def edit
    @project = Project.find(params[:id])
  end

  # Author:
  #   Salma Farag
  # Description:
  #   A method that checks if the fields of the form editing the project have been changed.
  #   If yes, the new values will replace the old ones otherwise nothing will happen.
  #   Then calls method createcategories that changes the category.
  # Params:
  #   :description: about the project
  #   :formal: formal/slang boolean value
  #   :maxAge: maximum age
  #   :minAge: minimum age
  #   :name: name of the project
  #   :category: project category
  #   :country
  #   :education_level
  #   :gender m/f boolean value
  # Success:
  #   An existing project will be updated.
  # Failure:
  #   The old values will be kept.
  def update
    @project = Project.find(params[:id])
    @project = Project.createcategories(@project, params[:project][:category])
    if @project.update_attributes(params[:project].except(:category, :utf8, :_method,
      :authenticity_token, :commit, :action, :controller, :locale, :id))
      redirect_to action: "index"
      flash[:success] = I18n.t('views.project.flash_messages.project_was_successfully_updated')
    else
      render action: 'edit'
    end
  end


  # Author:
  #   Salma Farag
  # Description:
  #   A method that finds the projects of the current developer and then checks for a certain project
  #   and finds the words and synonyms of this project then inserts each into an array then redirects to the
  #   projects index.
  # Params:
  #   :description: about the project
  #   :formal: formal/slang boolean value
  #   :maxAge: maximum age
  #   :minAge: minimum age
  #   :name: name of the project
  #   :category: project category
  #   :country
  #   :education_level
  #   :gender m/f boolean value
  # Success:
  #   An project will be showed with its words and synonyms.
  # Failure:
  #   None.

def show
  @project = Project.find(params[:id])
  @words = []
  @synonyms = []
  @words_synonyms = PreferedSynonym.where(project_id: params[:id])
  @words_synonyms.each do |word_synonym|
    word = Keyword.find(word_synonym.keyword_id)
    syn = Synonym.find(word_synonym.synonym_id)
    @words.push(word)
    @synonyms.push(syn)
  end
end

  # Author:
  #   Salma Farag
  # Description:
  #   After checking the limit of words, the method finds the project by its id
  #   and then calls the method filter_keywords in Project that filters the relevant keywords.
  # Params:
  #   Project id
  # Success:
  #   Getting an array of keywords relevant to the project
  # Failure:
  #   The user has exceeded the maximum limit of words to be added and hence will not be able
  #   to add any more.
  def view_recommended_words
      @project = Project.find(params[:project_id])
      @karray = Project.filter_keywords(@project.id,@project.category_id)
  end

  # Author:
  #   Salma Farag
  # Description:
  #   After the users chooses the words he would like to add to his project from the recommended
  #   words list, the method gets the chosen keyword ids,with their synonyms ids and the project
  #   the words will be added to. The words and their synonyms will be added after checking some
  #   authorization validations.
  # Params:
  #   Project id
  #   A hash of the keywords and their synonyms
  # Success:
  #   The words will be successfully added to the project
  # Failure:
  #   The user has exceeded the maximum limit of words to be added and hence will not be able
  #   to add any more.
  def get_recommended_words
    @project = Project.find(params[:project_id])
    if params[:synonym] != nil
      params[:synonym].each do |key, syn|
        @word_id = Keyword.find((key.to_i)).id
        @synonym_id = syn.to_i
        if current_developer.my_subscription.can_add_word(@project.id)
          @added_word = PreferedSynonym.add_keyword_and_synonym_to_project(
            @synonym_id, @word_id, @project.id)
        end
      end
    end
    redirect_to project_path(@project.id)
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
  #   Calls parseCSV that returns an array of arrays containing the words and synonyms and checks if these words
  #   are new to database or not and accordingly puts them in the corresponding array of new words or and checks the number
  #   of synonyms and the synonyms accepted for each word
  # Params:
  #   csvfile: the csv file the user imported
  #   id: the project id
  # Success:
  #   Returns an array of words existing in database before, their synonyms, num of those synonyms and array of words new to database, their synonyms and the number of those synonyms
  # Failure:
  #   Redirects back to the import_csv view with the error message
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
      if I18n.locale == :ar
        @language = "arabic"
      else
        @language = "english"
      end
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
            if @id_words_in_database_before.include?(keywrd.id) || @id_words_not_in_database_before.include?(keywrd.id)
              if @id_words_in_database_before.include?(keywrd.id)
                index = @id_words_in_database_before.index(keywrd.id)
                index2 = 0
                for i in 0..index
                  index2 = index2 + @num_synonyms_words_in_database_before[i]
                end
                for i in 1..row.size
                  synonm = Synonym.find_by_name(row[i], keywrd.id)
                  if synonm != nil
                    counter = counter + 1
                    @id_synonyms_words_in_database_before.insert(index2, synonm.id)
                    index2 = index2 + 1
                  end
                end
                if counter > 0
                  old_num_syns =  @num_synonyms_words_in_database_before[index].to_i
                  @num_synonyms_words_in_database_before[index] = counter + old_num_syns
                end
              else
                index = @id_words_not_in_database_before.index(keywrd.id)
                index2 = 0
                for i in 0..index
                  index2 = index2 + @num_synonyms_words_not_in_database_before[i]
                end
                for i in 1..row.size
                  synonm = Synonym.find_by_name(row[i], keywrd.id)
                  if synonm != nil
                    counter = counter + 1
                    @id_synonyms_words_not_in_database_before.insert(index2, synonm.id)
                    index2 = index2 + 1
                  end
                end
                if counter > 0
                  old_num_syns =  @num_synonyms_words_not_in_database_before[index].to_i
                  @num_synonyms_words_not_in_database_before[index] = counter + old_num_syns
                end
              end
            else
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
      developer = Developer.where(gamer_id: current_gamer.id).first
      my_sub = developer.my_subscription
      flag_continue = my_sub.max_add_word(project_id)
      if !flag_continue
        flash[:notice] = t(:upload_file_error6)
        redirect_to action: "show", id: project_id
        return
      end
      if @id_words_in_database_before.empty? && @id_words_not_in_database_before.empty?
        flash[:notice] = t(:upload_file_error5)
        redirect_to action: "show", id: project_id
      else
        developer = Developer.where(gamer_id: current_gamer.id).first
        my_sub = developer.my_subscription
        @words_remaining = my_sub.max_add_word_count(project_id)
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
  #   Add words and their synonym from the imported csv file to the project
  # Params:
  #   words_ids: array of hashes of word id and their corresponding synonym id
  #   id: current project id
  # Success:
  #   Returns adds the word and synonym to project and redirects back to project
  # Failure:
  #   If the array size is bigger than the word_search of that developer nothing is added
  def add_from_csv_keywords
    id_words_project = params[:words_ids]
    project_id =  params[:id]
    if id_words_project != nil
      words_synonyms_array = id_words_project.map {|x| x.split("|")}
      developer = Developer.where(gamer_id: current_gamer.id).first
      my_sub = developer.my_subscription
      words_count = my_sub.max_add_word_count(project_id)
      if words_count < id_words_project.size
        flash[:error] = t(:java_script_disabled)
        redirect_to action: "show", id: project_id
        return
      end
      words_synonyms_array.each do |word_syn|
        if PreferedSynonym.add_keyword_and_synonym_to_project(word_syn[1], word_syn[0], project_id)
          flag, current_keyword = PreferedSynonym.find_word_in_project(project_id, word_syn[0], true)
          current_project_category = Project.find_by_id(project_id).category
          current_keyword.categories << current_project_category
        end
      end
    end
    redirect_to action: "show", id: project_id
  end

  # Author:
  #   Mohamed Tamer
  # Description:
  #   finds the project and renders the import_csv view
  # Params:
  #   id: the project id
  # Success:
  #   Loads the import_csv view
  # Failure:
  #   No failure
  def import_csv
    current_project = Project.find(params[:id])
  end

  # author:
  #   Khloud Khalid, Kareem Ali
  # description:
  #   method adds a keyword and a synonym to an existing project and if word already
  #   exists in the project updates its synonym and if the adds the categories of
  #   the project to the keyword's categories if not present.
  # params:
  #   project_id, word_id, synonym_id
  # success:
  #   keyword and synonym are added to project and/or synonym of word updated
  # failure:
  #   object not valid (no project or word id), word already exists in project,
  #   keyword or synonym does not exist, word add limit exceeded.
  def add_word_inside_project
    @project_id = params[:project_id]
    if !(@project_id.blank?)
      @word_id = Keyword.find_by_name(params[:keyword]).id
      if @word_id != nil && Keyword.find_by_id(@word_id) != nil
        @synonym_id = params[:synonym_id]
        if PreferedSynonym.find_word_in_project(@project_id, @word_id)
          @edited_word = PreferedSynonym.where(project_id: @project_id,
            keyword_id: @word_id).first
          @synonym_id = params[:synonym_id]
          if @synonym_id != nil && Synonym.find_by_id(@synonym_id) != nil
            @edited_word.synonym_id = @synonym_id
            if @edited_word.save
              respond_to do |format|
                format.html {
                flash[:success] = t(:Synonym_changed_successfully)
                redirect_to project_path(@project_id), flash: flash
                return
              }
                format.json { render json: [t(:Synonym_changed_successfully)] }
              end
            else
              respond_to do |format|
                format.html {
                  flash[:notice] = t(:Failed_to_update_synonym)
                  redirect_to project_path(@project_id), flash: flash
                  return
                }
                format.json { render json: [t(:Failed_to_update_synonym)] }
              end
            end
          else
            respond_to do |format|
                format.html {
                  flash[:error] = t(:synonym_does_not_exist)
                  redirect_to :back, flash: flash
                  return
                }
                format.json { render json: [t(:synonym_does_not_exist)] }
            end
          end
        else
          @my_subscription =
           MySubscription.where(developer_id: current_developer.id).first
          if @my_subscription.can_add_word(@project_id)
            @added_word = PreferedSynonym.add_keyword_and_synonym_to_project(
              @synonym_id, @word_id, @project_id)
            if @added_word
              project_category = Project.find(@project_id).category
              new_keyword = Keyword.find(@word_id)
              if project_category and
                not new_keyword.categories.include?(project_category)
                new_keyword.categories << project_category
                new_keyword.save
              end
              respond_to do |format|
                format.html {
                  flash[:success] = t(:successfully_added_word_to_project)
                  redirect_to project_path(@project_id), flash: flash
                  return
                }
                format.json { render json: [t(:successfully_added_word_to_project)] }
              end
            else
              respond_to do |format|
                format.html {
                  flash[:notice] = t(:failed_to_add_word_to_project)
                  redirect_to project_path(@project_id), flash: flash
                  return
                }
                format.json { render json: [t(:failed_to_add_word_to_project)] }
              end
            end
          else
            respond_to do |format|
                format.html {
                  flash[:notice] = t(:exceeds_word_limit)
                  redirect_to project_path(@project_id), flash: flash
                }
                format.json { render json: [t(:exceeds_word_limit)] }
              end
          end
        end
      else
        respond_to do |format|
          format.html {
            flash[:notice] = t(:word_does_not_exist)
            redirect_to project_path(@project_id), flash: flash
            return
          }
          format.json { render json: [t(:word_does_not_exist)] }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = t(:choose_project)
          redirect_to :back, flash: flash
        }
        format.json { render json: [t(:choose_project)] }
      end
    end
  end

  # author:
  #   Kareem Ali
  # description:
  #   Updates the prefered synonym to a specific keyword inside the project
  # params:
  #   project_id, word_id, synonym_id
  # success:
  #   redirects to the add_word_inside_project method inside the controller
  #   to update the synonym
  # failure:
  #   will redirect to the add_word_inside_project to handle the incorrect object
  def change_synonym
    @project_id = params[:project_id].to_i
    @synonym_id = params[:synonym_id].to_i
    keyword_object = Synonym.find(@synonym_id).keyword
    @keyword = keyword_object.name
    redirect_to add_word_inside_project_path(project_id: @project_id,
      synonym_id: @synonym_id, keyword: @keyword )
  end

  # author:
  #   Kareem Ali
  # description:
  #   Used to load the synonyms in the dropdown menu next to the keyword
  #   inside the project to change the synonym
  # params:
  #   project_id, word
  # success:
  #   renders the javascript of loading synonyms to update the
  #   dropdown menu next to the keyowrd
  # failure:
  #   no Failure
  def load_synonyms
    project_id = params[:project_id].to_i
    @project = Project.find(project_id)
    keyword = params[:word]
    keyword_object = Keyword.find_by_name(keyword)
    @keyword_synonyms = []
    if keyword_object
      @keyword_synonyms = Synonym.where(keyword_id: keyword_object.id)
    end
    render "load_synonyms.js.erb"
  end

  # author:
  #   Kareem Ali
  # description:
  #   Used for autocomplete textbox in the project view to autocomplete
  #   the words given by the user
  # params:
  #   keyword_search: for which the user writes in the textbox , project_id
  # success:
  #   returns an array of the similar words which are sorted according
  #   to the categories of the keywords, keywords with has one or more
  #   of project categories comes first and make sure that
  #   duplicates are removed.
  # failure:
  #   no keyword match the entered character(s), will return empty array
  def project_keyword_autocomplete
    keyword = params[:keyword_search]
    project_category = Project.find(params[:project_id]).category
    similar_keywords = []
    if project_category != nil
      project_category = project_category.get_name_by_locale
      similar_keywords = Keyword.get_similar_keywords(
        keyword, [project_category])
      similar_keywords = similar_keywords.uniq
    end
      match_category_count = similar_keywords.count
      similar_keywords = similar_keywords.concat(
        Keyword.get_similar_keywords(keyword,[]))
      similar_keywords = similar_keywords.uniq
      similar_keywords.map! { |keyword| keyword.name }
      similar_keywords.push(match_category_count)
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
    @project_id = params[:project_id]
    @word_id = params[:word_id]
    @removed_word = PreferedSynonym.where(keyword_id: @word_id).all
    @removed_word.each do |word|
      if word.project_id = @project_id
        @remove = word
      end
    end
      if @remove != nil
        @remove.destroy
        flash[:success] = t(:word_removed_successfully)
        redirect_to project_path(@project_id), flash: flash
      else
        flash[:notice] = t(:word_does_not_exist)
        redirect_to project_path(@project_id), flash: flash
      end
    end

  # author:
  #   Khloud Khalid
  # description:
  #   method exports words and synonyms of a given project to a .csv file
  # params:
  #   project_id
  # success:
  #   data exported successfully
  # failure:
  #   project does not exist, not registered developer, no words in project.
  def export_to_csv
    @project_id = params[:project_id]
    if Project.find(@project_id) != nil
      @exported_data = PreferedSynonym.where(project_id: @project_id).all
      csv_string = CSV.generate do |csv|
        if @exported_data != []
          @exported_data.each do |word|
            @keyword = Keyword.find(word.keyword_id).name
            @synonym = Synonym.find(word.synonym_id).name
            csv << [@keyword, @synonym]
          end
        else
          flash[:notice] = t(:no_words)
          redirect_to project_path(@project_id), flash: flash
          return
        end
      end
      send_data csv_string,
      type: "text/csv; charset=UTF-8; header=present",
      disposition: "attachment; filename=project_data.csv"
    else
      flash[:notice] = t(:no_project)
      redirect_to projects_path, flash: flash
    end
  end

  # author:
  #   Khloud Khalid
  # description:
  #   method exports words and synonyms of a given project to a .xml file
  # params:
  #   project_id
  # success:
  #   data exported successfully
  # failure:
  #   project does not exist, not registered developer, no words in project.
  def export_to_xml
    @project_id = params[:project_id]
    if Project.find(@project_id) != nil
      @exported_data = PreferedSynonym.where(project_id: @project_id).all
      xml_string = "<project_data> "
      if @exported_data != []
        @exported_data.each do |word|
          @keyword = Keyword.find(word.keyword_id).name
          @synonym = Synonym.find(word.synonym_id).name
          xml_string << " <word>" + @keyword +
          "</word>  <translation>" + @synonym + "</translation>"
        end
        xml_string << " </project_data>"
      else
        flash[:notice] = t(:no_words)
        redirect_to project_path(@project_id), flash: flash
        return
      end
      send_data xml_string ,
      type: "text/xml; charset=UTF-8;",
      disposition: "attachment; filename=project_data.xml"
    else
      flash[:notice] = t(:no_project)
      redirect_to projects_path, flash: flash
    end
  end

  # Author:
  #   Noha Hesham
  # Description:
  #   Finds the developer and the project by their ids
  #   and removes the developer from the developers_shared
  #   array, removing the project from the developer's
  #   shared projects
  # Params:
  #   dev_id is the id of the developer
  #   project_id is the id of the project
  # Success:
  #   Project is removed from shared projects
  # Failure:
  #   Project is not removed
  def remove_project_from_developer
    dev = Developer.find(params[:dev_id])
    project = Project.find(params[:project_id])
    dev.projects_shared.delete(project)
    dev.save
    flash[:success] = t(:project_removed)
    redirect_to :action => "index",:controller => "projects"
  end

  # author:
  #   Khloud Khalid
  # description:
  #   method exports words and synonyms of a given project to a .json file
  # params:
  #   project_id
  # success:
  #   data exported successfully
  # failure:
  #   project does not exist, not registered developer, no words in project.
  def export_to_json
    @project_id = params[:project_id]
    if Project.find(@project_id) != nil
      @exported_data = PreferedSynonym.where(project_id: @project_id).all
      json_string = "{   "
      if @exported_data != []
        @exported_data.each do |word|
          if(word == @exported_data.first)
            @keyword = Keyword.find(word.keyword_id).name
            @synonym = Synonym.find(word.synonym_id).name
            json_string << "\"word\": \"" +
            @keyword + "\", \"translation\": \"" + @synonym + "\""
          else
            @keyword = Keyword.find(word.keyword_id).name
            @synonym = Synonym.find(word.synonym_id).name
            json_string << ", \"word\": \"" +
            @keyword + "\", \"translation\": \"" + @synonym + "\""
          end
        end
        json_string << "   }"
      else
        flash[:notice] = t(:no_words)
        redirect_to project_path(@project_id), flash: flash
        return
      end
      send_data json_string ,
      type: "text/json; charset=UTF-8;",
      disposition: "attachment; filename=project_data.json"
    else
      flash[:notice] = t(:no_project)
      redirect_to projects_path, flash: flash
    end
  end
end
