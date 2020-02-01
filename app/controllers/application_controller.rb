class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    def after_sign_in_path_for(resource)
      case resource
      when Admin
        admin_items_path
      when EndUser
        public_end_user_path(current_end_user)
      end
    end

    def after_sign_out_path_for(resource)
      if resource == :admin
        new_admin_session_path
      else
        new_end_user_session_path
      end
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: 
                                            [:last_name, :first_name, :last_name_kana, 
                                            :first_name_kana, :postal_code, :address, 
                                            :phone_number, :status])
    end
end
