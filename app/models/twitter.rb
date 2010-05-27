require 'typhoeus'

module Twitter

  REQUEST_TIMEOUT_MS = 10_000
  MAX_TWEETS = 200
  API_URLS = {
    :user_timeline           => "http://api.twitter.com/1/statuses/user_timeline.json",
    :suggestion_categories   => "http://api.twitter.com/1/users/suggestions.json",
    :suggestions             => "http://api.twitter.com/1/users/suggestions/{slug}.json"
  }

  def self.user_timeline(screen_name, count = MAX_TWEETS, skip_user = true)
    request(:user_timeline, 'screen_name' => screen_name, 'count' => count, 'skip_user' => skip_user)
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
    url = API_URLS[endpoint].gsub(/\{[^}]+\}/){|s| params[s.tr('{}', '')] }
    response = Typhoeus::Request.get(url, :params => params, :timeout => REQUEST_TIMEOUT_MS)
    return nil if response.code >= 400 && response.code <= 499
    raise "Error accessing Twitter API #{endpoint.to_s} (response code #{response.code rescue '(none)'})." unless response.success?
    JSON.parse(response.body)
  end

end