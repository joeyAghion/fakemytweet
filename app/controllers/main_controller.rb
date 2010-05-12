class MainController < ApplicationController
  before_filter :load_tweeter
  
  def index
  end
  
  def create
    begin
      if @tweeter.valid?
        if tweets = @tweeter.load_tweets
          flash.now[:notice] = "#{params[:screen_name]} doesn't have enough tweets. Try a suggested user instead." if tweets.empty?
        else
          flash.now[:notice] = "We couldn't find that username. Try again, or select from the suggestions."
        end
      end
    rescue Timeout::Error => ex
      flash.now[:notice] = "We didn't hear back from Twitter in time. Try again later."
    rescue => ex
      flash.now[:notice] = 'Whoops - There was a problem. Try again later.'
      Rails.logger.info ex.message  # TODO propagate this somewhere
    end
    
    render :action => 'index'
  end
  
  private
  
  def load_tweeter
    @tweeter = Tweeter.new(params.slice(:screen_name))
  end
end
