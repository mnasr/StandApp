module ApplicationHelper
	def display_error(incoming_object)
		error_message = ""
  	if incoming_object.errors.any?
	    error_message << "<div id='error_explanation'><h2>"
	    error_message << pluralize(incoming_object.errors.count, "error")
	    error_message << "prohibited this entry from being saved:</h2>"
	    error_message << "<ul>"

      incoming_object.errors.full_messages.each do |msg|
        error_message << "<li>" + msg + "</li>"
      end

      error_message << "</ul></div>"
  	end
  	error_message
	end
  
  def display_no_records(object_type = "")
    object_type.blank? ? msg = "" : msg = " for <strong>#{object_type}</strong>"
    content_tag(:div, "There are no records found#{msg}".html_safe, :id => "alert", :class => "alert alert-error")
  end
  
  def back_button
    link_to('<i class="icon-arrow-left icon-white"></i> Back to previous page'.html_safe, :back, :class => 'btn')
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    Redcarpet.new(text, *options).to_html.html_safe
  end
end