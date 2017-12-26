require 'openssl'
OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
require 'slack-notifier'

web_hook_url = "https://hooks.slack.com/services/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"

flash = Slack::Notifier.new web_hook_url, http_options: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
flash.channel = "#ci-magic"
flash.username = "flash"

docker_server_ip = "172.16.4.132"

ip = ARGV[0]
oracle_port = ARGV[1]
deployment_folder = ARGV[2]
branch = ARGV[3]
ssh_port = ARGV[4]
apex_port = ARGV[5]
build_username = ARGV[6]
build_agent = ARGV[7]
suirplus_port = ARGV[8]
ws_port = ARGV[9]
lanzador_port = ARGV[10]

url_suirplus = "http://#{ip}:#{suirplus_port}"
url_ws = "http://#{ip}:#{ws_port}"
url_lanzador = "http://#{ip}:#{lanzador_port}"

oracle = "//#{docker_server_ip}:#{oracle_port}/xe"
deployment_folder_full = "\\\\cocker\\teamcity_feature_branch_deployments\\#{deployment_folder}"
usuario = "suirplus"
password = "sp1010"
apex = "http://#{docker_server_ip}:#{apex_port}/apex"
ssh_user = "root"
ssh_pass = "admin"

teamcity_msg = 
{
	"fallback": "flash",

	"color": "#36a64f", 

	"fields": [
		{
			"title": "SuirPlus",
			"value": "#{url_suirplus}",
            "short": true			
		},
		{
			"title": "Webservices",
			"value": "#{url_ws}",
            "short": true			
		},
		{
			"title": "Lanzador de Procesos",
			"value": "#{url_lanzador}",
            "short": true			
		},
		{
			"title": "Path",
			"value": "#{deployment_folder_full}",
            "short": true			
		},
		{
			"title": "Oracle login",
			"value": "#{usuario}/#{password}",
            "short": true	
		},
		{
			"title": "Connection string",
			"value": "#{oracle}",
            "short": true	
		},
		{
			"title": "SSH",
			"value": "ssh #{ssh_user}@#{docker_server_ip} -p #{ssh_port} (password: #{ssh_pass})",
            "short": true	
		},
		{
			"title": "APEX",
            "value": "#{apex} \n Workspace: #{usuario} \n Username: #{usuario} \n Password: #{password}",
            "short": true
		},
	]
}		

#flash.ping "*#{build_username}* ya #{build_agent} termino de hacer el build del branch *#{branch}* \n\n", attachments: [teamcity_msg] 
flash.ping "ya *#{build_agent}* termino de hacer el build del branch *#{branch}* \n\n", attachments: [teamcity_msg] 
