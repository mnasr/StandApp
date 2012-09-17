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

  def linkify_ticket_ids(entry)
    tickets_links = []
    links = entry.extract_ticket_number_from_description
  	links.each do |link|
      tickets_links << link_to(link,format_ticket_id_to_url(link))
    end
    tickets_links.join(', ')
  end

  def linkify_categories(entry)
  	categories_links = []
    links = entry.extract_category_from_description
    links.each do |link|
      categories_links << "<a href=\'#{Settings.application_url}/search/search?search=#{link}\'>#{link}</a>"
    end
    categories_links.join(", ")
  end
end
