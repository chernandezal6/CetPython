param(
[string]$ip,
[string]$oracle,
[string]$deployment_folder,
[string]$branch,
[string]$ssh_port,
[string]$apex_port,
[string]$build_username,
[string]$build_agent,
[string]$suirplus_port,
[string]$ws_port,
[string]$lanzador_port
)

ruby SlackNotifier/teamcity.rb $ip $oracle $deployment_folder $branch $ssh_port $apex_port $build_username $build_agent $suirplus_port $ws_port $lanzador_port