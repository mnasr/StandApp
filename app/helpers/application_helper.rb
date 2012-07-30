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
end