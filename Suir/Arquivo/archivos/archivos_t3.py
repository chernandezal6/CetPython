import funciones
import codecs
import db
import cx_Oracle
import sys
import hashlib
import re

iLineas = 0
periodo_encabezado = ""
tipo_proceso = ""
numHash = 0
prevalidaciones_msg =""
stack_msg_str =""

def procesar(archivo, id_envio, usuario_carga, stack_msg):
	oConn = cx_Oracle.connect(db.connString())
	oCurs = oConn.cursor()
	registros = []

	fh = codecs.open(archivo, encoding='latin-1')
	md5 = hashlib.md5()
	stop = False

	for line in fh.readlines():
		global prevalidaciones_msg
		global iLineas
		global numHash
		iLineas = iLineas + 1
	
		if line[:1] == "D":
			if not stop:

				if validar_detalle(line, periodo_encabezado, stack_msg):					
					registros = insertar_detalle_bind(registros, iLineas, line, id_envio,'0','N', usuario_carga, prevalidaciones_msg)
					prevalidaciones_msg=""
				else:
					if len(stack_msg) == 0:
						registros = insertar_detalle_bind(registros, iLineas, line, id_envio,'PY1','R', usuario_carga, prevalidaciones_msg)
						prevalidaciones_msg=""
			else:
				stack_msg.append("Error en la linea %s - No pueden haber mas lineas despues del Sumario" % iLineas)

		elif line[:1] == "S":
			validar_sumario(line, stack_msg)
			stop = True

		elif line[:1] == "E":

			if iLineas != 1:
				stack_msg.append("Error en la linea %s el tipo de registro encabezado solo se permite en la primera linea" % iLineas)
			validar_encabezado(line, stack_msg)

		else:			
			if line[:1] == "\'":
				stack_msg.append("Error en la linea %s datos fuera de la estructura del archivo, (%s)" % (iLineas, re.sub("[\']", "''", line[:1] )))
			else:
				stack_msg.append("Error en la linea %s datos fuera de la estructura del archivo, (%s)" % (iLineas, line[:1].strip()))	
		
		numHash = funciones.crear_hash_md5(md5, line)		 
	fh.close()

	v_resultado ='1'
	res = oCurs.callproc("SRE_PROCESAR_PYTHON_PKG.Archivo_Hash",[id_envio, numHash, v_resultado])

	#Marcar el hash
	db.marcar_hash_archivo(id_envio, numHash, stack_msg)

	#Variable que trae el valor del resultado
	if res[2] == '1':

		if len(stack_msg) == 0:
			insertar_detalle_many(registros, id_envio, oCurs, stack_msg)

		if len(stack_msg) == 0:	
			cargar_movimiento(id_envio, oCurs, stack_msg)

		if len(stack_msg) == 0:	
			oConn.commit()

		oCurs.close()
		oConn.close()

	return iLineas

def validar_encabezado(linea, stack_msg):

	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de linea en windows	
	if len(linea) > 20:	
		if not linea[20:22] == "\r\n" and (not linea[20:21] == "\r") and (not linea[20:21] == "\n"):
			stack_msg.append("Error en la linea %s  tiene mas de 20 posiciones " % (iLineas))
			return False

	tipo_registro = linea[:1]
	global tipo_proceso 
	proceso = linea[1:3]
	tipo_proceso =  proceso
	rnc =  linea[3:14]
	periodo = linea[14:20]

	# Para pasar al detalle
	global periodo_encabezado
	periodo_encabezado = periodo[2:6] + periodo[:2]
	
	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E(%s)" % (iLineas, tipo_registro))
		return False

	if not proceso == "T3":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido(%s)" % (iLineas, proceso))
		return False

	if not funciones.is_periodo(periodo) :
		stack_msg.append("Error en el encabezado: la linea (%s), periodo invalido (%s)" % (iLineas, periodo))
		return False

	if not funciones.is_rnc_o_cedula(rnc):
		stack_msg.append("Error en el encabezado: la linea (%s), rnc invalido (%s)" % (iLineas, rnc))
		return False

	return True

def validar_detalle(linea, periodo_encabezado, stack_msg):	
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows	
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (530) posiciones" % (iLineas)
	v_longitud=530	
	
	if (linea[-2:] == "\r\n"):
		if len(linea)-2 != v_longitud:
			stack_msg.append(v_msg)
			return False

	elif (linea[-1:] == "\n"):
		if len(linea)-1 !=  v_longitud:
			stack_msg.append(v_msg)
			return False	
								
	elif (linea[-1:] == "\r"):
		if len(linea)-1 != v_longitud:
			stack_msg.append(v_msg)
			return False

	elif (len(linea) != v_longitud):
		stack_msg.append(v_msg)
		return False			

	global prevalidaciones_msg
	tipo_registro = linea[:1]
	tipo_novedad = linea[1:4]
	tipo_documento = linea[4:5]
	numero_documento = linea[5:30]
	nombres = linea[30:80]
	primer_apellido = linea[80:120]
	segundo_apellido = linea[120:160]
	fecha_nacimiento = linea[160:168]
	sexo = linea[168:169]
	salario = linea[169:185]
	fecha_ingreso = linea[185:193]
	ocupacion = linea[193:199]
	ocupacion_desc = linea[199:349]
	vacaciones_inicio = linea[349:357]
	vacaciones_fin = linea[357:365]
	turno = linea[365:371]
	localidad = linea[371:377]
	nacionalidad = linea[377:380]
	

	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False
	
	if not funciones.is_tipo_novedad(tipo_novedad, "T3"):
		prevalidaciones_msg="En la linea %s error en el tipo de novedad (%s)" % (iLineas, tipo_novedad)
		return False	
	
	if not funciones.is_tipo_documento(tipo_documento):
		prevalidaciones_msg="En la linea %s error en el tipo de documento (%s)" % (iLineas, tipo_documento)
		return False

	if not funciones.is_documento_valido(tipo_documento, numero_documento, 25):
		prevalidaciones_msg="En la linea %s error en el numero de documento (%s)" % (iLineas, numero_documento)
		return False

	if (tipo_documento=="P") and (tipo_novedad.strip() =="NI"):
		if not funciones.is_nacionalidad(nacionalidad):
			prevalidaciones_msg="En la linea %s error en la nacionalidad (%s)" % (iLineas, nacionalidad)
			return False
	else:
		if not funciones.is_nacionalidad_vacia(nacionalidad):
			prevalidaciones_msg="En la linea %s error en la nacionalidad (%s)" % (iLineas, nacionalidad)
			return False

	if not funciones.is_nombre_propio(nombres,50):
		prevalidaciones_msg="En la linea %s error en el nombre (%s)" % (iLineas, nombres)
		return False
	
	if not funciones.is_nombre_propio(primer_apellido,40):
		prevalidaciones_msg="En la linea %s error en el primer apellido (%s)" % (iLineas, primer_apellido)
		return False

	if not funciones.is_nombre_propio(segundo_apellido,40):
		prevalidaciones_msg="En la linea %s error en el segundo apellido (%s)" % (iLineas, segundo_apellido)
		return False
	
	if not funciones.is_fecha_vacia(fecha_nacimiento):				
		prevalidaciones_msg="En la linea %s error en la fecha nacimiento (%s)" % (iLineas, fecha_nacimiento)
		return False
	
	if not funciones.is_sexo(sexo):
		prevalidaciones_msg="En la linea %s error en el sexo (%s)" % (iLineas, sexo)
		return False

	if len(fecha_ingreso.strip())>0:				
		if (funciones.is_fecha(fecha_ingreso)) and (tipo_novedad.strip()  == "NS"):
			prevalidaciones_msg="Error en la linea %s, la fecha ingreso no corresponde al tipo de novedad (%s)" % (iLineas, tipo_novedad)
			return False		

		if (not funciones.is_fecha(fecha_ingreso)) and (tipo_novedad.strip()  == "NI"):
			prevalidaciones_msg="Error en la linea %s, la fecha ingreso es requerida para la novedad de ingreso (%s)" % (iLineas, fecha_ingreso)
			return False

	if not funciones.is_salario_valido(salario):
		prevalidaciones_msg="En la linea %s error en el salario (%s)" % (iLineas, salario)
		return False
	
	if not funciones.is_numerico(ocupacion):
		prevalidaciones_msg="En la linea %s error en la ocupacion (%s)" % (iLineas, ocupacion)
		return False

	if not funciones.is_ocupacion(ocupacion_desc):
		prevalidaciones_msg="En la linea %s error en la descripcion de la ocupacion (%s)" % (iLineas, ocupacion_desc)
		return False
	
	if not funciones.is_numerico(turno):
		prevalidaciones_msg="En la linea %s error en el turno (%s)" % (iLineas, turno)
		return False
	
	if not funciones.is_numerico(localidad):
		prevalidaciones_msg="En la linea %s error en la localidad (%s)" % (iLineas, localidad)
		return False
	
	if not funciones.is_fecha_vacia(vacaciones_inicio):
		prevalidaciones_msg="En la linea %s error en la fecha de inicio de vacaciones (%s)" % (iLineas, vacaciones_inicio)
		return False	

	if not funciones.is_fecha_vacia(vacaciones_fin):
		prevalidaciones_msg="En la linea %s error en la fecha fin de vacaciones (%s)" % (iLineas, vacaciones_fin)
		return False

	if len(vacaciones_inicio.strip()) > 0:			
		if not funciones.is_fecha_vacaciones('A',vacaciones_inicio, periodo_encabezado):			
			prevalidaciones_msg="Error en la linea %s, No se puede registrar vacaciones de anos anteriores (%s)" % (iLineas, vacaciones_inicio)
			return False
		
		if not funciones.is_fecha_vacaciones('F',vacaciones_inicio, periodo_encabezado ):			
			prevalidaciones_msg="Error en la linea %s, No puede registrar fechas de vacaciones futuras (%s)" % (iLineas, vacaciones_inicio)
			return False	

	if not funciones.is_fecha_vacaciones('I',vacaciones_inicio, vacaciones_fin ):
		prevalidaciones_msg="Error en la linea %s, Fechas de vacaciones del trabajador incompletas: fecha inicio (%s), fecha fin (%s)" % (iLineas, vacaciones_inicio, vacaciones_fin)
		return False	

	if (len(vacaciones_inicio.strip()) > 0) and (len(vacaciones_fin.strip()) > 0 ):
		if not funciones.is_fecha_vacaciones('R',vacaciones_inicio, vacaciones_fin):
			prevalidaciones_msg="Error en la linea %s, la fecha de inicio de vacaciones (%s) no debe ser mayor a la fecha fin vacaciones (%s)" % (iLineas, vacaciones_inicio, vacaciones_fin)
			return False
	
	return True

def validar_sumario(linea, stack_msg):

	if len(linea) != 7:
		if not linea[7:9] == "\r\n"  and (not linea[7:8] == "\r") and (not linea[7:8] == "\n"):
			stack_msg.append("Error en el sumario: linea %s debe tener 7 posiciones " % (iLineas))
			return False		

	tipo_registro = linea[:1]
	numero_registros = linea[1:7]

	if not tipo_registro == "S":
		stack_msg.append("Error en el sumario: linea (%s), debe comenzar con S (%s)" % (iLineas, tipo_registro))
		return False
	
	if not funciones.is_numerico(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), numero de registros incorrectos (%s)" % (iLineas, re.sub("[\']", "''", numero_registros )))
		return False

	if not iLineas == int(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), La cantidad de lineas y el numero de registros no coinciden, (Lineas: %s - Registros: %s)" % (iLineas, iLineas, numero_registros))
		return False

	return True

def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga, stack_msg_str):
	
	try:
		tipo_novedad = linea[1:4].strip()
		tipo_documento = linea[4:5].strip()
		numero_documento = linea[5:30].strip()
		nombres = linea[30:80].strip()
		primer_apellido = linea[80:120].strip()
		segundo_apellido = linea[120:160].strip()
		fecha_nacimiento = linea[160:168].strip()
		sexo = linea[168:169].strip()
		salario = linea[169:185].strip()
		fecha_ingreso = linea[185:193].strip()
		ocupacion = linea[193:199].strip()
		ocupacion_desc = linea[199:349].strip()
		vacaciones_inicio = linea[349:357].strip()
		vacaciones_fin = linea[357:365].strip()
		turno = linea[365:371].strip()
		localidad = linea[371:377].strip()
		nacionalidad = linea[377:380].strip()
		observacion = linea[380:530].strip()

		if len(stack_msg_str.strip()) != 0:
			observacion = stack_msg_str

		registros.append(( id_envio, nro_linea, tipo_documento, numero_documento, periodo_encabezado,nombres, 
							primer_apellido, segundo_apellido, fecha_nacimiento, sexo, salario, nacionalidad, fecha_ingreso,ocupacion, ocupacion_desc,
							vacaciones_inicio, vacaciones_fin, turno, localidad, tipo_proceso,  tipo_novedad, id_error, status, observacion, usuario_carga)) 
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))						 

	return registros

def insertar_detalle_many(registros,id_envio, oCurs, stack_msg):

	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs)

	#Los comentarios en la columna de la insercion hacen referencia a las columnas de las tablas en la base de datos donde iran dichos campos.
	sSQL = """INSERT INTO sre_tmp_movimiento_t (ID_RECEPCION, SECUENCIA_MOVIMIENTO, TIPO_DOCUMENTO, NO_DOCUMENTO, PERIODO_APLICACION, NOMBRES,
             PRIMER_APELLIDO, SEGUNDO_APELLIDO, FECHA_NACIMIENTO, SEXO, SALARIO_SS,
             INGRESOS_EXENTOS_ISR, --id nacionalidad
             APORTE_AFILIADOS_T3, --fecha_ingreso
             ID_NOMINA, --id_ocupacion
             OCUPACION_DESC,
             FECHA_INICIO, --Fecha_inicio_vacaciones
             FECHA_FIN, --Fecha_fin_vacaciones
             SALDO_FAVOR_SS, --ID_Turno      
             SALARIO_ISR, -- ID_Localidad 
             AGENTE_RETENCION_ISR, --Tipo proceso   
             ID_MOTIVO_DEV,
             ID_ERROR,
             STATUS, 
             OBSERVACION,
             ULT_USUARIO_ACT,
             ULT_FECHA_ACT,             
             FECHA_REGISTRO)  

			values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, :23, :24, :25, sysdate, sysdate) """

	try:
		oCurs.prepare(sSQL)
		oCurs.executemany(None, registros)
		
	except Exception, e:
		stack_msg.append(" Error insertando en la BD (Oracle: %s)  " % (e))

def cargar_movimiento(id_envio, oCurs, stack_msg):
	
	v_result = "0"
	try:
		oCurs.callproc("sre_procesar_python_pkg.procesar_MT",[id_envio,  v_result])
	except cx_Oracle.DatabaseError as e:
		stack_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s, en la BD Oracle desde python." % (id_envio))	