class StatusesController < ApplicationController
  before_filter :authenticate_user!
  layout 'loggedin'
  def show
    @todos = current_user.todos.by_status(params[:label])
    .order('updated_at DESC') #default scope does not work in postgresql
    .paginate(:page => params[:page])
    render 'todos/list'
  end
end
