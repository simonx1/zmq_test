require 'em-zeromq'

Thread.abort_on_exception = true

class ResponseHandler
  attr_reader :received

  def on_readable(socket, messages)
    message = messages.first.copy_out_string
    puts "Received message from client: #{message}"

    socket.send_msg("re: #{message}")
  end
end

trap('INT') do
  EM.stop
end

ctx = EM::ZeroMQ::Context.new(1)

EM.run do
  socket = ctx.bind(ZMQ::REP, 'tcp://127.0.0.1:9011', ResponseHandler.new)
end

