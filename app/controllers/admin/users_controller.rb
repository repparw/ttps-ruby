module Admin
  class UsersController < Admin::BaseController
    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_user_path(@user), notice: "User was successfully created."
      else
        render :new
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params.except(:password, :password_confirmation).merge(password_params))
        redirect_to admin_user_path(@user), notice: "User was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully deleted."
    end

    private

    def password_params
      params.require(:user).permit(:password, :password_confirmation).reject { |_, v| v.blank? }
    end

    def user_params
      params.require(:user).permit(:username, :email, :phone, :role, :password, :password_confirmation, :joined_at)
    end
  end
end
