module ControllerHelpers
  def login_with(user = double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => scope})
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    sign_in user
  end

  def login_super_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    super_user = FactoryGirl.create(:user)
    super_user.roles = ["superuser"]
    super_user.save
    sign_in super_user
  end
end