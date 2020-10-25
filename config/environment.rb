# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Slack.configure do |config|
  config.token = ENV['https://app.slack.com/client/T01DLC1CLSD/C01DDTPM4A0']
end
