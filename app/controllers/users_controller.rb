class UsersController < ApplicationController
 
    before_filter :manage_editing_account_info, :only => [:edit, :update]
    before_filter :check_if_admin, :only => [:index, :show, :new, :create, :destroy]
    before_filter :check_if_scrum_master, :only =>  [:index]
  
  def index
   @users = User.paginate(:page => params[:page])
 
    respond_to do |format|
      format.html { render file: "users/index"}
      format.json { render json: @users } 
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end 
  end


  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end
  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to entries_path, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    begin
      @user.delete
      flash[:notice] = "User #{@user.fullname} deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private
  def check_if_admin
    unless current_user.admin?
      redirect_to entries_path, :alert => 'You are not allowed to access users content.'
    end
  end

  def check_if_scrum_master
    unless current_user.admin? || (current_user.is_scrum_master? && current_user.id != params[:id].to_i)    
      redirect_to entries_path, :alert => 'Only the scrum master is allowed to access users'
    end
  end

  def manage_editing_account_info
     if current_user.id.to_s != params[:id]
      redirect_to users_path, :alert => 'Only that user is allowed to edit his info'
    end
  end 
end
