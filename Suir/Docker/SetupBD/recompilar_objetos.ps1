param(
[string]$usuario,
[string]$pass,
[string]$oracle_host,
[string]$puerto,
[string]$instance_name
)

# Compilar objetos invalidos en todos los SCHEMAS
echo $usuario/$pass@$oracle_host":"$puerto/$instance_name
sqlplus $usuario/$pass@$oracle_host":"$puerto/$instance_name @Docker/SetupBD/RecompileInvalidObjects.sql