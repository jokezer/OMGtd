class StaticPagesController < ApplicationController
  before_filter :authenticate_user!
  def home
  end

  def about
  end


  private

end
