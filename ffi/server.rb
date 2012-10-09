require 'rubygems'
require 'ffi-rzmq'

if ARGV.length < 3
  puts "usage: remote_lat <connect-to> <message-size> <roundtrip-count>"
  exit
end

connect_to = ARGV[0]
message_size = ARGV[1].to_i
roundtrip_count = ARGV[2].to_i

ctx = ZMQ::Context.new
s = ctx.socket ZMQ::REQ
rc = s.connect(connect_to)

msg = "#{ '3' * message_size }"

start_time = Time.now

msg = ""
roundtrip_count.times do
  rc = s.send_string msg, 0
  rc = s.recv_string msg
  raise "Message size doesn't match, expected [#{message_size}] but received [#{msg.size}]" if message_size != msg.size
end
