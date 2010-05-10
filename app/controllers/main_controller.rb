class MainController < ApplicationController
  before_filter :load_tweeter
  
  def index
  end
  
  def create
    begin
      @tweeter.load_tweets if @tweeter.valid?
    rescue Timeout::Error => ex
      flash.now[:notice] = "We didn't hear back from Twitter in time. Try again later."
    rescue => ex
      flash.now[:notice] = 'Whoops - There was a problem. Try again later.'
    end
    
    render :action => 'index'
  end
  
  private
  
  def load_tweeter
    @tweeter = Tweeter.new(params.slice(:screen_name))
  end
end
