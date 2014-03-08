class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

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
    if @todo.save
      flash[:success] = "Todo created!"
      redirect_to "#{todos_path}/statuses/#{TodoStatus.label(@todo[:status_id]).to_s}"
    else
      @feed_items = []
      render new_todo_path
    end
  end

  def update
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path and return unless @todo
    if @todo.update_attributes(todo_params)
      flash[:success] = 'Todo updated!'
      redirect_to "#{todos_path}/statuses/#{TodoStatus.label(@todo[:status_id]).to_s}"
    else
      render 'show'
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

  def todo_params
    params.require(:todo).permit(:title, :status_id, :prior_id, :content, :expire, :context_id)
  end

end