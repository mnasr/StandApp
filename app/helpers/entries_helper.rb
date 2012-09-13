module EntriesHelper
	def format_ticket_id_to_url(ticket_id = nil)
		if ticket_id.blank?
			return ""
		end
		ticket_url = Settings.redmine_url
		ticket_url = ticket_url + ticket_id.to_s
		ticket_url
	end
  
  def all_users
    @users = User.all
  end

  def linkify(body)
    links = body.scan(/\#\d+/).map{|id| id.gsub(/#/,'')}
    ticket_url = Settings.redmine_url
    populated_links = ""
    links.each {|link| populated_links << link_to(link, "#{ticket_url}#{link}")}
    populated_links.html_safe
  end
end
