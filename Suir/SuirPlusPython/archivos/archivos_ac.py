import base64
import funciones
import codecs
import time
import db
import cx_Oracle
import sys
import hashlib
import re 

iLineas = 0
id_clave_entidad = 0
tipo_proceso = ""
total_pagado = 0
NewRowEncabezado = ""
prevalidaciones_msg =""
stack_msg_str =""

def procesar(archivo, id_envio, usuario_carga, stack_msg,exception_msg):	
	# agregamos este codigo para desencriptar nombre base de datos
	oConn = cx_Oracle.connect(db.connString().decode("base64"))
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
		
		if iLineas == 1:
			NewRowEncabezado = line[line.index('E'):]
			line = NewRowEncabezado			
	
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
			insertar_detalle_many(registros,id_envio, oCurs, stack_msg, exception_msg)	
		
		if len(stack_msg) == 0:
			cargar_movimiento(id_envio, oCurs, stack_msg, exception_msg)
		
		if len(stack_msg) == 0:
			oConn.commit()
	
		oCurs.close()
		oConn.close()

	return iLineas

def validar_encabezado(linea, stack_msg):

	if len(linea) > 105:
		#\n terminar de linea en linux
		# \r terminar de linea en mac
		#\r\n terminar de linea en windows
		if not linea[105:107] == "\r\n" and (not linea[105:106] == "\r") and (not linea[105:106] == "\n"):
			stack_msg.append("Error en la linea %s tiene mas de 105 posiciones " % (iLineas))
			return False

	global tipo_proceso	
	tipo_registro = linea[:1]
	clave_proceso = linea[1:3]
	clave_subproceso =  linea[3:5]
	longitud_registro = linea[5:8]
	tipo_entidad = linea[8:10]
	clave_entidad = linea[10:12]
	espacios = linea[12:105]
	
	global id_clave_entidad
	global tipo_proceso
	tipo_proceso = clave_subproceso
	id_clave_entidad  = clave_entidad
	
	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not clave_proceso == "RE":
		stack_msg.append("Error en el encabezado: la linea (%s), la clave de proceso es invalida (%s)" % (iLineas, clave_proceso))
		return False

	if not clave_subproceso == "AC":
		stack_msg.append("Error en el encabezado: la linea (%s), la clave de subproceso es invalida (%s)" % (iLineas, clave_subproceso))
		return False

	#Campos requeridos.
	if not longitud_registro == "105":
		stack_msg.append("Error en el encabezado: la linea (%s), longitud del registro invalido(%s)" % (iLineas,  re.sub("[\']", "''",longitud_registro)))
		return False

	if tipo_entidad != "04":
		stack_msg.append("Error en el encabezado: la linea (%s), tipo de entidad emisora invalida (%s)" % (iLineas, re.sub("[\']", "''",tipo_entidad)))
		return False
	
	if not funciones.is_numerico(clave_entidad):
		stack_msg.append("Error en el encabezado: la linea (%s), la clave de entidad emisora es invalida (%s)" % (iLineas, re.sub("[\']", "''",clave_entidad)))
		return False
	
	if len(espacios.strip()) != 0:
		stack_msg.append("Error en el encabezado: la linea (%s), espacios en blanco no coinciden (%s)" % (iLineas, re.sub("[\']", "''",espacios)))
		return False

	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (105) posiciones" % (iLineas)
	v_longitud=105

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
	tipo_movimiento = linea[1:3]
	lote = linea[3:12]
	id_registro = linea[12:17]
	fecha_envio = linea[17:25]
	referencia_original = linea[25:41]
	referencia_nueva = linea[41:57]
	importe_original = linea[57:70]
	importe_nuevo = linea[70:83]
	num_autorizacion_original = linea[83:93]
	num_autorizacion_nueva = linea[93:103]
	motivo_error = linea[103:105]
	
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False

	if not tipo_movimiento == "01":
		stack_msg.append("En la linea %s error en el Tipo de movimiento (%s)" % (iLineas, tipo_movimiento))
		return False	

	if not funciones.is_numerico(lote):
		prevalidaciones_msg="En la linea %s error en el numero del lote (%s)" % (iLineas, lote)
		return False

	if not funciones.is_numerico(id_registro):
		prevalidaciones_msg="En la linea %s error en el id del registro (%s)" % (iLineas, id_registro)
		return False

	if not funciones.is_fecha(fecha_envio) :
		prevalidaciones_msg="En la linea %s error en la fecha de envio (%s)" % (iLineas, fecha_envio)
		return False

	if not funciones.is_alfanumerico(referencia_nueva):
		prevalidaciones_msg="En la linea %s error en la referencia nueva (%s)" % (iLineas, referencia_nueva)
		return False	

	if not funciones.is_decimal(importe_nuevo):
		prevalidaciones_msg="En la linea %s error en el importe nuevo (%s)" % (iLineas, importe_nuevo)
		return False	

	if not funciones.is_numerico(num_autorizacion_nueva):
		prevalidaciones_msg="En la linea %s error en el numero de autorizacion nuevo (%s)" % (iLineas, num_autorizacion_nueva)
		return False

	if not funciones.is_numerico(motivo_error):
		prevalidaciones_msg="En la linea %s error en el motivo de error (%s)" % (iLineas, motivo_error)
		return False	
			
	return True

def validar_sumario(linea, stack_msg):

	if len(linea) != 105:
		if not linea[105:107] == "\r\n"  and (not linea[105:106] == "\r") and (not linea[105:106] == "\n"):
			stack_msg.append("Error en el sumario: linea %s debe tener 105 posiciones " % (iLineas))
			return False

	tipo_registro = linea[:1]
	numero_registros = linea[1:6]
	importe_total = linea[6:31]
	espacios = linea[31:105]

	global total_pagado
	total_pagado = importe_total

	if not tipo_registro == "S":
		stack_msg.append("Error en el sumario: linea (%s), debe comenzar con S (%s)" % (iLineas, tipo_registro))
		return False

	if not funciones.is_numerico(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), numero de registros incorrectos (%s)" % (iLineas,  re.sub("[\']", "''", numero_registros )))
		return False

	if not iLineas == int(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), La cantidad de lineas y el numero de registros no coinciden, (Lineas: %s - Registros: %s)" % (iLineas, iLineas, numero_registros))
		return False

	if not  funciones.is_decimal(importe_total.strip()) or len(importe_total) != 25:
		stack_msg.append("%s Error en el Sumario: el importe total es invalido (%s)" % (iLineas, importe_total))
		return False
	
	if (len(espacios) != 74 or len(espacios.strip()) != 0):
		stack_msg.append("%s Error en el Sumario: espacios en blanco no coinciden (%s)" % (iLineas, espacios))
		return False

	return True

def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga, stack_msg_str):
	try:
		tipo_movimiento = linea[1:3].strip()
		lote = linea[3:12].strip()
		id_registro = linea[12:17].strip()
		fecha_envio = linea[17:25].strip()
		referencia_original = linea[25:41].strip()
		referencia_nueva = linea[41:57].strip()
		importe_original = linea[57:70].strip()
		importe_nuevo = linea[70:83].strip()
		num_autorizacion_original = linea[83:93].strip()
		num_autorizacion_nueva = linea[93:103].strip()
		motivo_error = linea[103:105].strip()
	    
		registros.append(( id_envio, nro_linea, lote, id_registro,  referencia_original, referencia_nueva, num_autorizacion_original, num_autorizacion_nueva, 
			importe_original, importe_nuevo, fecha_envio, int(motivo_error), fecha_envio)) 

	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))	
	
	return registros

def insertar_detalle_many(registros,id_envio, oCurs, stack_msg, exception_msg):

	db.borrar_tmp_movimiento(id_envio,tipo_proceso, oCurs)

	sSQL = """ INSERT into sre_tmp_movimiento_recaudo_t (ID_RECEPCION, SECUENCIA_MOV_RECAUDO, LOTE_ACLARACION, SECUENCIA_ACLARACION, ID_REFERENCIA_ISR, ID_REFERENCIA_ACLARACION,
           											 NO_AUTORIZACION, NO_AUTORIZACION_ACLARACION, MONTO, MONTO_ACLARACION, FECHA_PAGO, MOTIVO_ERROR,FECHA_ENVIO, STATUS)
     		   values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, 'OK') """	   
	try:
		oCurs.prepare(sSQL)
		oCurs.executemany(None, registros)
		
	except Exception, e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error insertando en los registros del archivo con Nro. Envio: %s." % (id_envio))

def cargar_movimiento(id_envio, oCurs, stack_msg, exception_msg):
	
	v_result = "0"
	try:
		oCurs.callproc("sre_procesar_python_pkg.procesar_ac",[id_envio, id_clave_entidad, total_pagado, v_result])
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s." % (id_envio))	