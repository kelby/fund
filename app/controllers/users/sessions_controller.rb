class Users::SessionsController < Devise::SessionsController
  def create
    if verify_rucaptcha?
      super
    else
      redirect_back fallback_location: new_user_session_path
    end
  end
end
