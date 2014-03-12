class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout 'loggedin'

  def index
    @today = current_user.todos.today
    @tomorrow = current_user.todos.tomorrow
    @next = current_user.todos.by_status(:next).later_or_no_deadline
  end

  def show
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path unless @todo
  end


  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    render(new_todo_path) and return unless @todo.save
    if params[:make_project]
      current_user.projects.make_from_todo(@todo)
      todo_success('Project created!')
    else
      todo_success('Todo created!')
    end
  end

  def update
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path and return unless @todo
    render(new_todo_path) and return unless @todo.update_attributes(todo_params)
    if params[:make_project]
      current_user.projects.make_from_todo(@todo)
      todo_success('Project created!')
    else
      todo_success('Todo updated!')
    end
  end

  def destroy
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_url and return unless @todo
    if [:trash, :completed].include? @todo.status
      @todo.destroy
      flash[:success] = 'Todo deleted!'
    end
    redirect_to root_url
  end

  private

  def todo_success(label)
    flash[:success] = label
    redirect_to "#{todos_path}/statuses/#{TodoStatus.label(@todo[:status_id]).to_s}"
  end

  def todo_params
    params.require(:todo).permit(:title, :status_id, :prior_id, :project_id,
                                 :content, :expire, :context_id, :is_deadline, :commit)
  end

end