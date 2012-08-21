class Users::AbsencesController < ApplicationController
  # GET /absences
  # GET /absences.json
  def index
    @absences = Absence.where(user_id: params[:user_id])
    @absences = Absence.paginate(:page => params[:page], :order => "created_at DESC")
    @title = "Absences"
    respond_to do |format|
      format.html { render :file => "absences/index"}
      format.json { render json: @absences }
    end
  end

  # GET /absences/1
  # GET /absences/1.json
  def show
    @absence = Absence.where(id: params[:id], user_id: params[:user_id])
    @title = "User #{@absence.user_id} Absence"   
    respond_to do |format|
      format.html { render :file => "absences/show"}
      format.json { render json: @absence }
    end
  end
end