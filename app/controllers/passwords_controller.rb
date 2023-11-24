class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, except: %i[index new create]
  before_action :require_editable_permission, only: %i[edit update]
  before_action :require_deleteable_permission, only: :destroy

  def index
    @passwords = current_user.passwords
  end

  def show; end

  def new
    @password = Password.new
  end

  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)

    respond_to do |format|
      if @password.save
        format.html { redirect_to @password, notice: "Added #{@password.url}" }
        # format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end

  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end

  def require_editable_permission
    redirect_to @password unless current_user_password.editable?
  end

  def require_deleteable_permission
    redirect_to @password unless current_user_password.deleteable?
  end
end
