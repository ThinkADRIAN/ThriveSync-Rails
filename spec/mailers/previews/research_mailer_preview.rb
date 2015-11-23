# Preview all emails at http://localhost:3000/rails/mailers/research_mailer
class ResearchMailerPreview < ActionMailer::Preview
  def research_week_4_primary_preview
    recipient = User.where("research_started_at < ?", 30.seconds.ago).first

    ResearchMailer.research_week_4_primary(recipient)
  end
end