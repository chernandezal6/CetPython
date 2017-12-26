import funciones
import codecs
import db
import cx_Oracle
import sys
import hashlib
import re

iLineas = 0
tipo_proceso = ""
numHash = 0
prevalidaciones_msg =""
stack_msg_str =""

def procesar(archivo, id_envio, usuario_carga, stack_msg,exception_msg):
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
			cargar_movimiento(id_envio, oCurs, stack_msg,exception_msg)
		
		if len(stack_msg) == 0:
			oConn.commit()
	
		oCurs.close()
		oConn.close()

	return iLineas

def validar_encabezado(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de linea en windows	
	if len(linea) > 14:	
		if not linea[14:16] == "\r\n" and (not linea[14:15] == "\r") and (not linea[14:15] == "\n"):
			stack_msg.append("Error en la linea %s  tiene mas de 15 posiciones " % (iLineas))
			return False
					
	global tipo_proceso
	tipo_registro = linea[:1]
	proceso = linea[1:3]	
	tipo_proceso =  proceso
	rnc =  linea[3:14]

	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not proceso in("RA", "NA"):
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido(%s)" % (iLineas, proceso ))
		return False

	if not funciones.is_rnc_o_cedula(rnc):
		stack_msg.append("Error en el encabezado: la linea (%s), en el rnc (%s)" % (iLineas, rnc))
		return False

	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (198) posiciones" % (iLineas)
	v_longitud=198

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
	clave_nomina = linea[1:4]
	periodo_aplicacion = linea[4:10]
	tipo_documento = linea[10:11]
	numero_documento = linea[11:36]
	nombres = linea[36:86]
	primer_apellido = linea[86:126]
	segundo_apellido = linea[126:166]
	salario_ss = linea[166:182]
	aporte_ordinario_voluntario = linea[182:198]
	
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en la clave de nomina (%s)" % (iLineas, tipo_registro))
		return False

	if (not funciones.is_numerico(clave_nomina)) or (len(clave_nomina) != 3):
		prevalidaciones_msg="En la linea %s error en la clave de nomina (%s)" % (iLineas, clave_nomina)
		return False
	
	if (not funciones.is_numerico(periodo_aplicacion)) or (len(periodo_aplicacion) != 6):
		prevalidaciones_msg="En la linea %s error en el periodo (%s)" % (iLineas, periodo_aplicacion)
		return False
	
	if tipo_documento == "C" :		
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

	if not funciones.is_salario(salario_ss):
		prevalidaciones_msg="En la linea %s error en el salario ss (%s)" % (iLineas, salario_ss)
		return False
	
	if not funciones.is_salario(aporte_ordinario_voluntario):
		prevalidaciones_msg="En la linea %s error en el aporte ordinario voluntario (%s)" % (iLineas, aporte_ordinario_voluntario)
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
		tipo_registro = linea[:1].strip()
		clave_nomina = linea[1:4].strip()
		periodo_aplicacion = linea[4:10].strip()
		tipo_documento = linea[10:11].strip()
		numero_documento = linea[11:36].strip()
		nombres = linea[36:86].strip()
		primer_apellido = linea[86:126].strip()
		segundo_apellido = linea[126:166].strip()
		salario_ss = linea[166:182].strip()
		aporte_ordinario_voluntario = linea[182:198].strip()	 
		
		registros.append((id_envio, nro_linea, clave_nomina,periodo_aplicacion, tipo_documento, numero_documento,id_error, status, 
						nombres, primer_apellido,segundo_apellido,salario_ss,aporte_ordinario_voluntario, usuario_carga,stack_msg_str))	
			
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))						

	return registros
	
def insertar_detalle_many(registros,id_envio, oCurs, stack_msg):
	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs) # verificamos si el Id_Recepcion ya existe en sre_tmp_movimiento_t, si existe borra e inserta de nuevo.

	sSQL = """INSERT INTO sre_tmp_movimiento_t(ID_RECEPCION, SECUENCIA_MOVIMIENTO, ID_NOMINA,PERIODO_APLICACION, TIPO_DOCUMENTO, NO_DOCUMENTO, ID_ERROR,STATUS, 
												FECHA_REGISTRO, NOMBRES, PRIMER_APELLIDO, SEGUNDO_APELLIDO,
												SALARIO_SS, APORTE_VOLUNTARIO, ULT_FECHA_ACT, ULT_USUARIO_ACT,OBSERVACION)  
			values (:1, :2, :3, :4, :5, :6, :7, :8, sysdate, :10, :11, :12, :13, :14, sysdate, :16,:17)"""
	
	
	try:
		oCurs.prepare(sSQL) #Aqui va el SQL con el arreglo 
		oCurs.executemany(None, registros)
	except cx_Oracle.DatabaseError, e:
		stack_msg.append(" Error insertando en la BD (Oracle: %s)  " % (e))

#Aqui llamamos el procesamiento de archivos de Novedad Atrasada & Registro de Audit.		 
def cargar_movimiento(id_envio, oCurs, stack_msg,exception_msg):
	v_result = "0"
	try:		
		oCurs.callproc("SRE_PROCESAR_PYTHON_PKG.Procesar_RA",[id_envio,v_result])
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con Nro. Envio: %s." % (id_envio))	