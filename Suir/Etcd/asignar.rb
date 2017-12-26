require 'etcd'

begin

	branch_name = ARGV[0]
	etcd_server = ARGV[1]
	
	if etcd_server.nil?
		etcd_server = "box"
	end

	client = Etcd.client(host: etcd_server, port: 2379)
	cola = JSON.parse(client.get('/cola').value)

	branch_found = false
    
	branch_ssh = ""
	branch_oracle = ""
	branch_apex = ""
    branch_file_path = ""
    branch_website_ip = ""
    branch_suirplus = ""
    branch_ws = ""
    branch_lanzador = ""
    
	slot_disponible = ""
	i = 0

	cola["slots"].each do |c|

		if branch_name == c["branch"].to_s
			branch_found = true
			branch_file_path = c["file_path"]
			branch_website_ip = c["website_ip"]
			branch_ssh = c["ssh"]
			branch_oracle = c["oracle"]
			branch_apex = c["apex"]
            branch_suirplus = c["suirplus"]
            branch_ws = c["ws"]
            branch_lanzador = c["lanzador"]
            
            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
            puts "El branch #{branch_name} ya esta en la cola de etcd. Estas son las variables que devolvio:"
            puts "Path: #{branch_file_path}"
            puts "IP del Website: #{branch_website_ip}"
            puts "SSH: #{branch_ssh}"
            puts "Oracle: #{branch_oracle}"
            puts "APEX: #{branch_apex}"
            puts "SuirPlus: #{branch_suirplus}"
            puts "Webservices: #{branch_ws}"
            puts "Lanzador Procesos: #{branch_lanzador}"
            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

            puts "##teamcity[setParameter name='env.branch_website_url' value='http://#{branch_website_ip}']"
            puts "##teamcity[setParameter name='env.branch_website_ip' value='#{branch_website_ip}']"
            puts "##teamcity[setParameter name='env.branch_website_file_path' value='#{branch_file_path}']"
            puts "##teamcity[setParameter name='env.branch_ssh_port' value='#{branch_ssh}']"
            puts "##teamcity[setParameter name='env.branch_oracle_port' value='#{branch_oracle}']"
            puts "##teamcity[setParameter name='env.branch_apex_port' value='#{branch_apex}']"
            puts "##teamcity[setParameter name='env.branch_suirplus_port' value='#{branch_suirplus}']"
            puts "##teamcity[setParameter name='env.branch_ws_port' value='#{branch_ws}']"
            puts "##teamcity[setParameter name='env.branch_lanzador_port' value='#{branch_lanzador}']"

		end

		if c["branch"].to_s == ""
			slot_disponible = i
		end

		i = i + 1

	end
	
	if branch_found == false

		cola["slots"][slot_disponible]["branch"] = branch_name

		client.set('/cola', value: cola.to_json)

        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
		puts "El branch #{branch_name} NO esta en la cola de etcd. Estas son las variables que se asignaron:"
		puts "Branch: #{branch_name}"
		puts "Path: #{cola["slots"][slot_disponible]["file_path"]}"
		puts "IP del Website: #{cola["slots"][slot_disponible]["website_ip"]}"
		puts "SSH: #{cola["slots"][slot_disponible]["ssh"]}"
		puts "Oracle: #{cola["slots"][slot_disponible]["oracle"]}"
		puts "APEX: #{cola["slots"][slot_disponible]["apex"]}"
        puts "SuirPlus: #{cola["slots"][slot_disponible]["suirplus"]}"
        puts "Webservices: #{cola["slots"][slot_disponible]["ws"]}"
        puts "Lanzador Procesos: #{cola["slots"][slot_disponible]["lanzador"]}"
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

		puts "##teamcity[setParameter name='env.branch_website_url' value='http://#{cola["slots"][slot_disponible]["website_ip"]}']"
		puts "##teamcity[setParameter name='env.branch_website_ip' value='#{cola["slots"][slot_disponible]["website_ip"]}']"
		puts "##teamcity[setParameter name='env.branch_website_file_path' value='#{cola["slots"][slot_disponible]["file_path"]}']"
		puts "##teamcity[setParameter name='env.branch_ssh_port' value='#{cola["slots"][slot_disponible]["ssh"]}']"
		puts "##teamcity[setParameter name='env.branch_oracle_port' value='#{cola["slots"][slot_disponible]["oracle"]}']"
		puts "##teamcity[setParameter name='env.branch_apex_port' value='#{cola["slots"][slot_disponible]["apex"]}']"
        puts "##teamcity[setParameter name='env.branch_suirplus_port' value='#{cola["slots"][slot_disponible]["suirplus"]}']"
        puts "##teamcity[setParameter name='env.branch_ws_port' value='#{cola["slots"][slot_disponible]["ws"]}']"
        puts "##teamcity[setParameter name='env.branch_lanzador_port' value='#{cola["slots"][slot_disponible]["lanzador"]}']"
	end 

end