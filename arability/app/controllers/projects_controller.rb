class ProjectsController < BackendController
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
        # @shared_projects = Project.joins(:shared_projects).where(:developer => developer.id)
        @shared_projects = Project.find_by_sql("SELECT * FROM projects INNER JOIN shared_projects ON projects.id = shared_projects.project_id WHERE shared_projects.developer_id = #{developer.id}")
      else
        flash[:notice] = "Please sign up as a developer first"
        render 'developers/new'
      end
    else
      flash[:notice] = "Please sign in"
      render 'pages/home'
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
    @num_synonyms_words_in_database_before = params[:a5]
    @num_synonyms_words_not_in_database_before = params[:a6]
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
      if message == 1
        flash[:notice] = "أنت لم تقم بإختيار ملف"
      end
      if message == 2
        flash[:notice] = "هذا الملف ليس بتقنية UTF-8"
      end
      if message == 3
        flash[:notice] = "يوجد خطأ بهذا الملف"
      end
      if message == 4
        flash[:notice] = "هذا الملف ليس CSV"
      end
      redirect_to action: "import_csv", id: params[:project_id]
    else
      id_words_in_database_before = Array.new
      id_synonyms_words_in_database_before = Array.new
      id_words_not_in_database_before = Array.new
      id_synonyms_words_not_in_database_before = Array.new
      num_synonyms_words_in_database_before = Array.new
      num_synonyms_words_not_in_database_before = Array.new
      arr_of_arrs.each do |row|
        keywrd = Keyword.find_by_name(row[0])
        if keywrd != nil
          if !PreferedSynonym.find_word_in_project(params[:project_id], keywrd.id)
            for i in 1..row.size
              Synonym.record_synonym(row[i],keywrd.id)
            end
            if !id_words_in_database_before.include?(row[0]) and !id_words_not_in_database_before.include?(row[0])
              counter = 0
              for i in 1..row.size
                synonm = Synonym.find_by_name(row[i], keywrd.id)
                if synonm != nil
                  counter = counter + 1
                  id_synonyms_words_in_database_before.push(synonm.id)
                end
              end
              if counter > 0
                id_words_in_database_before.push(keywrd.id)
                num_synonyms_words_in_database_before.push(counter)
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
              counter = 0
              for i in 1..row.size
                synonm = Synonym.find_by_name(row[i], keywrd.id)
                if synonm != nil
                  counter = counter + 1
                  id_synonyms_words_not_in_database_before.push(synonm.id)
                end
              end
              if counter > 0
                id_words_not_in_database_before.push(keywrd.id)
                num_synonyms_words_not_in_database_before.push(counter)
              end
            end
          end
        end
      end
      if id_words_in_database_before.empty? and id_words_not_in_database_before.empty?
        flash[:notice] = "لا يوجد كلمات بامكانك اضافتها إلى هذا المشروع"
        redirect_to action: "show", id: params[:project_id]
      else
        redirect_to action: "choose_keywords",id: params[:project_id], a1:id_words_in_database_before, a2:id_synonyms_words_in_database_before, a3:id_words_not_in_database_before, a4:id_synonyms_words_not_in_database_before, a5:num_synonyms_words_in_database_before, a6:num_synonyms_words_not_in_database_before
     end
    end
  end

  def import_csv
    current_project = Project.find(params[:id])
    @project_id = current_project.id
    @message = params[:message]
  end
end