require "bunny"

STDOUT.sync = true

conn = Bunny.new(:hostname => "cocker")
conn.start

ch = conn.create_channel

q = ch.queue("asignacion_nss", :durable => true)

(0..100).each do |i|
	ch.default_exchange.publish("#{i}", :routing_key => q.name)
end

conn.close