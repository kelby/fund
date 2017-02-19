class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_rucaptcha?
      super
    else
      redirect_back fallback_location: new_user_registration_path
    end
  end
end