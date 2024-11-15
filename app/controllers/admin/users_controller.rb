module Admin
  class UsersController < Admin::BaseController
    before_action :authorize_user
    before_action :set_user, only: [ :show, :edit, :update, :destroy, :soft_delete, :restore ]

    def index
      @users = User.all
    end

    def show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if current_user.admin? || (user_params[:role] != "admin")
        if @user.save
          redirect_to admin_user_path(@user), notice: "User was successfully created."
        else
          render :new
        end
      else
        @user.errors.add(:role, "You are not authorized to assign the admin role.")
        render :new
      end
    end

    def edit
    end

    def update
      if current_user.admin? || (user_params[:role] != "admin")
        if @user.update(user_params.except(:password, :password_confirmation).merge(password_params))
          redirect_to admin_user_path(@user), notice: "User was successfully updated."
        else
          render :edit
        end
      else
        @user.errors.add(:role, "You are not authorized to assign the admin role.")
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User was successfully deleted."
    end

    def soft_delete
      @user.soft_delete
      redirect_to admin_users_path, notice: "User was successfully deactivated."
    end

    def restore
      @user.restore
      redirect_to admin_users_path, notice: "User was successfully restored."
    end

    private

    def authorize_user
      unless current_user.manager? || current_user.admin?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation).reject { |_, v| v.blank? }
    end

    def user_params
      permitted_params = [ :username, :email, :phone, :password, :password_confirmation, :joined_at ]
      permitted_params << :role if current_user.manager? || current_user.admin?
      params.require(:user).permit(permitted_params)
    end
  end
end
