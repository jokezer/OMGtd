class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project, only: [:show, :edit, :update, :filter,
                                             :destroy, :change_state]

  layout 'loggedin'

  def index
    @projects = current_user.projects
    respond_to do |format|
      format.json   { render :json => current_user.projects }
    end
  end

  def show
    respond_to do |format|
      format.json   { render :json => @project }
    end
  end

  def edit
  end

  def update
    sleep(rand(0.5..2)) if Rails.env.development?
    @project.update_attributes(project_params)
    respond_to do |format|
      format.json   { render :json => @project }
    end
  end

  def destroy
    @project.destroy
    flash[:success] = 'Project deleted!'
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :name, :content, :prior)
  end

  def get_project
    @project = current_user.projects.find_by_id(params[:id])
    redirect_to root_path and return unless @project
  end
end