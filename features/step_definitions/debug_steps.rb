When /^I debug (?:the) test$/ do
  require "rubygems"; require "ruby-debug"; debugger
  1 #intentionally force debugger context in this method
end
