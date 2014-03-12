class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  layout 'loggedin'

  def index
    @projects = current_user.projects
  end

  def show
    @project = current_user.projects.by_name(params[:label])
    redirect_to root_path and return unless @project
  end

end
