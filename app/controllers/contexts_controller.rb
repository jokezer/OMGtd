class ContextsController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @contexts = current_user.contexts
  end

  def new
    @context = current_user.contexts.new
    render 'edit'
  end

  def create
    @context = current_user.contexts.build(context_params)
    if @context.save
      flash[:success] = 'Context created!'
      redirect_to contexts_path
    else
      render 'edit'
    end
  end

  def show
    context = current_user.contexts.by_name(params[:id])
    redirect_to root_path and return unless context #todo make it :before function?
    @todos = context.todos.paginate(:page => params[:page])
    render 'statuses/show'
  end

  def edit
    @context = current_user.contexts.find(params[:id])
    redirect_to root_path and return unless @context #todo make it :before function?
  end

  def update
    @context = current_user.contexts.find(params[:id])
    redirect_to "/todos/contexts/" and return unless @context
    if @context.update_attributes(context_params)
      flash[:success] = "Context updated!"
      redirect_to '/todos/contexts/'
    else
      render 'edit'
    end
  end

  def destroy
    @context = current_user.contexts.find(params[:id])
    @context.destroy
    flash[:success] = "Context deleted!"
    redirect_to contexts_path
  end

  private

  def context_params
    params.require(:context).permit(:name)
  end

end