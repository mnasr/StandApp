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

  def linkify_ticket_ids(body)
  	ticket_ids = body.scan(/\#\d+/).map{|id| id.gsub(/#/,'')}
  	links = []
    ticket_ids.each do |tid|
      links << link_to(tid, format_ticket_id_to_url(tid))
    end
    links.join(', ')
  end

  def linkify_categories(body)
  	cats = body.scan(/\(([^\)]+)\)/).collect { |element| element.count() ==  1 ? element[0] : element }
  	link = []
  	cats.each do |categories|
      categories = categories.split(",").map(&:strip)
      categories.each do |category|
        link << "<a href=\'http://#{Settings.application_url}/search/search?search=#{category}\'>#{category}</a>"
      end
    end
    link.join(', ')
  end
end
