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

	if len(linea) > 9:
		if not linea[9:11] == "\r\n" and (not linea[9:10] == "\r") and (not linea[9:10] == "\n"):
			stack_msg.append("En la linea %s tiene mas de 9 posiciones " % (iLineas))
			return False
			
	global tipo_proceso
	tipo_registro = linea[:1]
	tipo_proceso = linea[1:3]
	periodo = linea[3:9]

	global periodo_encabezado
	periodo_encabezado = periodo

	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not tipo_proceso == "VS":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido (%s)" % (iLineas, tipo_proceso))
		return False

	if not funciones.is_periodo_alterno(periodo):
		stack_msg.append("Error en el encabezado: la linea (%s), periodo invalido (%s)" % (iLineas, periodo))
		return False

	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (13) posiciones" % (iLineas)
	v_longitud=13

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
	numero_documento = linea[2:13]
	
	if not tipo_registro == "D":
		stack_msg.append("Error en la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False

	if not tipo_documento == "C":
		prevalidaciones_msg="Error en la linea %s error en el Tipo de documento (%s)" % (iLineas, tipo_documento)
		return False		

	if not funciones.is_documento_valido("C", numero_documento, 11):
		prevalidaciones_msg="En la linea %s error en el numero de documento (%s)" % (iLineas, numero_documento)
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
		numero_documento = linea[2:13].strip()

		#validamos que el tipo de documento es diferente a 'C' para modificar su id_error
		if tipo_documento != 'C':
			id_error='VS1'
			status='R'
		registros.append(( id_envio, nro_linea, numero_documento, tipo_documento, periodo_encabezado,id_error, status, usuario_carga, stack_msg_str)) 
		
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))
			
	return registros

def insertar_detalle_many(registros, id_envio,oCurs, stack_msg):

	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs) 
	sSQL = """ INSERT INTO sre_tmp_movimiento_t (ID_RECEPCION, SECUENCIA_MOVIMIENTO, NO_DOCUMENTO, TIPO_DOCUMENTO, PERIODO_APLICACION, FECHA_REGISTRO, ID_ERROR,STATUS,ULT_FECHA_ACT, ULT_USUARIO_ACT,OBSERVACION) 
			   values (:1, :2, :3, :4, :5, sysdate,:7,:8,sysdate,:10,:11) """

	try:
		oCurs.prepare(sSQL)
		oCurs.executemany(None, registros)
		
	except Exception, e:
		stack_msg.append(" Error insertando en la BD (Oracle: %s)  " % (e))
	return True

def cargar_movimiento(id_envio, oCurs, stack_msg):
	
	v_result = "0"
	try:
		oCurs.callproc("sre_procesar_python_pkg.procesar_vs",[id_envio, v_result])
	except cx_Oracle.DatabaseError as e:
		stack_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s, en la BD Oracle desde python." % (id_envio))	