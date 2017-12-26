import base64
import funciones
import codecs
import db
import cx_Oracle
import sys
import hashlib
import re

iLineas = 0
ars_encabezado = ""
tipo_proceso = ""
NewRowEncabezado = ""
prevalidaciones_msg =""
stack_msg_str =""

def procesar(archivo, id_envio, usuario_carga, stack_msg):
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
			insertar_detalle_many(registros,id_envio, oCurs, stack_msg)	
		
		if len(stack_msg) == 0:
			cargar_movimiento(id_envio, oCurs, stack_msg)
		
		if len(stack_msg) == 0:
			oConn.commit()
	
		oCurs.close()
		oConn.close()

	return iLineas

def validar_encabezado(linea, stack_msg):
	if len(linea) > 5:
		#\n terminar de linea en linux
		# \r terminar de linea en mac
		#\r\n terminar de linea en windows
		if not linea[5:7] == "\r\n" and (not linea[5:6] == "\r") and (not linea[5:6] == "\n"):
			stack_msg.append("Error en la linea %s tiene mas de 5 posiciones " % (iLineas))
			return False
			
	global tipo_proceso
	tipo_registro = linea[:1]
	proceso = linea[1:3]
	tipo_proceso = proceso
	ARS =  linea[3:5]	

	# Para pasar al detalle
	global ars_encabezado
	ars_encabezado = ARS

	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas,tipo_registro))
		return False

	if not proceso == "PT":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido (%s)" % (iLineas,proceso))
		return False

	if not ars_encabezado == '98':
		stack_msg.append("Error en el encabezado: la linea (%s), ID ARS invalido (%s)" % (iLineas,ars_encabezado))

	
	return True

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (17) posiciones" % (iLineas)
	v_longitud=17

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
	pensionado = linea[1:11]
	codigo_ars_origen = linea[11:14]
	codigo_ars_destino = linea[14:17]
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False		

	if not funciones.is_documento_valido('N',pensionado, 10):
		prevalidaciones_msg="En la linea %s error en el id pensionado(%s)" % (iLineas, pensionado)
		return False		
	
	if (not len(codigo_ars_origen.strip()) == 3) or (not funciones.is_numerico(codigo_ars_origen)):
		prevalidaciones_msg="En la linea %s error en la id ars origen (%s)" % (iLineas, codigo_ars_origen)
		return False
	
	if (not len(codigo_ars_destino.strip()) == 3) or (not funciones.is_numerico(codigo_ars_destino)): 
		prevalidaciones_msg="En la linea %s error en la id ars destino (%s)" % (iLineas, codigo_ars_destino)
		return False

	return True

def validar_sumario(linea, stack_msg):
	if len(linea) != 7:
		if not linea[7:9] == "\r\n" and (not linea[7:8] == "\r") and (not linea[7:8] == "\n"):
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

#Este hace el arreglo del archivo en cuestion para ser insertado en la tabla "seh_det_nov_tmp_t"	
def insertar_detalle_bind(registros, nro_linea, linea, id_envio, id_error, status, usuario_carga,stack_msg_str,):
	try:
		tipo_registro = linea[:1]
		pensionado = linea[1:11].strip()
		codigo_ars_origen = linea[11:14].strip()
		codigo_ars_destino = linea[14:17].strip()

		registros.append((int(id_envio), nro_linea,'T',ars_encabezado, pensionado, codigo_ars_origen, codigo_ars_destino, id_error, status, stack_msg_str,usuario_carga))	

	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))
	return registros

#aqui insertamos en la tabla de "seh_det_nov_tmp_t", el arreglo anteriormente mencionado		
def insertar_detalle_many(registros, id_envio, oCurs, stack_msg):
	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs) # verificamos si el Id_Recepcion ya existe en seh_det_nov_tmp_t, si existe borra e inserta de nuevo.

	sSQL = """INSERT into suirplus.seh_det_nov_tmp_t (ID_RECEPCION, SECUENCIA, TIPO_NOVEDAD, ID_ARS, ID_PENSIONADO, ID_ARS_INSCRITO, ID_ARS_TRASPASO, id_error, status, observacion,ult_fecha_act, ult_usuario_act) 
					values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10,sysdate,:12) """	
	try:
		oCurs.prepare(sSQL) #Aqui va el SQL con el arreglo
		oCurs.executemany(None, registros)
	except Exception, e:
		stack_msg.append(" Error insertando en la BD (Oracle: %s)  " % (e))

def cargar_movimiento(id_envio, oCurs, stack_msg):
	v_result = "0"
	try:
		oCurs.callproc("sre_procesar_python_pkg.procesar_pt",[int(id_envio),v_result])
	except cx_Oracle.DatabaseError as e:
		stack_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s, en la BD Oracle desde python." % (id_envio))	