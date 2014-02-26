class TodosController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @todos = current_user.todos.paginate(:page => params[:page])
  end

  def status
    @todos = current_user.todos.by_status(params[:status])
    .paginate(:page => params[:page])

    #.where("status = ?", params[:status])

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
      redirect_to todos_path + '/status/' + Todo::STATUSES[params[:todo][:status].to_i].to_s #todo refactor it
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
