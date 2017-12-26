import base64
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
NewRowEncabezado = ""
prevalidaciones_msg =""
stack_msg_str =""

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
				stack_msg.append("Error en la linea %s - No pueden haber mas lineas despues del Sumario"  % iLineas)

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
			insertar_detalle_many(registros, id_envio,oCurs, stack_msg, exception_msg)
		
		if len(stack_msg) == 0:
			cargar_movimiento(id_envio, oCurs, stack_msg, exception_msg)
		
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
  	
	global tipo_proceso	
	tipo_registro = linea[:1]
	proceso = linea[1:3]
	tipo_proceso = proceso
	rnc = linea[3:14]
	periodo = linea[14:20]
	
	# Para pasar al detalle
	global rnc_encabezado 
	rnc_encabezado = rnc
	
	global periodo_encabezado
	periodo_encabezado = periodo
	
	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro))
		return False

	if not proceso == "NV":	
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido  (%s)" % (iLineas, proceso))
		return False
		
	#validamos el Periodo
	if not funciones.is_periodo(periodo):
		stack_msg.append("Error en el encabezado: la linea (%s), peraodo invalido  (%s)" % (iLineas, periodo))
		return False
		
	#validamos el RNC
	if not funciones.is_rnc_o_cedula(rnc):
		stack_msg.append("Error en el encabezado: la linea (%s), rnc invalido (%s)" % ( iLineas, rnc))
		return False

	return True	

def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (310,326,330) posiciones" % (iLineas)
	v_longitud=(310,326,330)

	if (linea[-2:] == "\r\n"):
		if len(linea)-2 not in v_longitud:
			stack_msg.append(v_msg)
			return False

	elif (linea[-1:] == "\n"):
		if len(linea)-1 not in v_longitud:
			stack_msg.append(v_msg)
			return False	
								
	elif (linea[-1:] == "\r"):
		if len(linea)-1 not in v_longitud:
			stack_msg.append(v_msg)
			return False

	elif (len(linea) not in v_longitud):
		stack_msg.append(v_msg)
		return False		

	global prevalidaciones_msg	
	tipo_registro =  linea[:1]
	clave_nomina = linea[1:4]
	tipo_novedad = linea[4:6]
	fecha_inicio = linea[6:14]
	fecha_fin = linea[14:22]
	tipo_documento = linea[22:23]
	nro_documento = linea[23:48]
	nombres = linea[48:98]
	primer_apellido = linea[98:138]
	segundo_apellido = linea[138:178]
	sexo =  linea[178:179]
	fecha_nacimiento = linea[179:187]
	salario_ss = linea[187:203]
	aporte_ordinario_voluntario = linea[203:219]
	salario_isr = linea[219:235]
	otras_remuneraciones = linea[235:251]
	agente_retencion = linea[251:262]
	remuneracion_otros = linea[262:278]
	ingresos_exentos = linea[278:294]
	saldo_favor = linea[294:310]	

	salario_infotep = "0000000000000.00"

	if len(linea) >=326:
		salario_infotep = linea[310:326]

	tipo_ingreso = "0001"
	if len(linea) >=330:
		if len(linea[326:330].strip())>0:
			tipo_ingreso = linea[326:330]
	
	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en la clave de nomina (%s)" % (iLineas, tipo_registro))
		return False

	if (not funciones.is_numerico(clave_nomina)) or (len(clave_nomina.strip()) != 3):
		prevalidaciones_msg="En la linea %s error en la clave de nomina (%s)" % (iLineas, clave_nomina)
		return False

	if not tipo_novedad in ("IN","SA","VC","LV","LM","LD","AD"):
		prevalidaciones_msg="En la linea %s error en el tipo de novedad (%s)" % (iLineas, tipo_novedad)
		return False

	if not funciones.is_fecha(fecha_inicio):				
		prevalidaciones_msg="En la linea %s error en la fecha inicio (%s)" % (iLineas, fecha_inicio)
		return False	

	if not funciones.is_fecha_vacia(fecha_fin):				
		prevalidaciones_msg="En la linea %s error en la fecha fin (%s)" % (iLineas, fecha_fin)
		return False					

	if tipo_novedad in ("IN", "AD"):
		#validamos la fecha limite para novedades de ingresos y salida de trabajadores.						
		if not funciones.is_fecha_limite_nov(fecha_inicio, tipo_proceso):
			prevalidaciones_msg="En la linea %s error en la fecha ingreso no debe ser mayor a 30 dias (%s)" % (iLineas, fecha_inicio)
			return False
	
	if tipo_novedad =="SA":
		if not funciones.is_fecha_limite_nov(fecha_fin, tipo_proceso):
			prevalidaciones_msg="En la linea %s error en la fecha salida no debe ser mayor a 30 dias (%s)" % (iLineas, fecha_fin)
			return False

	if tipo_documento in ("C","P","N") :		
		if not funciones.is_documento_valido(tipo_documento, nro_documento, 25):
			prevalidaciones_msg="En la linea %s error en el numero de documento (%s)" % (iLineas, nro_documento)
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

	if not funciones.is_fecha_vacia(fecha_nacimiento):				
		prevalidaciones_msg="En la linea %s error en la fecha nacimiento (%s)" % (iLineas, fecha_nacimiento)
		return False

	if not funciones.is_sexo_vacio(sexo):
		prevalidaciones_msg="En la linea %s error en el sexo (%s)" % (iLineas, sexo)
		return False

	if not funciones.is_salario(salario_ss):
		prevalidaciones_msg="En la linea %s error en el salario ss (%s)" % (iLineas, salario_ss)
		return False

	if not funciones.is_salario(aporte_ordinario_voluntario):
		prevalidaciones_msg="En la linea %s error en el aporte ordinario voluntario (%s)" % (iLineas, aporte_ordinario_voluntario)
		return False
			
	if not funciones.is_salario(salario_isr):
		prevalidaciones_msg="En la linea %s error en el salario isr (%s)" % (iLineas, salario_isr)
		return False

	if not funciones.is_salario(otras_remuneraciones):
		prevalidaciones_msg="En la linea %s error en otras remuneraciones (%s)" % (iLineas, otras_remuneraciones)
		return False

	if not funciones.is_agente_retencion(agente_retencion):
		prevalidaciones_msg="En la linea %s error en el agente de retencion (%s)" % (iLineas, agente_retencion)			
		return False

	if not funciones.is_salario(remuneracion_otros):
		prevalidaciones_msg="En la linea %s error en remuneraciones de otros empleadores isr (%s)" % (iLineas, remuneracion_otros)
		return False

	if not funciones.is_salario(ingresos_exentos):
		prevalidaciones_msg="En la linea %s error en los ingresos exentos (%s)" % (iLineas, ingresos_exentos)
		return False

	if not funciones.is_salario(saldo_favor):
		prevalidaciones_msg="En la linea %s error en el saldo a favor (%s)" % (iLineas, saldo_favor)
		return False

	if not funciones.is_salario(salario_infotep):
		prevalidaciones_msg="En la linea %s error en el salario infotep (%s)" % (iLineas, salario_infotep)
		return False

	if not funciones.is_tipo_ingreso(tipo_ingreso):
		prevalidaciones_msg="En la linea %s error en el tipo de ingreso (%s)" % (iLineas,  tipo_ingreso)
		return False
	
	return True

def validar_sumario(linea, stack_msg):
	if len(linea) != 7 :
		if not linea[7:9] =="\r\n"  and (not linea[7:8] == "\r") and (not linea[7:8] == "\n"):
			stack_msg.append("Error en el sumario: linea %s debe tener 7 posiciones " % (iLineas))
			return False

	tipo_registro =  linea[:1]
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

#Este hace el arreglo del archivo en cuestion para ser insertado en la tabla "sre_tmp_movimiento_t"
def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga,stack_msg_str):
	try:
		clave_nomina = linea[1:4].strip()
		tipo_novedad = linea[4:6].strip()
		fecha_inicio = linea[6:14].strip()
		fecha_fin = linea[14:22].strip()
		tipo_documento = linea[22:23].strip()
		nro_documento = linea[23:48].strip()
		nombres = linea[48:98].strip()
		primer_apellido = linea[98:138].strip()
		segundo_apellido = linea[138:178].strip()
		sexo =  linea[178:179].strip()
		fecha_nacimiento = linea[179:187].strip()
		salario_ss = linea[187:203].strip()
		aporte_ordinario_voluntario = linea[203:219].strip()
		salario_isr = linea[219:235].strip()
		otras_remuneraciones = linea[235:251].strip()
		agente_retencion = linea[251:262].strip()
		remuneracion_otros = linea[262:278].strip()
		ingresos_exentos = linea[278:294].strip()
		saldo_favor = linea[294:310].strip()	

		salario_infotep = "0000000000000.00"
		if len(linea) >=326:
			salario_infotep = linea[310:326]		
		
		tipo_ingreso = "0001"
		if len(linea) >=330:
			if len(linea[326:330].strip())>0:
				tipo_ingreso = linea[326:330]					

		registros.append((id_envio, nro_linea,periodo_encabezado, clave_nomina,tipo_novedad,fecha_inicio,fecha_fin, tipo_documento,
						nro_documento, nombres, primer_apellido, segundo_apellido,sexo,fecha_nacimiento,salario_ss,aporte_ordinario_voluntario,
						salario_isr, otras_remuneraciones,agente_retencion, remuneracion_otros,id_error, status,usuario_carga,ingresos_exentos,saldo_favor,
						salario_infotep, tipo_ingreso,stack_msg_str))	
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))	
				
	return registros

#aqui insertamos en la tabla de "sre_tmp_movimiento_t", el arreglo anteriormente mencionado		
def insertar_detalle_many(registros, id_envio, oCurs, stack_msg, exception_msg):
	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs) # verificamos si el Id_Recepcion ya existe en sre_tmp_movimiento_t, si existe borra e inserta de nuevo.
	
	sSQL = """INSERT INTO sre_tmp_movimiento_t (ID_RECEPCION,SECUENCIA_MOVIMIENTO,PERIODO_APLICACION,ID_NOMINA,	ID_TIPO_NOVEDAD,FECHA_INICIO,FECHA_FIN,TIPO_DOCUMENTO,	
												NO_DOCUMENTO,NOMBRES,PRIMER_APELLIDO,SEGUNDO_APELLIDO, SEXO,FECHA_NACIMIENTO, SALARIO_SS,APORTE_VOLUNTARIO,	SALARIO_ISR,
												OTROS_INGRESOS_ISR, AGENTE_RETENCION_ISR, REMUNERACION_ISR_OTROS,ID_ERROR,STATUS,FECHA_REGISTRO,ULT_FECHA_ACT,ULT_USUARIO_ACT,ingresos_exentos_isr,
												SALDO_FAVOR_SS,salario_infotep,cod_ingreso,OBSERVACION) 
			values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18, :19, :20, :21, :22, sysdate, sysdate, :25, :26, :27, :28, :29, :30)"""
	try:
		oCurs.prepare(sSQL) #Aqui va el SQL con el arreglo
		oCurs.executemany(None, registros)
	except Exception, e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con Nro. Envio: %s." % (id_envio))	

def cargar_movimiento(id_envio, oCurs, stack_msg, exception_msg):
	v_result = "0"
	try:
		oCurs.callproc("SRE_PROCESAR_PYTHON_PKG.procesar_nv",[id_envio, v_result])
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con Nro. Envio: %s." % (id_envio))	