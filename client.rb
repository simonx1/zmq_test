#!/usr/bin/env ruby

require 'em-zeromq'

client_id = ARGV[0] ? ARGV[0].to_i : 1
message = ARGV[1] || "Test msg"

Thread.abort_on_exception = true

class ReqHandler
  attr_reader :received

  def on_readable(socket, messages)
    messages.each do |m|
      puts "Response from server: #{m.copy_out_string.inspect}"
    end
  end
end

trap('INT') do
  EM.stop
end

ctx = EM::ZeroMQ::Context.new(1)

EM.run do
  conn = ctx.connect(ZMQ::REQ, 'tcp://127.0.0.1:9011', ReqHandler.new, identity: "client#{client_id}")
  conn.socket.send_string(message)
end
