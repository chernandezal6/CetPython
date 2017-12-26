require 'net/scp'
require 'net/ssh'

=begin

	@host = "box"
	@user = "root"
	@password = "admin"
	@port = ARGV[0]
	@oracle_directory = "/u01/app/oracle/product/11.2.0/xe"
	@origen_dmp = "c:\\apps\\dmp\\docker_small.dmp"
	@destino_dmp = "#{@oracle_directory}/docker/docker_small.dmp"
	@origen_sh = "Docker/SetupBD/change_char_set.sh"
	@destino_sh = "#{@oracle_directory}/docker/change_char_set.sh"

	#Crear los Oracle Directory
	Net::SSH.start(@host, @user, :password => @password, :port => @port) do |session|
		session.exec "cd #{@oracle_directory} && mkdir docker && chmod 777 docker"
		puts "Filesystem directory creado #{@oracle_directory}"
	end

    #Subir el dmp y el change_char_set.sh por SSH
	Net::SCP.start(@host, @user, :password => @password, :port => @port) do |scp|
      scp.upload(@origen_dmp, @destino_dmp)
      puts "docker_small.dmp copiado a #{@destino_dmp}"
      scp.upload(@origen_sh, @destino_sh)
      puts "change_char_set.sh copiado a #{@destino_sh}"
    end

    #Cambiar el charset
	#Net::SSH.start(@host, @user, :password => @password, :port => @port) do |session|
		#session.exec "cd #{@oracle_directory}/bin && . oracle_env.sh && cd #{@oracle_directory}/docker  && . change_char_set.sh"
		#puts "change_char_set.sh Ejecutado"
	#end

    #Ejecutar el DataPump
	Net::SSH.start(@host, @user, :password => @password, :port => @port) do |session|
		session.exec "cd #{@oracle_directory}/bin && ./impdp suirplus/sp1010 dumpfile=docker_small_meta.dmp directory=docker partition_options=MERGE table_exists_action=REPLACE transform=SEGMENT_ATTRIBUTES:n logfile=metadata.log"
	#./impdp suirplus/sp1010 dumpfile=docker_small.dmp directory=docker partition_options=MERGE table_exists_action=REPLACE exclude=statistics exclude=grant logfile=data.log
		puts "docker_small.dmp Ejecutado"
	end

=end

# ====================================================================
# Para evitar que se ejecute el contenido anterior, comentar en bloque
#  el codigo de arriba y descomentar este bloque de codigo
# ====================================================================

begin  
  puts "=============================================================="
  puts " PASO 4 OBVIADO: No se importa la data al contendor de DOCKER "
  puts "=============================================================="
end