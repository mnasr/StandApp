module EntriesHelper
	def format_ticket_id_to_url(ticket_id = nil)
		if ticket_id.blank?
			return ""
		end
		ticket_url = "http://dev.nuserv.com/issues/"
		ticket_url = ticket_url + ticket_id.to_s
		ticket_url
	end
end
