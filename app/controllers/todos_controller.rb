class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @todos = current_user.todos.paginate(:page => params[:page])
  end

  def show
    @todo = current_user.todos.find_by_id(params[:id])
    unless @todo
      redirect_to root_path
      return
    end
  end


  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      flash[:success] = "Todo created!"
      redirect_to todos_path + '/status/' + Todo::STATUSES[@todo[:status]].to_s #todo refactor it
    else
      @feed_items = []
      render new_todo_path
    end
  end

  def update
    @todo = current_user.todos.find_by_id(params[:id])
    unless @todo
      redirect_to root_path
      #render status: 401
      return
    end
    if @todo.update_attributes(todo_params)
      flash[:success] = "Todo updated!"
      redirect_to todos_path + '/status/' + Todo::STATUSES[@todo[:status]].to_s #todo refactor it
    else
      render 'show'
    end
  end

  def destroy
    @todo = current_user.todos.find_by_id(params[:id])
    if @todo
      @todo.destroy if [:trash, :completed].include? @todo.status_label
    end
    redirect_to root_url
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :status, :content)
  end

end















