def tweet_url_regex_for(screen_name)
  %r|http://api\.twitter\.com/1/statuses/user_timeline\.json.+screen_name=#{screen_name}|
end

Given /^"([^\"]*)" has tweeted "([^\"]*)"$/ do |screen_name, tweet|
  @fake_tweets ||= {}
  @fake_tweets[screen_name] ||= []
  @fake_tweets[screen_name] << tweet

  response = Typhoeus::Response.new(:code => 200, :headers => '', :body => @fake_tweets[screen_name].map{|t| {'text' => t} }.to_json)
  Typhoeus::Hydra.hydra.stub(:get, tweet_url_regex_for(screen_name)).and_return(response)
end

Given /^"([^\"]*)" has no tweets$/ do |screen_name|
  response = Typhoeus::Response.new(:code => 200, :body => [].to_json)
  Typhoeus::Hydra.hydra.stub(:get, tweet_url_regex_for(screen_name)).and_return(response)
end

When /^(?:|I )fill in "([^\"]*)" with the non-existent screen-name "([^\"]*)"$/ do |field, screen_name|
  fill_in(field, :with => screen_name)
  response = Typhoeus::Response.new(:code => 404)
  Typhoeus::Hydra.hydra.stub(:get, tweet_url_regex_for(screen_name)).and_return(response)
  # FakeWeb.register_uri(:get, tweet_url_regex_for(screen_name), :status => ["404", "Not Found"])
end
