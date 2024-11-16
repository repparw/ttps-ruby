module Admin
  class UsersController < Admin::BaseController
    before_action :authorize_user
    before_action :set_user, only: [ :show, :edit, :update, :destroy, :deactivate, :activate ]

    def index
      @users = User.all.page(params[:page]).per(10)
    end

    def show
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if current_user.admin? || (current_user.manager? && user_params[:role] != "admin")
        if @user.save
          redirect_to admin_user_path(@user), notice: "Usuario creado exitosamente."
        else
          render :new, alert: "No se pudo crear el usuario."
        end
      else
        @user.errors.add(:role, "No estás autorizado para asignar el rol de administrador.")
        render :new
      end
    end

    def edit
    end

    def update
      if current_user.admin? || (current_user.manager? && user_params[:role] != "admin")
        if @user.update(user_params.except(:password, :password_confirmation).merge(password_params))
          redirect_to admin_user_path(@user), notice: "Usuario actualizado exitosamente."
        else
          render :edit, alert: "No se pudo actualizar el usuario."
        end
      else
        @user.errors.add(:role, "No estás autorizado para asignar el rol de administrador.")
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "Usuario eliminado exitosamente."
    end

    def deactivate
      @user.soft_delete
      redirect_to admin_users_path, notice: "Usuario desactivado exitosamente."
    end

    def activate
      @user.restore
      redirect_to admin_users_path, notice: "Usuario restaurado exitosamente. Debes asignarle una nueva contraseña."
    end

    private

    def authorize_user
      unless current_user.manager? || current_user.admin? || ((action_name == "edit" || action_name == "show") && current_user == @user)
        redirect_to root_path, alert: "No estás autorizado para acceder a esta página."
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
      permitted_params.delete(:role) if current_user == @user
      permitted_params << :role if current_user.manager? || current_user.admin?
      params.require(:user).permit(permitted_params)
    end
  end
end
