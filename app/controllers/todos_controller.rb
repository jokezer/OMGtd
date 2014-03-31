class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_todo, only: [:show, :update, :destroy, :change_prior]
  layout 'loggedin'

  def index
    @todos = current_user.todos.get_index
  end

  def show
  end

  def filter
    @todos = current_user.todos.filter(params[:type], params[:type_name])
    redirect_to root_path and return unless @todos
    @todos = @todos.paginate(:page => params[:page])
    render 'todos/list'
  end

  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    render(new_todo_path) and return unless @todo.save
    create_project and return if params[:make_project]
    todo_success('Todo created!')
  end

  def update
    render(:show) and return unless @todo.update_attributes(todo_params)
    create_project and return if params[:make_project]
    @todo.activate if params[:activate]
    @todo.complete if params[:complete]
    @todo.cancel if params[:cancel]
    todo_success('Todo updated!')
  end

  def destroy
    if @todo.can_delete?
      @todo.destroy
      flash[:success] = 'Todo deleted!'
    end
    redirect_to root_path
  end

  # ajax actions
  def move
    params = move_params
    todo = current_user.todos.find(params[:todo_id])
    todo.move params[:group], params[:group_value], params[:due]
    #redirect_to :back
    flash[:todo_id] = todo.id
    redirect_to_back
  end

  def change_prior
    @todo.increase_prior if params[:increase_prior]
    @todo.decrease_prior if params[:decrease_prior]
    flash[:todo_id] = @todo.id
    #todo redirect to todo page
    redirect_to_back
  end

  private

  def todo_success(label)
    flash[:success] = label
    flash[:todo_id] = @todo.id
    redirect_to redirect_address
  end

  def redirect_address
    if @todo.active?
      "/todos/filter/kind/#{@todo.kind}"
    else
      "/todos/filter/state/#{@todo.state}"
    end
  end

  def create_project
    current_user.projects.make_from_todo(@todo)
    flash[:success] = 'Project created!'
    redirect_to projects_path
  end

  def todo_params
    params.require(:todo).permit(:title, :kind, :prior, :project_id,
                                 :content, :due, :context_id)
  end

  def move_params
    params.require(:move).permit(:todo_id, :group, :group_value, :due)
  end

  def get_todo
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path unless @todo
  end

  def redirect_to_back
    redirect_via_turbolinks_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

end