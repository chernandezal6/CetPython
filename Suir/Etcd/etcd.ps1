param(
[string]$branch_name
)

$etcd_server = 'box'

ruby Etcd/configurar.rb $etcd_server
ruby Etcd/asignar.rb $branch_name $etcd_server