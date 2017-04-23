class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_rucaptcha?
      super
    else
      flash[:alert] = "验证码输入错误"

      redirect_back fallback_location: new_user_registration_path
    end
  end
end