class Users::RegistrationsController < Devise::RegistrationsController
  def create
    if verify_rucaptcha?
      super
    else
      redirect_to :back
    end
  end
end