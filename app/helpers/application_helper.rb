module ApplicationHelper
  def page_title
    "#{@tweeter.screen_name + " - " if @tweeter && @tweeter.screen_name.present?}Fake My Tweet"
  end
end
