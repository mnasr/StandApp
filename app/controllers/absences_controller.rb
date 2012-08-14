class AbsencesController < ApplicationController
  # GET /absences
  # GET /absences.json
  before_filter :check_if_admin_or_scrum_master, :only => [:edit, :update, :new, :create, :destroy]

  def index
    @absences = Absence.paginate(:page => params[:page], :order => "created_at DESC")
    @title = "Absences"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @absences }
    end 
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    @absence = Absence.find(params[:id])
    @title = "User #{@absence.user_id} Absence" 
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @absence }
    end
  end
 
  # GET /absences/new
  # GET /absences/new.json
  def new
    @absence = Absence.new
    @title = "New Absence"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @absence }
    end
  end

  # GET /absences/1/edit
  def edit
    @absence = Absence.find(params[:id])

  end

  # POST /absences
  # POST /absences.json
  def create
    @absence = Absence.new(params[:absence])
    @title = "New Absence"
    respond_to do |format|
      if @absence.save
        format.html { redirect_to @absence, notice: 'Absence was successfully created.' }
        format.json { render json: @absence, status: :created, location: @absence }
      else
        format.html { render action: "new" }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /absences/1
  # PUT /absences/1.json
  def update
    @absence = Absence.find(params[:id])

    respond_to do |format|
      if @absence.update_attributes(params[:absence])
        format.html { redirect_to @absence, notice: 'Absence was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /absences/1
  # DELETE /absences/1.json
  def destroy
    @absence = Absence.find(params[:id])
    @absence.destroy

    respond_to do |format|
      format.html { redirect_to absences_url }
      format.json { head :no_content }
    end
  end

  def today
    @absences = Absence.paginate(:page => params[:page]).today
    @title = "Absences"
    respond_to do |format|
      format.html 
      format.json { render json: @absences }
    end 
  end

  def check_if_admin_or_scrum_master
    unless current_user.admin? || current_user.is_scrum_master? && current_user.id != params[:id].to_i
      redirect_to entries_path, :alert => 'You are not allowed to access users content.'
    end
  end
end
 