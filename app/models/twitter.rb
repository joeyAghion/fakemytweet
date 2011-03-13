#require 'typhoeus'
require 'json'
require 'cgi'

module Twitter

  REQUEST_TIMEOUT_MS = 10_000
  MAX_PER_PAGE = 200
  MAX_TWEETS = 600
  MAX_PAGES = (MAX_TWEETS / MAX_PER_PAGE.to_f).ceil
  API_URLS = {
    :user_timeline           => "http://api.twitter.com/1/statuses/user_timeline.json",
    :suggestion_categories   => "http://api.twitter.com/1/users/suggestions.json",
    :suggestions             => "http://api.twitter.com/1/users/suggestions/{slug}.json"
  }
  CONSUMER_KEY = "wio3W9wDNmeV1fUX0xX1g"
  CONSUMER_SECRET = "JWNde3dtRv4d55rXge5yA48ajxKQvPmzCDKC7WLFbSg"
  OAUTH_TOKEN = "16026877-Mr9cdVM7PGAUbRmsecWnKPVslML52L7CS1A6OEK5j"
  OAUTH_TOKEN_SECRET = "idUuFbokpiGQ4Xm2h3LHyi4Up19ikiJOwg2Kl7AMs14"

  def self.user_timeline(screen_name, count = MAX_TWEETS, skip_user = true)
    pages = []
    begin
      pages << request(:user_timeline, 'screen_name' => screen_name, 'count' => MAX_PER_PAGE, 'skip_user' => skip_user, 'page' => pages.size+1)
    end while !pages.empty? && !pages.last.empty? && pages.size < MAX_PAGES
    pages.flatten
  end
  
  def self.suggestions
    returning([]) do |results|
      request(:suggestion_categories).each do |category|
        results << request(:suggestions, 'slug' => category['slug'])
      end
    end
  end
  
private
  
  def self.request(endpoint, params = {})
    # url = API_URLS[endpoint].gsub(/\{[^}]+\}/){|s| params[s.tr('{}', '')] }
    # response = Typhoeus::Request.get(url, :params => params, :timeout => REQUEST_TIMEOUT_MS)
    # return nil if response.code >= 400 && response.code <= 499
    # raise "Error accessing Twitter API #{endpoint.to_s} (response code #{response.code rescue '(none)'})." unless response.success?
    
    url = API_URLS[endpoint].concat("?" + params.collect{|k,v| "#{k}=#{CGI::escape(v.to_s)}"}.join('&'))
    # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
    access_token = prepare_access_token(OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
    # use the access token as an agent to get the home timeline
    response = access_token.request(:get, url)
    code = response.code.to_i
    return nil if code >= 400 && code <= 499
    raise "Error accessing Twitter API #{endpoint.to_s} (response code #{response.code rescue '(none)'})." unless code == 200
    
    JSON.parse(response.body)
  end

  def self.prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
      :site => "http://api.twitter.com", :scheme => :header
    })
    token_hash = {:oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret}
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end
end
