docker run -d -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 --name etcd quay.io/coreos/etcd:v2.0.8 \
 -name etcd0 \
 -advertise-client-urls http://172.16.4.132:2379,http://172.16.4.132:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://172.16.4.132:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd0=http://172.16.4.132:2380 \
 -initial-cluster-state new

# Crear el contenedor para SAMBA para acceder desde los contenedores a un share de windows
docker run -d --name=samba --net=host -e USERID=0 -e GROUPID=0 -v archivos:/archivos_recibidos dperson/samba -s "archivos_recibidos;/archivos_recibidos;yes;no"

# Crear el contenedor para los DBLinks de oracle con puertos fijos
docker run -d -p 1005:22 -p 1006:1521 -p 1007:8080 --name=ORACLE-DBLINK --volumes-from samba:rw gherrera/docker-oracle-xe-plus:dblink