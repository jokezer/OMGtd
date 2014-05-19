class ContextsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_context, only: [:show, :edit, :update, :destroy]
  layout 'loggedin'

  def index
    # sleep 3 if Rails.env.development?
    @contexts = current_user.contexts.ordering
    respond_to do |format|
      format.json   { render :json => current_user.contexts }
    end
  end

  # def new
  #   @context = current_user.contexts.new
  #   render :edit
  # end

  def create
    @context = current_user.contexts.create(context_params)
    respond_to do |format|
      format.json   { render :json => @context }
    end
  end


  def show
    respond_to do |format|
      format.json   { render :json => @context }
    end
  end

  def edit
    @context = current_user.contexts.find(params[:id])
    redirect_to root_path and return unless @context #todo make it :before function?
  end

  def update
    @context.update_attributes(context_params)
    respond_to do |format|
      format.json   { render :json => @context }
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
    @context = current_user.contexts.find_by_id(params[:id])
    redirect_to root_path unless @context
  end

end