begin
  Entry.send_email_on_late_submission
rescue => e
  raise e.message
end