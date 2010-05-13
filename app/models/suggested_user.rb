class SuggestedUser < ActiveRecord::Base
  
  def self.load_suggested_users
    categories = Twitter.suggestions
    categories.each do |category|
      category['users'].each do |user|
        suggested_user = SuggestedUser.find_or_create_by_screen_name(user['screen_name'])
        suggested_user.category = category['name']
        suggested_user.attributes = user.slice('name', 'screen_name', 'profile_image_url', 'followers_count', 'description')
        suggested_user.save!
      end
    end
  end
  
  def self.top_suggested_users
    unless @top_suggested_users = Rails.cache.read('SuggestedUser/top_suggested_users')
      @top_suggested_users = all(:order => 'followers_count DESC', :limit => 200).
        sort_by{rand}[0..11].map{|u| {:screen_name => u.screen_name, :display_name => u.display_name} }
      Rails.cache.write('SuggestedUser/top_suggested_users', @top_suggested_users, :expires_in => 15.minutes) unless @top_suggested_users.empty?
    end
    @top_suggested_users
  end
  
  def display_name
    self.name || self.screen_name
  end
end
