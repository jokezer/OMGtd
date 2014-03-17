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

  def update
    @project = current_user.projects.find(params[:label])
    redirect_to root_path and return unless @project
    @project.update_attributes(project_params)
    flash.now[:success] = 'Project updated'
    render(:show) #todo fix redirect address
  end

  def destroy
    @project = current_user.projects.find(params[:label])
    @project.destroy
    flash[:success] = 'Project deleted!'
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :name, :content, :prior_id)
  end

end
