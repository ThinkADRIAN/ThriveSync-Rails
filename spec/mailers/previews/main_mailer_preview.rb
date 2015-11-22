# Preview all emails at http://localhost:3000/rails/mailers/main_mailer
class MainMailerPreview < ActionMailer::Preview
  def invitation_from_pro_preview
    users = User.all
    recipient = User.find(3)
    sender = User.find(2)

    users.each do |user|
      if user.is? :user
        #return recipient << user
      end
    end

    users.each do |user|
      if user.is? :pro
        #return sender << user
      end
    end

    MainMailer.invitation_from_pro(recipient, sender)
  end
end