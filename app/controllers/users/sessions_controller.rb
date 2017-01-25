class Users::SessionsController < Devise::SessionsController
  def create
    if verify_rucaptcha?
      super
    else
      redirect_to :back
    end
  end
end
