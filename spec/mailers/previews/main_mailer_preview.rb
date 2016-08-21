# Preview all emails at http://localhost:3000/rails/mailers/main_mailer
class MainMailerPreview < ActionMailer::Preview
  def invitation_to_connect_preview
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

    MainMailer.invitation_to_connect(recipient, sender)
  end
end