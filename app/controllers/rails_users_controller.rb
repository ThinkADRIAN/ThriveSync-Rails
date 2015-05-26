class RailsUsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  before_filter :authorize_rails_user_index, :only => [:index, :show]
  before_filter :authorize_rails_user_edit, :only => [:edit]
  
  def new
  end

   # GET /users/:id.:format
  def show
    # authorize! :read, @rails_user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @rails_user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @rails_user
    authorize! :assign_roles, current_rails_user if params[:rails_user][:assign_roles]
    respond_to do |format|
      if @rails_user.update(user_params)
        sign_in(@rails_user == current_rails_user ? @rails_user : current_rails_user, :bypass => true)
        format.html { redirect_to @rails_user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rails_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @rails_user 
    @rails_user = RailsUser.find params[:id]
    authorize! :assign_roles, current_rails_user if params[:rails_user][:assign_roles]
    if request.patch? && params[:rails_user] && params[:rails_user][:email]
      if @rails_rails_user.update(user_params)
        @rails_user.skip_reconfirmation!
        sign_in(@rails_user, :bypass => true)
        redirect_to @rails_user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @rails_user
    @rails_user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @rails_user = RailsUser.find(params[:id])
    end

    def user_params
      accessible = [ :first_name, :last_name, :email, roles: [], clients: [] ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:rails_user][:password].blank?
      params.require(:rails_user).permit(accessible)
    end
end
