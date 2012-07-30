class MailReminder < ActionMailer::Base
  default from: "<depot@example.com>"


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mail_reminder.late.subject
  #
  def late(user)
   @user = user
   mail to: user.email, subject: "StandApp Reminder"
  end
end
