class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project, only: [:show, :edit, :update, :filter,
                                             :destroy, :change_state]

  layout 'loggedin'

  def index
    @projects = {}
    @projects[:active] = current_user.projects.with_state(:active)
    @projects[:finished] = current_user.projects.with_state(:finished)
    @projects[:trash] = current_user.projects.with_state(:trash)
  end

  def show
    @todos = @project.todos.get_index
  end

  def edit
  end

  def filter
    @todos = @project.todos.filter(params[:type], params[:type_name])
    redirect_to root_path and return unless @todos
    @todos = @todos.paginate(:page => params[:page])
    @category_label = "#{@project.label} #{params[:type_name]} todos"
    render 'todos/list'
  end

  def update
    @project.update_attributes(project_params)
    flash.now[:success] = 'Project updated'
    redirect_to project_path @project.name
  end

  def change_state
    @project.finish if params[:finish] && @project.can_finish?
    @project.cancel if params[:cancel] && @project.can_cancel?
    @project.activate if params[:activate] && @project.can_activate?
    flash.now[:success] = 'Project updated'
    redirect_to projects_path
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
    @project = current_user.projects.by_name(params[:name])
    redirect_to root_path and return unless @project
  end
end