import funciones
import codecs
import db
import cx_Oracle
import sys
import time
import hashlib
import re

iLineas = 0
tipo_proceso = ""
prevalidaciones_msg =""
stack_msg_str =""

def procesar(archivo, id_envio,usuario_carga, stack_msg, exception_msg):
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
						registros = insertar_detalle_bind(registros, iLineas, line, id_envio,'PY1','RE', usuario_carga, prevalidaciones_msg)
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
	if len(linea) > 65:
		#\n terminar de linea en linux
		# \r terminar de linea en mac
		#\r\n terminar de linea en windows
		if not linea[65:67] == "\r\n" and (not linea[65:66] == "\r") and (not linea[65:67] == "\n"):
			stack_msg.append("Error en la linea %s tiene mas de 65 posiciones " % (iLineas))
			return False
		
	global tipo_proceso	
	tipo_registro = linea[:1]
	proceso = linea[1:3]
	subproceso =  linea[3:5]
	tipo_proceso = subproceso
	sizeregistro = linea[5:8]
	tipo_entidad = linea[8:10]
	clave_entidad = linea[10:12]
	espacio_en_blanco = linea[12:65]
		
	global id_entidad_encabezado
	id_entidad_encabezado = clave_entidad
	
	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not proceso == "RE":
		stack_msg.append("Error en el encabezado: la linea (%s), la clave de proceso debe inicial con RE (%s)" % (iLineas, proceso))
		return False

	if not subproceso == "EP":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Sub-Proceso invalido (%s)" % (iLineas, subproceso ))
		return False

	if (not funciones.is_numerico(sizeregistro)) or (not len(sizeregistro.strip()) == 3):
		stack_msg.append("Error en la linea %s error en la longitud del registro (%s)" % (iLineas, re.sub("[\']", "''",sizeregistro)))
		return False
		
	if tipo_entidad != '04':		
		stack_msg.append("Error en la linea (%s), tipo de entidad emisora invalida (%s)" % (iLineas, re.sub("[\']", "''",tipo_entidad)))
		return False		
				
	if not funciones.is_numerico(clave_entidad):
		stack_msg.append("Error en la linea (%s), la clave de entidad emisora invalida (%s)" % (iLineas, re.sub("[\']", "''",clave_entidad)))
		return False
	
	if len(espacio_en_blanco.strip())!=0:
		stack_msg.append("Error en la linea (%s), en los espacios en blanco (%s)" % (iLineas,espacio_en_blanco))
		return False
		
	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (65) posiciones" % (iLineas)
	v_longitud=65

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
	cve_transaccion = linea[1:7]
	sucursal_banco = linea[7:11]
	nro_referencia = linea[11:27]
	fecha_pago = linea[27:35]
	hora_pago = linea[35:40]
	importe_pago = linea[40:53]
	nro_autorizacion = linea[53:63]
	medio_pago = linea[63:65]	
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False

	if not funciones.is_numerico(cve_transaccion):
		prevalidaciones_msg="En la linea %s error en la Cve transaccion (%s)" % (iLineas, cve_transaccion)
		return False

	if not funciones.is_numerico(sucursal_banco):
		prevalidaciones_msg="En la linea %s error en la sucursal del plaza/banco (%s)" % (iLineas, sucursal_banco)
		return False
		
	if not funciones.is_numerico(nro_referencia):
		prevalidaciones_msg="En la linea %s error en el nro de referencia (%s)" % (iLineas, nro_referencia)
		return False

	if not funciones.is_fecha(fecha_pago):
		prevalidaciones_msg="En la linea %s error en la fecha pago (%s)" % (iLineas, fecha_pago)
		return False

	if not funciones.is_hora(hora_pago):
		prevalidaciones_msg="En la linea %s error en la hora pago (%s)" % (iLineas, hora_pago)
		return False
	
	if not funciones.is_decimal(importe_pago):
		prevalidaciones_msg="En la linea %s error en el importe pago (%s)" % (iLineas, importe_pago)
		return False
	
	if not funciones.is_numerico(nro_autorizacion):
		prevalidaciones_msg="En la linea %s error en el nro_autorizacion (%s)" % (iLineas, nro_autorizacion)
		return False
	
	if not funciones.is_numerico(medio_pago):
		prevalidaciones_msg="En la linea %s error en el medio de pago (%s)" % (iLineas, medio_pago)
		return False

	return True

def validar_sumario(linea, stack_msg):		
	if len(linea) != 65:
		if not linea[65:67] == "\r\n"  and (not linea[65:66] == "\r") and (not linea[65:66] == "\n"):
			stack_msg.append("Error en el sumario: linea %s debe tener 65 posiciones " % (iLineas))
			return False
	
	tipo_registro = linea[:1]
	numero_registros = linea[1:6]
	total_pago = linea[6:31]
	espacio_en_blanco = linea[31:65]

	global vtotal_pagado
	vtotal_pagado = total_pago

	if not tipo_registro == "S":
		stack_msg.append("Error en el sumario: linea (%s), debe comenzar con S (%s)" % (iLineas, tipo_registro))
		return False

	if not funciones.is_numerico(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), numero de registros incorrectos (%s)" % (iLineas,  re.sub("[\']", "''", numero_registros )))
		return False

	if not iLineas == int(numero_registros):
		stack_msg.append("Error en el sumario: linea (%s), La cantidad de lineas y el numero de registros no coinciden, (Lineas: %s - Registros: %s)" % (iLineas, iLineas, numero_registros))
		return False		

		
	if not funciones.is_decimal(total_pago.strip()) or len(total_pago.strip()) != 25:
		stack_msg.append("Error en el Sumario: linea (%s), El total del pago debe ser monto decimal relleno de ceros a la izquierda (%s)" % (iLineas, total_pago))
		return False
	
	if (len(espacio_en_blanco) != 34 or len(espacio_en_blanco.strip()) != 0):
		stack_msg.append("En la linea %s error en los espacios en blanco (%s)" % (iLineas, espacio_en_blanco))
		return False						
	
	return True
#Este hace el arreglo del archivo en cuestion para ser insertado en la tabla "sre_tmp_movimiento_recaudo_t"
def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga, stack_msg_str):
	try:		
		cve_transaccion = linea[1:7].strip()
		sucursal_banco = linea[7:11].strip()
		nro_referencia = linea[11:27].strip()
		fecha_pago = linea[27:35].strip()
		hora_pago = linea[35:40].strip()
		importe_pago = linea[40:53].strip()
		nro_autorizacion = linea[53:63].strip()
		medio_pago = linea[63:65].strip()
		
		registros.append((id_envio, nro_linea, cve_transaccion, nro_referencia, nro_autorizacion, importe_pago, fecha_pago, hora_pago, medio_pago, sucursal_banco, id_error, status, usuario_carga, stack_msg_str))
		
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))	

	return registros

#aqui insertamos en la tabla de "sre_tmp_movimiento_recaudo_t", el arreglo anteriormente mencionado							
def insertar_detalle_many(registros, id_envio, oCurs, stack_msg, exception_msg):	
	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs) # verificamos si el Id_Recepcion ya existe en seh_det_nov_tmp_t, si existe borra e inserta de nuevo.
	sSQL = """INSERT into sre_tmp_movimiento_recaudo_t (ID_RECEPCION ,SECUENCIA_MOV_RECAUDO ,CLAVE_TRANSACCION, ID_REFERENCIA_ISR, NO_AUTORIZACION, MONTO, 
														FECHA_PAGO, HORA_PAGO, MEDIO_PAGO, SUCURSAL_BANCO, ID_ERROR,STATUS, ULT_USUARIO_ACT, OBSERVACION, ULT_FECHA_ACT) 
											values (:1, :2, :3, :4, :5, :6, :7,:8, :9, :10, :11, :12, :13, :14, sysdate)"""	
	try:
		oCurs.prepare(sSQL) #Aqui va el SQL con el arreglo 
		oCurs.executemany(None, registros)
	except Exception, e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error insertando en los registros del archivo con Nro. Envio: %s." % (id_envio))

def cargar_movimiento(id_envio, oCurs, stack_msg,exception_msg):
	v_result = "0"
	try:
		oCurs.callproc("SRE_PROCESAR_PYTHON_PKG.procesar_ep",[id_envio,id_entidad_encabezado, vtotal_pagado, v_result])		
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s." % (id_envio))	