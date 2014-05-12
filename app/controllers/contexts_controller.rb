class ContextsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context, only: [:update, :destroy]
  layout 'loggedin'

  def index
    @contexts = current_user.contexts.ordering
    respond_to do |format|
      format.html
      format.json   { render :json => current_user.contexts.make_group }
    end
  end

  def new
    @context = current_user.contexts.new
    render :edit
  end

  def create
    @context = current_user.contexts.build(context_params)
    if @context.save
      flash[:success] = 'Context created!'
      redirect_to contexts_path
    else
      render :edit
    end
  end

  def show
    @context = current_user.contexts.by_name(params[:name])
    redirect_to root_path and return unless @context #todo make it :before function?
    @todos = @context.todos.active.ordering
    # .paginate(:page => params[:page])
    render 'todos/list'
  end

  def edit
    @context = current_user.contexts.by_name(params[:name])
    redirect_to root_path and return unless @context #todo make it :before function?
  end

  def update
    if @context.update_attributes(context_params)
      flash[:success] = 'Context updated!'
      redirect_to contexts_path
    else
      render :edit
    end
  end

  def destroy
    @context.destroy
    flash[:success] = 'Context deleted!'
    redirect_to contexts_path
  end

  private

  def context_params
    params.require(:context).permit(:name)
  end

  def get_context
    @context = current_user.contexts.find(params[:name])
    redirect_to '/todos/contexts/' unless @context
  end

end