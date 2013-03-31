class UserMailer < ActionMailer::Base
  default from: "arability.smartsoft@gmail.com"

  def generic_email(mail_to,reason,message)
    mail to: mail_to, subject: reason, body:message
  end

  def follow_notification(developer, keyword, synonym)
    subject = "A new meaning for #{keyword.name} has been found"
    @keyword = keyword
    @synonym = synonym
    @developer = developer
    mail to: developer.gamer.email, subject: subject
  end

  def invite(email, developer)
    subject = "You have been invited to arability"
    @developer = developer
    mail to: email, subject: subject
  end
end
