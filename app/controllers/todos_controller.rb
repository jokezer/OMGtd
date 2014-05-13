class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_todo, only: [:show, :update, :destroy, :change_prior]
  # layout 'loggedin'
  layout 'single_page', only: [:index, :old]

  def index
    @todos = current_user.todos
    respond_to do |format|
      format.html
      format.json   { render :json => @todos }
    end
  end

  def show
    #dont use
    respond_to do |format|
      format.json   { render :json => @todo }
    end
  end

  def old
  end

  # def new
  #   @todo = current_user.todos.new
  #   respond_to do |format|
  #     format.json   { render :json => @todo }
  #   end
  # end

  def create
    @todo = current_user.todos.create(todo_params)
    respond_to do |format|
      format.json   { render :json => @todo }
    end

  end

  def update
    @todo.update_attributes(todo_params)
    respond_to do |format|
      format.json   { render :json => @todo }
    end
  end

  #todo refactor it
  def destroy
    if @todo.can_delete?
      @todo.destroy
      response = 'true'
    else
      response = 'false'
    end
    respond_to do |format|
      format.json   { render :json => response }
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :kind, :prior, :project_id,
                                 :content, :due, :context_id)
  end

  def get_todo
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path unless @todo
  end

end