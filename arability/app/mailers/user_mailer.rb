class UserMailer < ActionMailer::Base
  default from: "arability.smartsoft@gmail.com"

  # Sends a generic email to any address
  # params:
  #   mail_to: The receivers email address
  #   reason: The subject of the message
  #   message: The actual message body
  # returns:
  #   message: a mesage object that you can call on deliver to send the email
  def generic_email(mail_to,reason,message)
    mail to: mail_to, subject: reason, body:message
  end

  # Sends a follow notification notice to a developer
  # Author:
  #   Mohamed Ashraf
  # Params:
  #   developer: instace of the developer model I amsending an email to
  #   keyword: instace of the keyword model that has a new synonym
  #   synonym: instance of the synonym model representing the newly found synonym
  # returns:
  #   message: a mesage object that you can call on deliver to send the email
  def follow_notification(developer, keyword, synonym)
    subject = "A new meaning for #{keyword.name} has been found"
    @keyword = keyword
    @synonym = synonym
    @developer = developer
    mail to: developer.gamer.email, subject: subject
  end

  # Sends a follow notification notice to a developer
  # Author:
  #   Mohamed Ashraf
  # Params:
  #   email: the address of the invitee
  #   developer: instace of the developer model representing the inviter
  # returns:
  #   message: a mesage object that you can call on deliver to send the email
  def invite(email, developer)
    subject = "You have been invited to arability"
    @developer = developer
    mail to: email, subject: subject
  end
end
