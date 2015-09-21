class MyDevise::InvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_user!
  # GET /resource/invitation/new
  def new
    super
  end

  # POST /resource/invitation
  def create
    super
  end

  # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    super
  end

  # PUT /resource/invitation
  def update
    super

    if current_user.invitation_accepted_at != nil
      # Add user to Thriver's supporter list
      inviter = current_user.invited_by
      inviter.supporters += [current_user.id.to_i]
      inviter.save!
    end
  end

  # GET /resource/invitation/remove?invitation_token=abcdef
  def destroy
    super
  end
end