class RailsUsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
  end

   # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    authorize! :assign_roles, @user if params[:user][:assign_roles]
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_rails_user ? @user : current_rails_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    @user = RailsUser.find params[:id]
    if request.patch? && params[:user] && params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = RailsUser.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email, :parse_user_id ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end

    def does_parse_user_exist
      current_parse_user = Parse::Query.new("_User").eq("email", @user.email).get.first
      current_parse_user != nil
    end

    def get_parse_user_id
      current_parse_user = Parse::Query.new("_User").eq("email", @user.email).get.first
    end

    def create_parse_user
      parse_user = Parse::User.new(
        {
          :username => @user.email,
          :email => @user.email
        }
      )
      parse_user.save
    end

    def set_parse_user_id
      current_parse_user = get_parse_user_id
      @user.parse_user_id = current_parse_user["objectId"] 
    end

    def set_parse_user_attributes
      current_parse_user = get_parse_user_id
      current_parse_user["email"] = @user.email
      current_parse_user["username"] = @user.email
      current_parse_user.save
    end

    def delete_parse_user
      current_parse_user = get_parse_user_id
      current_parse_user.parse_delete
    end
end
