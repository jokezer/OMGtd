class TodosController < ApplicationController
  before_filter :authenticate_user!
  def all
  end

  def new
  end

  def edit
  end
end
