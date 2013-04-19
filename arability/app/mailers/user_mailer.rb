class UserMailer < ActionMailer::Base
  default from: "arability.smartsoft@gmail.com"
  
  # Author:
  #   Mohamed Ashraf
  # Description:
  #   Sends a generic email to any address
  # params:
  #   mail_to: The receivers email address
  #   reason: The subject of the message
  #   message: The actual message body
  # success:
  #   returns a Message object that you can call on deliver to send the email
  # failure:
  #   this method doesnt fail
  def generic_email(mail_to, subject, message)
    mail to: mail_to, subject: subject, body: message
  end

  
  # Author:
  #   Mohamed Ashraf
  # Description:
  #   Sends a follow notification notice to a developer
  # Params:
  #   developer: instace of the developer model I amsending an email to
  #   keyword: instace of the keyword model that has a new synonym
  #   synonym: instance of the synonym model representing the newly found synonym
  # success:
  #   returns a Message object that you can call on deliver to send the email
  # failure:
  #   this method doesnt fail
  def follow_notification(developer, keyword, synonym)
    subject = "A new meaning for #{keyword.name} has been found"
    @keyword = keyword
    @synonym = synonym
    @developer = developer
    mail to: developer.gamer.email, subject: subject
  end

  # Author:
  #   Mohamed Ashraf
  # Describtion:
  #   Sends an invite to an email address
  # Params:
  #   email: the address of the invitee
  #   developer: instace of the developer model representing the inviter
  # success:
  #   returns a Message object that you can call on deliver to send the email
  # failure:
  #   this method doesnt fail
  def invite(email, developer)
    subject = "You have been invited to arability"
    @developer = developer
    mail to: email, subject: subject
  end
end
