class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @todos = current_user.todos.paginate(:page => params[:page])
  end

  def status
    @todos = current_user.todos
    .where("status = ?", params[:status])
    .paginate(:page => params[:page])
    render :index
  end

  def show
    @todo = current_user.todos.find(params[:id])
  end


  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      flash[:success] = "Todo created!"
      redirect_to todos_path + '/status/' + params[:todo][:status]
    else
      @feed_items = []
      render new_todo_path
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :status, :content)
  end

end
