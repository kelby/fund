class Users::SessionsController < Devise::SessionsController
  def create
    if verify_rucaptcha?
      super
    else
      flash[:alert] = "验证码输入错误"

      redirect_back fallback_location: new_user_session_path
    end
  end
end
