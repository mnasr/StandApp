class EntriesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:welcome]
  
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.paginate(:page => params[:page], :order => "created_at DESC")
    @title   = "Listing entries"
    @entry_months = @entries.group_by { |e| e.created_at.beginning_of_month }
  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @entries }
    end
  end 
 
  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id], :order => "created_at DESC")
    @title = "Entry #{@entry.id} for  #{@entry.created_at.strftime('%A %d %B %Y')}"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @entry }
    end 
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    @title = "New entry"
    @entry.description = "### Yesterday: ###\n\n* \n* \n* \n\n### Today: ###\n\n* \n* \n* \n\n\n### Roadblocks: please write none if there is nothing ###\n\n* \n* \n* \n"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @entry }
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    params[:entry][:user_id] = current_user.id unless params[:entry].key?(:user_id)

    @entry = Entry.new(params[:entry])
    @title = "New entry"

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, :notice => 'Entry was successfully created.' }
        format.json { render :json => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "new" }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to @entry, :notice => 'Entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, :notice => 'Entry was deleted successfully.' }
      format.json { head :no_content }
    end
  end
  
  def welcome
    
  end
end
