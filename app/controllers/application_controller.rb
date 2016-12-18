class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_action :fake_sign_in
  before_action :get_episode
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user?

  private
  def get_episode
    @episode ||= Episode.online.last
  end

  def get_today_recommend_projects
    episode = Episode.find_by(human_id: params[:id])

    if episode.blank?
      episode = get_episode
    end

    project_ids = episode.project_list.split(",")
    projects = Project.online.where(id: project_ids).order(recommend_at: :desc)

    @recommend_gems = projects.gemspec.limit(3)

    @recommend_pods = projects.pod.limit(3)
  end

  def current_user?(user)
    user_signed_in? && current_user == user
  end

  def fake_sign_in
    # sign_in(:user, User.find(1)) if !user_signed_in? && Rails.env.development?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
