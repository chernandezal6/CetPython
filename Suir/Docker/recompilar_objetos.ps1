param(
[string]$usuario,
[string]$pass,
[string]$oracle_host,
[string]$puerto,
[string]$instance_name
)
# Compilar objetos invalidos en todos los SCHEMAS
sqlplus $usuario/$pass@$oracle_host":"$puerto/$instance_name @Docker/SetupBD/RecompileInvalidObjects.sql