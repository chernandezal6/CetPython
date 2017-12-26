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
				if validar_detalle(line, stack_msg):					
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
			insertar_detalle_many(registros,id_envio, oCurs, stack_msg)	
		
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
	proceso = linea[1:3]
	rnc =  linea[3:14]
	periodo = linea[14:20]

	#Para pasar al detalle
	global periodo_encabezado
	global tipo_proceso
	tipo_proceso = proceso
	periodo_encabezado = periodo

	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not proceso == "BO":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido (%s)" % (iLineas, proceso ))
		return False

	if not funciones.is_periodo(periodo) :
		stack_msg.append("Error en el encabezado: la linea (%s), periodo invalido (%s)" % (iLineas, periodo))
		return False

	if not funciones.is_rnc_o_cedula(rnc):
		stack_msg.append("Error en el encabezado: la linea (%s), rnc invalido (%s)" % (iLineas, rnc))
		return False

	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (182) posiciones" % (iLineas)
	v_longitud=182

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
	tipo_documento = linea[1:2]
	numero_documento = linea[2:27]
	nombres = linea[27:77]
	primer_apellido = linea[77:117]
	segundo_apellido = linea[117:157]
	sexo = linea[157:158]
	fecha_nacimiento = linea[158:166]
	monto_bonificacion = linea[166:182]	

	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False

	if tipo_documento in ("C","P","N") :		
		if not funciones.is_documento_valido(tipo_documento, numero_documento, 25):
			prevalidaciones_msg="En la linea %s error en el numero de documento (%s)" % (iLineas, numero_documento)
			return False
	else:
		prevalidaciones_msg="En la linea %s error en el tipo de documento (%s)" % (iLineas, tipo_documento)
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

	if not funciones.is_sexo_vacio(sexo):
		prevalidaciones_msg="En la linea %s error en el sexo (%s)" % (iLineas, sexo)
		return False

	if not funciones.is_fecha_vacia(fecha_nacimiento):
		prevalidaciones_msg="En la linea %s error en la fecha de nacimiento (%s)" % (iLineas, fecha_nacimiento)
		return False

	if not funciones.is_salario(monto_bonificacion):
		prevalidaciones_msg="En la linea %s error en el salario ss (%s)" % (iLineas, monto_bonificacion)
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
		stack_msg.append("Error en el sumario: linea (%s), numero de registros incorrectos (%s)" % (iLineas,  re.sub("[\']", "''", numero_registros )))
		return False

	if not iLineas == int(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), La cantidad de lineas y el numero de registros no coinciden, (Lineas: %s - Registros: %s)" % (iLineas, iLineas, numero_registros))
		return False		

	return True

def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga, stack_msg_str):

	try:
		tipo_documento = linea[1:2].strip()
		numero_documento = linea[2:27].strip()
		nombres = linea[27:77].strip()
		primer_apellido = linea[77:117].strip()
		segundo_apellido = linea[117:157].strip()
		sexo = linea[157:158].strip()
		fecha_nacimiento = linea[158:166].strip()
		monto_bonificacion = linea[166:182].strip()

		registros.append((int(id_envio), int(nro_linea),tipo_documento, numero_documento,id_error, status, periodo_encabezado,nombres, primer_apellido,segundo_apellido,
							fecha_nacimiento,sexo, monto_bonificacion,usuario_carga,stack_msg_str)) 

	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))

	return registros
							
def insertar_detalle_many(registros,id_envio, oCurs, stack_msg):

	db.borrar_tmp_movimiento(id_envio,tipo_proceso, oCurs)

	sSQL = """INSERT INTO sre_tmp_movimiento_t (ID_RECEPCION, SECUENCIA_MOVIMIENTO, TIPO_DOCUMENTO,NO_DOCUMENTO,ID_ERROR,STATUS, PERIODO_APLICACION,
	            								FECHA_REGISTRO, NOMBRES, PRIMER_APELLIDO,SEGUNDO_APELLIDO,FECHA_NACIMIENTO,SEXO,SALARIO_SS,ULT_FECHA_ACT,
	            								ULT_USUARIO_ACT, OBSERVACION)  
			values (:1, :2, :3, :4, :5, :6, :7, sysdate, :9, :10, :11, :12, :13, :14, sysdate, :16, :17) """

	try:
		oCurs.prepare(sSQL) 
		oCurs.executemany(None, registros)

	except Exception, e:
		stack_msg.append(" Error insertando en la BD (Oracle: %s)  " % (e))

def cargar_movimiento(id_envio, oCurs, stack_msg):

	v_result = "0"
	try:
		oCurs.callproc("SRE_PROCESAR_PYTHON_PKG.procesar_bo",[id_envio, v_result])
	except cx_Oracle.DatabaseError as e:
		stack_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s, en la BD Oracle desde python." % (id_envio))	