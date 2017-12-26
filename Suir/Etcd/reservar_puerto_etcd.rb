require 'etcd'

begin

    load('Etcd/ignorar_archivos.rb')
    ejecutar_ignorados()

    oracle_port = ARGV[0]
    branch_name = ARGV[1]
    etcd_server = ARGV[2]
    
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

        if oracle_port == c["oracle"].to_s

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
            
        end

        if branch_name == c["branch"]

            branch_found = true
            index_found = i

            break

        end  

        i = i + 1

    end
    
    if branch_found == false

        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
        puts "El puerto oracle #{oracle_port} NO esta en la cola de etcd. "
        puts "Intente nuevamente con un branch correcto."
        puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

    else

        if cola["slots"][index_found]["branch"] != ""

            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
            puts "El branch \"#{cola["slots"][index_found]["branch"]}\" YA ESTA ASIGNADO al puerto \"#{cola["slots"][index_found]["oracle"]}\"."
            puts "Intente nuevamente con otro puerto."
            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

        else    

            cola["slots"][index_found]["branch"] = "#{branch_name}"

            client.set('/cola', value: cola.to_json)

            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
            puts "El puerto \"#{oracle_port}\" fue reservado para el branch \"#{branch_name}\". Estas son las variables asociadas a dicho puerto:"
            puts "Path: #{branch_file_path}"
            puts "IP del Website: #{branch_website_ip}"
            puts "SSH: #{branch_ssh}"
            puts "Oracle: #{branch_oracle}"
            puts "APEX: #{branch_apex}"
            puts "SuirPlus: #{branch_suirplus}"
            puts "Webservices: #{branch_ws}"
            puts "Lanzador Procesos: #{branch_lanzador}"
            puts "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

        end

    end 

end