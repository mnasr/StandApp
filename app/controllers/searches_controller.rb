class SearchesController < ApplicationController
  def search
    @title = "Search results"
    @keywords = params[:search]
    @results = Hash.new
    if @keywords.present?
      search_keywords = "%#{@keywords}%"
      @results[:user] = User.where("email LIKE ? OR fullname LIKE ?", search_keywords, search_keywords).all.flatten.compact
      @results[:entry] = Entry.where("description LIKE ?", search_keywords).all.flatten.compact
      @results[:absence] = Absence.where("description LIKE ?", search_keywords).all.flatten.compact
    end

    render :action => :show, :locals => {:results => @results, :keywords => @keywords}
  end

  def show
    @title = "Search results"
  end
end