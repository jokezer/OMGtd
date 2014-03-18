class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout 'loggedin'

  def index
    @today = current_user.todos.today
    @tomorrow = current_user.todos.tomorrow
    @next = current_user.todos.with_kind(:next).later_or_no_deadline
  end

  def show
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path unless @todo
  end

  def filter
    begin
      if params[:type] == 'state'
        @todos = current_user.todos.with_state(params[:label])
      elsif params[:type] == 'kind'
        @todos = current_user.todos.with_kind(params[:label])
      elsif params[:type] == 'calendar'
        @todos = current_user.todos.today if params[:label] == 'today'
        @todos = current_user.todos.tomorrow if params[:label] == 'tomorrow'
      end
      @todos = @todos.paginate(:page => params[:page]) if @todos
      render 'todos/list'
    rescue
      redirect_to root_path
    end
  end

  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    render(new_todo_path) and return unless @todo.save
    if params[:make_project]
      current_user.projects.make_from_todo(@todo)
      project_success('Project created!')
    else
      todo_success('Todo created!')
    end
  end

  def update
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path and return unless @todo
    render(:show) and return unless @todo.update_attributes(todo_params)
    if params[:make_project]
      current_user.projects.make_from_todo(@todo)
      project_success('Project created!')
    else
      todo_success('Todo updated!')
    end
  end

  def destroy
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path and return unless @todo
    if @todo.can_delete?
      @todo.destroy
      flash[:success] = 'Todo deleted!'
    end
    redirect_to root_path
  end

  private

  def todo_success(label)
    flash[:success] = label
    redirect_to "#{todos_path}/filter/kind/#{@todo.kind}"
  end
  def project_success(label)
    flash[:success] = label
    redirect_to projects_path
  end

  def todo_params
    params.require(:todo).permit(:title, :kind, :prior_id, :project_id,
                                 :content, :expire, :context_id, :is_deadline)
  end

end