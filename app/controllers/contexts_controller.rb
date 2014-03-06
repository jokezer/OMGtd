class ContextsController < ApplicationController
  before_filter :authenticate_user!
  layout "loggedin"

  def index
    @contexts = current_user.contexts
  end

end
