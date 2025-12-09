# Minimal Puma::Server subclass with custom handle_request
require 'puma/server'

class PumaCustomServer < Puma::Server
  # Override handle_request to add custom logic
  def handle_request(client, buffer)
    # Custom logging or logic here
    puts "Custom handle_request called for client: ", client
    # Call the original implementation
    super(client, buffer)
  end
end

# Usage example (not active in Rails by default):
# app = Proc.new { |env| [200, {"Content-Type" => "text/plain"}, ["Hello from PumaCustomServer!"]] }
# server = PumaCustomServer.new(app)
# server.add_tcp_listener('0.0.0.0', 9292)
# server.run
