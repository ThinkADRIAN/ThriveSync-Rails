desc 'send digest week 4 research survey'
task send_research_week_4_primary_email: :environment do
  recipients = User.where("research_started_at > ? AND research_started_at < ?", 30.days.ago.beginning_of_day, 30.days.ago.end_of_day)

  if !recipients.empty?
    recipients.each do |recipient|
      ResearchMailer.research_week_4_primary(recipient).deliver!
    end
  end
end