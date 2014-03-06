class ContextsController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @contexts = current_user.contexts
  end

  def show
    context = current_user.contexts.by_name(params[:context])
    redirect_to root_path and return unless context
    @todos = context.todos.paginate(:page => params[:page])
    render 'statuses/show'
  end

end