class MyDevise::InvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_user!
  # GET /resource/invitation/new
  def new
    super
  end

  # POST /resource/invitation
  def create
    invitee = User.find_by_email(params[:user][:email])

    # Handle if invitee account already exists and is not already an existing supporter
    if invitee != nil && !(invitee.is? :pro) && !(current_user.supporters.include? invitee.id.to_i)
      invitee.roles += ["supporter"]
      invitee.thrivers += [current_user.id.to_i]
      invitee.save!

      current_user.supporters += [invitee.id.to_i]
      current_user.save!
      current_user.friend_request(invitee)

      respond_to do |format|
        format.html { redirect_to after_invite_path_for(current_user), :flash => {:success => "Supporter Invititation sent to #{(params[:user][:email])}"} }
        format.json { render :json => @cards, status: 200 }
      end
      # Handle if invitee account already exists and is already an existing supporter
    elsif invitee != nil && !(invitee.is? :pro) && (current_user.supporters.include? invitee.id.to_i)
      respond_to do |format|
        format.html { redirect_to new_user_invitation_path, :flash => {:error => "This email is associated to an existing supporter."} }
        format.json { render :error => "This email is associated to an existing supporter." }
      end
      # Handle if invitee account is a pro
    elsif invitee != nil && (invitee.is? :pro)
      respond_to do |format|
        format.html { redirect_to :back, :flash => {:error => "Mental Health Providers cannot be invited as a peer supporter."} }
        format.json { render :error => "Mental Health Providers cannot be invited as a peer supporter." }
      end
      # Default invitation for new users
    else
      super
    end
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

      # Add Supporter Role to user and remove User Role
      #current_user.roles += ["supporter"]
      #current_user.roles -= ["user"]
      #current_user.save!

      # Add Supporter Role to user and add inviter to Supporters thriver list
      current_user.roles += ["supporter"]
      current_user.thrivers += [inviter.id.to_i]
      current_user.save!

      # Create Supporter Relationship
      current_user.friend_request(inviter)
      inviter.accept_request(current_user)
    end
  end

  # GET /resource/invitation/remove?invitation_token=abcdef
  def destroy
    super
  end
end