param(
[string]$nombre,
[string]$ssh,
[string]$oracle,
[string]$apex
)

docker-machine env docker-vsphere

# Configurar el ambiente de Docker en el PowerShell
# Prueba
& "C:\Program Files\Docker Toolbox\docker-machine.exe" env docker-vsphere | Invoke-Expression

# Imprimir la info del ambiente
docker info

# Detener y Borrar contenedor
docker stop $nombre
docker rm $nombre

# Configurar variables de puertos
$ssh = $ssh + ":22"
$oracle_dyn = $oracle
$oracle = $oracle + ":1521"
$apex = $apex + ":8080"

# Crear el contenedor CON PUERTOS FIJOS que servira como DBLINK
# Comentado, ya no es necesario, se sube como contenedor fijo al momento de inicializar Docker
# docker run -d -p 1005:22 -p 1006:1521 -p 1007:8080 --name=ORACLE-DBLINK gherrera/docker-oracle-xe-plus:dblink

# Crear el contenedor con el nombre del Branch de Git (se pasa como parametro desde TeamCity)
docker run -d -p $ssh -p $oracle -p $apex --volumes-from samba:rw --name=$nombre gherrera/docker-oracle-xe-plus:v1.0.1 

# Mostrar todos los contenedores que estan corriendo
docker ps -a

# Darle un tiempo prudente para que suba el Listener de Oracle
# Start-Sleep -s 60

<#
# Inicializar la BD
$instancia_sys_oracle = "sys/oracle@box:" + $oracle_dyn
$instancia_system_oracle = "system/oracle@box:" + $oracle_dyn
$instancia_suirplus_oracle = "suirplus/sp1010@box:" + $oracle_dyn

sqlplus $instancia_system_oracle @Docker/SetupBD/CreateTablespaces.sql
sqlplus $instancia_system_oracle @Docker/SetupBD/Seguridad.sql

sqlplus $instancia_sys_oracle as sysdba @Docker/SetupBD/SeguridadSys.sql
sqlplus $instancia_sys_oracle as sysdba @Docker/SetupBD/Apex_User.sql

sqlplus $instancia_suirplus_oracle @Docker/SetupBD/Pre_schema.sql
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/Schema.sql
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/Schema_finish.sql
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/DisableConstraints.sql

# Notas
# crear como tablas las vistas o vistas materializadas que hagan referencias a DBLINK
# y borrar las sentencias de creacion de esas vistas o vistas materializadas
# el archivo Pre_schema.sql contiene las sentencias de creacion de esos objetos como tablas
# borrar las partition by list de las tablas
# borrar las particiones de los indices - compress  local, local, nologging, compress
# quitar el trigger de auditoria CVS_AUDITORIA_BEFORE_TRG y MODIFICA_EMPLEADORES_TRG
# quitar grant select to ggarcia;
# quitar grant select on analista_operaciones;
# quitar bitmap index

# ====================================================================
# Para evitar que se ejecute el contenido anterior, comentar en bloque
#  el codigo de arriba y descomentar este bloque de codigo
# ====================================================================

"======================================================="
" PASO #3 OBVIADO: No se recrea el contenedor de DOCKER " 
"======================================================="
#>