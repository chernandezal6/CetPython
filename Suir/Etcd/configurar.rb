require 'etcd'

etcd_server = ARGV[0]

if etcd_server.nil?
	etcd_server = "box"
end

cantidad_slots = 20

cola_array = "{\"slots\":["

(0..cantidad_slots).each do |i|
   ii = i.to_s.rjust(2, "0")
   cola_array << %Q{{"branch":"", "ssh": "49#{ii}0", "oracle":"49#{ii}1", "apex":"49#{ii}2", "file_path": "f#{ii}", "website_ip": "172.16.4.20", "suirplus": "49#{ii}3", "ws": "49#{ii}4", "lanzador": "49#{ii}5"},
 }
end

cola_array = cola_array[0...-3]
cola_array << "]}"

begin

	client = Etcd.client(host: etcd_server, port: 2379)

	#client.delete('/cola')

	cola = client.get('/cola')
	
	puts "El servidor de ETCD (#{etcd_server}) tiene registrado una cola inicial."

rescue
	puts "El servidor de ETCD (#{etcd_server}) no tiene una cola, vamos a registrarla"
	
	client.set('/cola', value: cola_array)

	puts "valor_inicial: #{cola_array}"
	puts "servidor: #{client.get('/cola').value}"
end