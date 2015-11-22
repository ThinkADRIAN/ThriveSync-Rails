class MainMailer < ActionMailer::Base
  default from: MAILER_FROM_ADDRESS

  def invitation_to_connect(recipient, sender)
    @recipient = recipient
    @sender = sender
    mail(to: @recipient.email, subject: 'Invitation to Connect')
  end
end