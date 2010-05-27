# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    "#{@tweeter.screen_name + " - " if @tweeter && @tweeter.screen_name.present?}Fake My Tweet"
  end
end
