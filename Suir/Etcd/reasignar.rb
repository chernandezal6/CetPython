require 'etcd'
require 'docker'

begin

    branch_name = ARGV[0]
	etcd_server = ARGV[1]

	if etcd_server.nil?
		etcd_server = "box"
	end

	client = Etcd.client(host: etcd_server, port: 2379)
	cola   = JSON.parse(client.get('/cola').value)

	branch_ssh = ""
	branch_oracle = ""
	branch_apex = ""
    branch_file_path = ""
    branch_website_ip = ""
    branch_suirplus = ""
    branch_ws = ""
    branch_lanzador = ""
    
	branch_found = false
    index_found = ""

	i = 0

	cola["slots"].each do |c|

		if (branch_name == c["branch"].to_s) or (branch_name == c["oracle"].to_s)

			branch_found = true
            index_found = i
            
			branch_file_path = c["file_path"]
			branch_website_ip = c["website_ip"]
			branch_ssh = c["ssh"]
			branch_oracle = c["oracle"]
			branch_apex = c["apex"]
            branch_suirplus = c["suirplus"]
            branch_ws = c["ws"]
            branch_lanzador = c["lanzador"]

            break
            
		end

		i = i + 1

	end
	
    #Para limpiar de la cola ETCD
	if branch_found == false

        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
		puts "El branch #{branch_name} NO esta en la cola de etcd. "
		puts "Intente nuevamente con un branch correcto."
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

    else
        
        cola["slots"][index_found]["branch"] = ""

		client.set('/cola', value: cola.to_json)

        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
        puts "El branch \"#{branch_name}\" fue limpiado de la cola de etcd."
        puts "Estas son las variables que se conservaron:"
        puts "Path: #{branch_file_path}"
        puts "IP del Website: #{branch_website_ip}"
        puts "SSH: #{branch_ssh}"
        puts "Oracle: #{branch_oracle}"
        puts "APEX: #{branch_apex}"
        puts "SuirPlus: #{branch_suirplus}"
        puts "Webservices: #{branch_ws}"
        puts "Lanzador Procesos: #{branch_lanzador}"
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

	end 

    #Para removerlo de la cola de proceso DOCKER
    begin

        ENV["DOCKER_TLS_VERIFY"] = "1"
        ENV["DOCKER_HOST"] = "tcp://172.16.4.132:2376"
        ENV["DOCKER_CERT_PATH"] = "\\\\kronos\\C$\\apps\\docker-vsphere"
        ENV["DOCKER_MACHINE_NAME"] = "docker-vsphere"

        container = Docker::Container.get("#{branch_name}")
        puts "#{container.id}"

        container.stop
        container.delete(:force => true)

        puts "El branch \"#{branch_name}\" fue removido como proceso de Docker."
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

    rescue

        puts "El branch #{branch_name} NO tiene un proceso corriendo en Docker. "
        puts "Intente nuevamente con un branch correcto."
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

    end

end