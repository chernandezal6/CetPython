<#
param(
[string]$nombre,
[string]$ssh,
[string]$oracle,
[string]$apex
)

# Inicializar la BD
$instancia_suirplus_oracle = "suirplus/sp1010@box:" + $oracle
$instancia_unipago_oracle = "unipago/sp1010@box:" + $oracle
$instancia_un_acceso_exterior_oracle = "un_acceso_exterior/sp1010@box:" + $oracle
$instancia_sisalril_suir_oracle = "sisalril_suir/sp1010@box:" + $oracle

# Habilitar todos los constraints, ya con la data arriba
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/EnableConstraints.sql

# Compilar objetos invalidos en todos los SCHEMAS
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/RecompileInvalidObjects.sql
sqlplus $instancia_unipago_oracle @Docker/SetupBD/RecompileInvalidObjects.sql
sqlplus $instancia_un_acceso_exterior_oracle @Docker/SetupBD/RecompileInvalidObjects.sql
sqlplus $instancia_sisalril_suir_oracle @Docker/SetupBD/RecompileInvalidObjects.sql

# Establecer contraseña 12 para todos los usuarios de suirplus
sqlplus $instancia_suirplus_oracle @Docker/SetupBD/SetDefaultUserPasswords.sql

# ====================================================================
# Para evitar que se ejecute el contenido anterior, comentar en bloque
#  el codigo de arriba y descomentar este bloque de codigo
# ====================================================================

"==================================================="
" PASO #5 OBVIADO: No se habilitan las dependencias " 
"==================================================="
#>