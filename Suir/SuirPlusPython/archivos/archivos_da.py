import base64
import funciones
import codecs
import db
import cx_Oracle
import sys
import hashlib
import re

iLineas = 0
rnc_empleador = ""
id_reclamacion = ""
tipo_proceso = ""
prevalidaciones_msg =""
stack_msg_str =""
NewRowEncabezado =""

def procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg):
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
					registros = insertar_detalle_bind(registros, iLineas-1, line, id_envio,'0','N', usuario_carga, prevalidaciones_msg)
					prevalidaciones_msg=""
				else:
					if len(stack_msg) == 0:
						registros = insertar_detalle_bind(registros, iLineas-1, line, id_envio,'PY1','R', usuario_carga, prevalidaciones_msg)
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

	if len(linea) > 30:
		if not linea[30:32] == "\r\n" and (not linea[30:31] == "\r") and (not linea[30:31] == "\n"):
			stack_msg.append("Error en la linea %s tiene mas de 30 posiciones " % (iLineas))
			return False

	tipo_registro = linea[:1]
	proceso = linea[1:3]
	rnc =  linea[3:14]
	nro_reclamacion = linea[14:30]

	global rnc_empleador
	global id_reclamacion
	global tipo_proceso

	rnc_empleador = rnc
	id_reclamacion = nro_reclamacion
	tipo_proceso = proceso

	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not proceso == "DA":
		stack_msg.append("Error en el encabezado: la linea (%s), tipo de Proceso invalido (%s)" % (iLineas, proceso ))
		return False

	if not funciones.is_rnc_o_cedula(rnc) :
		stack_msg.append("Error en el encabezado: la linea (%s), RNC invalido (%s)" % (iLineas, rnc))
		return False

	if not funciones.is_numerico(nro_reclamacion) or len(nro_reclamacion) != 16 :
		stack_msg.append("Error en el encabezado: la linea (%s), nro. reclamacion invalido (%s)" % (iLineas, nro_reclamacion))
		return False

	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (78) posiciones" % (iLineas)
	v_longitud=78

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
	nro_referencia= linea[1:17]
	numero_documento = linea[17:42]
	numero_documento = numero_documento[-11:]
	salario = linea[42:58]
	aporte_voluntario = linea[58:74]
	tipo_reclamacion = linea[74:75]
	motivo_devolucion = linea[75:78]
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False

	if not funciones.is_documento_valido('C', numero_documento, 11):
		prevalidaciones_msg="En la linea %s error en el numero de documento (%s)" % (iLineas, numero_documento)
		return False

	if not funciones.is_numerico(nro_referencia) or len(nro_referencia) != 16:
		prevalidaciones_msg="En la linea %s error en el numero referencia (%s)" % (iLineas, nro_referencia)
		return False
		
	if not tipo_reclamacion in ("P","T"):
		prevalidaciones_msg="En la linea %s error en el tipo de reclamacion (%s)" % (iLineas, tipo_reclamacion)
		return False

	if tipo_reclamacion == "P":
		if (salario == '0000000000000.00')or(salario == '0000000000000000'):
			prevalidaciones_msg="En la linea %s error en el salario ss (%s), debe ser mayor que cero" % (iLineas, salario)
			return False

		if not funciones.is_salario(salario):
			prevalidaciones_msg="En la linea %s error en el salario ss (%s)" % (iLineas, salario)
			return False			

		if not funciones.is_salario(aporte_voluntario):
			prevalidaciones_msg="En la linea %s error en el aporte voluntario (%s)" % (iLineas, aporte_voluntario)
			return False
	else:
		if (salario != '0000000000000.00') and (salario != '0000000000000000'):
			prevalidaciones_msg="En la linea %s error en el salario ss (%s)" % (iLineas, salario)
			return False			

		if (aporte_voluntario != '0000000000000.00') and (aporte_voluntario != '0000000000000000'):
			prevalidaciones_msg="En la linea %s error en el aporte voluntario (%s)" % (iLineas, aporte_voluntario)
			return False

	if not (funciones.is_numerico(motivo_devolucion)) or len(motivo_devolucion.strip()) != 3 :
		prevalidaciones_msg="En la linea %s error en el motivo de devolucion (%s)" % (iLineas, motivo_devolucion)
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
		nro_referencia= linea[1:17].strip()
		numero_documento = linea[17:42].strip()
		salario = linea[42:58].strip()
		aporte_voluntario = linea[58:74].strip()
		tipo_reclamacion = linea[74:75].strip()
		motivo_devolucion = linea[75:78].strip()
		periodo = nro_referencia[:6].strip()
		meses = periodo[:2].strip()
		year = periodo[2:6].strip()		
		periodo_aplicacion = year + "" + meses
		nro_documento = numero_documento[-11:]

		registros.append(( id_envio, nro_linea,'C',nro_documento, periodo_aplicacion,id_reclamacion, salario, aporte_voluntario, nro_referencia, tipo_reclamacion, motivo_devolucion,id_error, status, usuario_carga,stack_msg_str)) 

	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))	
		
	return registros

def insertar_detalle_many(registros, id_envio, oCurs, stack_msg, exception_msg):

	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs)

	sSQL = """ INSERT INTO sre_tmp_movimiento_t (ID_RECEPCION, SECUENCIA_MOVIMIENTO, TIPO_DOCUMENTO, NO_DOCUMENTO, PERIODO_APLICACION, SALDO_FAVOR_SS, FECHA_REGISTRO, SALARIO_SS, 
												 APORTE_VOLUNTARIO, ID_REFERENCIA, TIPO_RECLAMO, ID_MOTIVO_DEV,id_error, status,ULT_FECHA_ACT, ULT_USUARIO_ACT, OBSERVACION) 
				values (:1, :2, :3, :4, :5, :6, sysdate, :8, :9, :10, :11, :12, :13, :14, sysdate, :16, :17) """

	try:
		oCurs.prepare(sSQL)
		oCurs.executemany(None, registros)

	except Exception, e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append("Error insertando en los registros del archivo con Nro. Envio: %s." % (id_envio))

def cargar_movimiento(id_envio, oCurs, stack_msg, exception_msg):
	v_result = "0"
	try:
		oCurs.callproc("sre_procesar_python_pkg.procesar_da", [id_envio, v_result])
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s." % (id_envio))