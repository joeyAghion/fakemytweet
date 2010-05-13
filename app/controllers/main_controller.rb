class MainController < ApplicationController
  before_filter :load_tweeter

  CRITICAL_TWEET_COUNT = 25

  helper_method :suggested_users
  
  def index
  end
  
  def create
    begin
      if @tweeter.valid?
        if tweets = @tweeter.load_tweets
          if tweets.empty?
            flash.now[:notice] = "#{params[:screen_name]} doesn't have enough tweets. Try a suggested user instead."
          elsif tweets.size < CRITICAL_TWEET_COUNT
            flash.now[:notice] = "#{params[:screen_name]} has very few tweets. Try the suggestions for a little variety."
          end
        else
          flash.now[:notice] = "We couldn't find that username. Try again, or select from the suggestions."
        end
      end
    rescue Timeout::Error => ex
      flash.now[:notice] = "We didn't hear back from Twitter in time. Try again later."
    rescue => ex
      flash.now[:notice] = 'Whoops - There was a problem. Try again later.'
      Rails.logger.info ex.message  # TODO propagate this somewhere
      Rails.logger.info ex.backtrace
    end
    
    render :action => 'index'
  end
  
  private

  def load_tweeter
    @tweeter = Twitter::Tweeter.new(params.slice(:screen_name))
  end
  
end
