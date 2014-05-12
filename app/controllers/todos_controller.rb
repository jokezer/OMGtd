class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_todo, only: [:show, :update, :destroy, :change_prior]
  layout 'loggedin'
  layout 'single_page', only: [:index]

  def index
    @todos = current_user.todos
    .to_json(methods: [:schedule_label, :due_seconds, :updated_seconds,
                       :can_increase_prior?, :can_decrease_prior?])
    respond_to do |format|
      format.html
      format.json   { render :json => @todos }
    end
  end

  def show
  end

  def new
    @todo = current_user.todos.new
  end

  def create
    @todo = current_user.todos.build(todo_params)
    render(new_todo_path) and return unless @todo.save
    create_project and return if params[:make_project]
    # todo_success('Todo created!')
    respond_to do |format|
      format.html
      format.json   { render :json => @todo.to_json(methods: [:schedule_label,
                                                              :due_seconds,
                                                              :can_increase_prior?,
                                                              :can_decrease_prior?]) }
    end

  end

  def update
    @todo.update_attributes(todo_params)
    respond_to do |format|
      format.json   { render :json => @todo.to_json(methods: [:schedule_label,
                                                              :due_seconds,
                                                              :can_increase_prior?,
                                                              :can_decrease_prior?]) }
    end
  end

  def destroy
    @todo.destroy if @todo.can_delete?
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