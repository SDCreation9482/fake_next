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


# Direct call to handle_request for demonstration
server = PumaCustomServer.new(nil)
server.handle_request('demo_client', 'demo_buffer')
