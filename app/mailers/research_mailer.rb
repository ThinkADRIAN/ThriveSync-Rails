class ResearchMailer < ActionMailer::Base
  default from: MAILER_FROM_ADDRESS

  def research_week_4_primary(recipient)
    @recipient = recipient
    mail(to: @recipient.email, subject: 'ThriveSync Research Updates - Week 4')
  end
end