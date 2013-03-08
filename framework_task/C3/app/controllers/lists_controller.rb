class ListsController < ApplicationController
  # GET /lists
  # GET /lists.json
  
  def index
    @lists = List.where(:oid => current_user.id)
    #lists.each do |m|
    #m.thearray.each do |n|
     # if m.thearray.find(params[:id]==current_user.id
        #redirect_to(/lists/)
      #  print "#{m.thearray[n]}"
      #end
    #end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lists }
    end
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @list = List.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.json
  def new
    @list = List.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(params[:list])
    @list.oid = current_user.id
    @list.save

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render json: @list, status: :created, location: @list }
      else
        format.html { render action: "new" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.json
  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url }
      format.json { head :no_content }
    end
  end
  
  # lists/1/share

  def share
    @list = List.find(params[:list_id])
  end

  def share_list
    username = params[:email]
    list_id = params[:list_id]

    if (username == "") || (User.where(:email => username).count() < 1) \
      || (User.where(:email => username).count() > 1)
        flash[:notice] = "You have entered an invalid username"
        redirect_to("/lists/#{list.id}/share")
    else
      list = List.find(list_id)
      new_member = User.where(:email => username)[0]
      list.thearray.push(new_member.id)
      list.save

      redirect_to("/lists/#{list.id}")
    end
  end
end
