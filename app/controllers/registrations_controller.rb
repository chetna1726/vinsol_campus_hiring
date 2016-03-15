class RegistrationsController < Devise::RegistrationsController
  
  layout 'users', only: [:edit]

  def destroy
    resource.soft_delete
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

end
