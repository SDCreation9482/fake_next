# Minimal demo for ActionDispatch::Http::Headers#[] and #[]=
require 'action_dispatch/http/headers'

class CustomHeaders < ActionDispatch::Http::Headers
  # Override [] to add custom logic
  def [](key)
    puts "CustomHeaders: getting header '#{key}'"
    super(key)
  end

  # Override []= to add custom logic
  def []=(key, value)
    puts "CustomHeaders: setting header '#{key}' to '#{value}'"
    super(key, value)
  end
end

# Usage example:
# env = {}
# headers = CustomHeaders.new(env)
# headers['X-Test'] = 'demo'
# puts headers['X-Test']
