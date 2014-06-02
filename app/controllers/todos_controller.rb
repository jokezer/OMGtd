class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_todo, only: [:show, :update, :destroy, :change_prior]
  layout 'single_page', only: [:spa, :old]

  def index
    sleep(rand(0.5..2)) if Rails.env.development?
    @todos = current_user.todos
    respond_to do |format|
      # format.html
      format.json   { render :json => @todos }
    end
  end

  def spa
  end

  def show
    sleep(rand(0.5..2)) if Rails.env.development?
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
    sleep(rand(0.5..2)) if Rails.env.development?
    @todo = current_user.todos.create(todo_params)
    respond_to do |format|
      format.json   { render :json => @todo }
    end
  end

  def update
    sleep(rand(0.5..2)) if Rails.env.development?
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
                                 :content, :due, :context_id, :state)
  end

  def get_todo
    @todo = current_user.todos.find_by_id(params[:id])
    redirect_to root_path unless @todo
  end

end