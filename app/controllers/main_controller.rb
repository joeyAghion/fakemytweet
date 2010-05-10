class MainController < ApplicationController
  before_filter :load_tweeter
  
  def index
  end
  
  def create
    @tweeter.load_tweets if @tweeter.valid?
    render :action => 'index'
  end
  
  private
  
  def load_tweeter
    @tweeter = Tweeter.new(params.slice(:screen_name))
  end
end
