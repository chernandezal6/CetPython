require 'etcd'

begin

PuertoOracle = ARGV[0]

#Archivos de Configuración
NombreArchivo = ["../SuirPlus2010/SuirPlusCL/app.config",
                 "../SuirPlus2010/SuirPlusEF/App.config",
                 "../SuirPlus2010/DatabaseMigrations/App.config",
                 "../SuirPlus2010/SuirPlusUnitTests/App.config",
                 "../SuirPlus2010/SuirPlusWebSite/Web.config",
                 "../SuirPlus2010/WebServicesTSS/web.config",
                 "../SuirPlus2010/DatabaseMigrations/Scripts/ejecutar/migrate.txt"]

NombreArchivo.each {|x|
StringSuirPlusCL = File.read(x)
Indice = StringSuirPlusCL.index("PORT =")
Port = StringSuirPlusCL[Indice,12]
content = StringSuirPlusCL.gsub(Port,"PORT = #{PuertoOracle}")
File.open(x,"w"){|file| file << content}
}

#Para quitar el estatus de ignorado que actualmente tiene git para los config
 load('../Etcd/no_ignorar_archivos.rb')
 ejecutar_no_ignorados()

end