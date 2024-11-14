module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin_access
    
    layout 'admin'
    
    private
    
    def verify_admin_access
      unless current_user&.admin? || current_user&.manager? || current_user&.employee?
        redirect_to root_path, alert: 'Acceso no autorizado'
      end
    end
  end
end
