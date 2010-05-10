require 'typhoeus'

class Tweeter
  TWITTER_API_URL = "http://api.twitter.com/1/statuses/user_timeline.json"
  REQUEST_TIMEOUT_MS = 10_000
  MAX_TWEETS = 200

  attr_accessor :screen_name, :tweets

  def initialize(params = {})
    @screen_name = params[:screen_name].tr('@', '') if params[:screen_name]
  end
  
  def valid?
    @screen_name.present?
  end
  
  def has_tweets?
    !@tweets.nil? && !@tweets.empty?
  end
  
  def tweet_text
    @tweets.collect{|tweet| "<tweet> #{tweet} </tweet>"}.join(" ")
  end
  
  def next_tweet
    raise "Can't generate tweet without inputs!" unless has_tweets?

    returning ("") do |sentence|
      chain = MarkovChain.new(tweet_text)
      word = "<tweet>"
      until word == "</tweet>" || sentence.length + word.length >= 148  # 140 + starting tag
        sentence << word << " "
        word = chain.get(word)
      end
      sentence.gsub!(/<tweet>/, '').strip!
    end
  end
  
  def load_tweets
    @tweets ||= cached_tweets
  end
  
  def cached_tweets
    unless cached = Rails.cache.read(tweets_cache_key)
      response = Typhoeus::Request.get(TWITTER_API_URL,
        :params => {'screen_name' => @screen_name, 'count' => MAX_TWEETS, 'skip_user' => true},
        :timeout => REQUEST_TIMEOUT_MS)
      raise "Error retrieving tweets (code: #{response.code rescue '(none)'})." unless response.success?
      cached = JSON.parse(response.body).collect{|s| s['text'] }
      Rails.cache.write(tweets_cache_key, cached, :expires_in => 1.hour) unless cached.empty?
    end
    return cached
  end
  
  protected
  
  def tweets_cache_key
    [self.class.name, 'tweets', screen_name].join(':')
  end
end
