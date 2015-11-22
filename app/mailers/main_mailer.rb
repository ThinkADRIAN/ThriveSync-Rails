class MainMailer < ActionMailer::Base
  default from: MAILER_FROM_ADDRESS

  def invitation_from_pro(thriver, pro)
    @thriver = thriver
    @pro = pro
    mail(to: @thriver.email, subject: 'Invitation to Connect to Provider')
  end
end