class UsersController < ApplicationController
  include ParseHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  before_filter :authorize_user_index, :only => [:index, :show]
  before_filter :authorize_user_edit, :only => [:edit]
  
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
    authorize! :assign_roles, current_user if params[:user][:assign_roles]
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
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
    @user = User.find params[:id]
    authorize! :assign_roles, current_user if params[:user][:assign_roles]
    if request.patch? && params[:user] && params[:user][:email]
      if @rails_user.update(user_params)
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

  def migrate_from_parse
    etl_for_parse(current_user.id)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :first_name, :last_name, :email, roles: [], clients: [] ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
