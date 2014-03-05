class StatusController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"
  def show
    @todos = current_user.todos.by_status(params[:status])
    .order('updated_at DESC') #default scope does not work in postgresql
    .paginate(:page => params[:page])
  end
end
