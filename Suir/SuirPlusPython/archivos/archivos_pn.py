
#-*- coding=utf-8 -*-
import base64
import funciones
import codecs
import db
import cx_Oracle
import sys
import re
import hashlib

iLineas = 0
IdARS_encabezado = ""
prevalidaciones_msg =""
stack_msg_str =""
NewRowEncabezado =""

def procesar(archivo, id_envio,usuario_carga, stack_msg, exception_msg):
	# agregamos este codigo para desencriptar nombre base de datos
	oConn = cx_Oracle.connect(db.connString().decode("base64"))	
	oCurs = oConn.cursor()
	registros = []

	fh = codecs.open(archivo,encoding='latin-1') #, errors='ignore')
	md5 = hashlib.md5()
	stop = False

	#buscamos todos los caracteres especiales ignorando los comunes...
	p = re.compile(ur'[^a-zA-Z0-9 ñÑ\n\r\.\,]', re.IGNORECASE) #re.UNICODE ) #

	for line in fh.readlines():
		global prevalidaciones_msg
		global iLineas
		global numHash
		iLineas = iLineas + 1
		
		#imprimimos los encode que no son validos por python
		esp_caract = re.findall(p, line)
				
		if len(esp_caract) > 0:
			line = re.sub(p, ' ', line)
			prevalidaciones_msg = "En la linea %s error tiene caracter espciales (%s) " % (iLineas, str(re.findall(p, line)) )

		if iLineas == 1:
			NewRowEncabezado = line[line.index('E'):]
			line = NewRowEncabezado	

		if line[:1] == "D":
			if not stop:

				if validar_detalle(line, stack_msg):					
					registros = insertar_detalle_bind(registros, iLineas,line , id_envio,'0','N', usuario_carga, prevalidaciones_msg)
					prevalidaciones_msg=""
				else:
					if len(stack_msg) == 0:
						registros = insertar_detalle_bind(registros, iLineas, line , id_envio,'PY1','R', usuario_carga, prevalidaciones_msg)
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
			insertar_detalle_many(registros,id_envio, oCurs, stack_msg,exception_msg)
		
		if len(stack_msg) == 0:
			cargar_movimiento(id_envio, oCurs, stack_msg,exception_msg)
		
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
			stack_msg.append("Error en la linea %s tiene mas de 5 posiciones () " % (iLineas))
			return False
				
	tipo_registro = linea[0:1]
	global tipo_proceso
	tipo_proceso = linea[1:3]
	ars = linea[3:5]
	
	#para validar el detalle	
	global IdARS_encabezado
	IdARS_encabezado = ars
	
	if not tipo_registro == "E":
		stack_msg.append("Error en el encabezado: la linea (%s), la linea debe iniciar con E (%s)" % (iLineas, tipo_registro ))
		return False

	if not tipo_proceso == "PN":
		stack_msg.append("Error en el encabezado: la linea (%s), Tipo de Proceso invalido (%s)" % (iLineas, tipo_proceso))
		return False
		
	if not len(ars.strip()) == 2:
		stack_msg.append("Error en el encabezado: la linea (%s), ARS invalida (%s)" % (iLineas, ars))
		return False
		
	if not funciones.is_alfanumerico(ars):
		stack_msg.append("Error en el encabezado: la linea (%s), ARS invalida (%s)" % (iLineas, ars))
		return False
	
	return True
	
def validar_detalle(linea, stack_msg):
	#\n terminar de linea en linux
	# \r terminar de linea en mac
	#\r\n terminar de li nea en windows
	v_msg="Error en la linea %s la longitud es incorrecta, este tipo de archivo debe ser de (1366) posiciones" % (iLineas)
	v_longitud=1366

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
	tipo_novedad = linea[1:2] #(A=Alta, B=Baja)
	nro_formulario = linea[2:12]
	id_pensionado = linea[12:22]
	id_nss = linea[22:32]
	nombres = linea[32:82]
	primer_apellido = linea[82:122]
	segundo_apellido = linea[122:162]
	tipo_documento = linea[162:163]
	no_documento = linea[163:188]
	fecha_nacimiento = linea[188:196]
	id_nacionalidad = linea[196:199]
	sexo = linea[199:200]
	estado_civil = linea[200:201]
	telefono_1 = linea[201:211]
	telefono_2 = linea[211:221]
	telefono_3 = linea[221:231]
	email = linea[231:281]
	direccion = linea[281:431]
	nro_casa = linea[431:443]
	sector = linea[443:493]
	id_municipio = linea[493:499]
	hijos_menores = linea[499:500]
	fecha_nacimiento_1 = linea[500:508]
	fecha_nacimiento_2 = linea[508:516]
	fecha_nacimiento_3 = linea[516:524]
	fecha_nacimiento_4 = linea[524:532]
	fecha_nacimiento_5 = linea[532:540]
	id_nss_conyuge = linea[540:550]
	nombres_conyuge = linea[550:600]
	primer_apellido_conyuge = linea[600:640]
	segundo_apellido_conyuge = linea[640:680]
	tipo_documento_conyuge = linea[680:681]
	no_documento_conyuge = linea[681:705]
	fecha_nacimiento_conyuge = linea[705:713]
	id_nacionalidad_conyuge = linea[713:716]
	telefono_1_conyuge = linea[716:726]
	telefono_2_conyuge = linea[726:736]
	telefono_3_conyuge = linea[736:746]
	email_conyuge = linea[746:796]
	direccion_conyuge = linea[796:946]
	sector_conyuge = linea[946:996]
	municipio_conyuge = linea[996:1002]
	nombre_empresa = linea[1002:1152]
	direccion_empresa = linea[1152:1302]
	sector_empresa = linea[1302:1352]
	municipio_empresa = linea[1352:1358]
	motivo_pension = linea[1358:1359]
	inscrito_ars = linea[1359:1360]
	id_ars_inscrito = linea[1360:1363]
	id_motivo_baja = linea[1363:1366]

	if not tipo_registro == "D":
		stack_msg.append("En la linea %s error en el Tipo de Registro (%s)" % (iLineas, tipo_registro))
		return False
	
	#validamos el tipo de novedad que sea ('A' , 'B')
	if not funciones.is_tipo_novedad(tipo_novedad, 'PN'):
		prevalidaciones_msg="Error en la linea %s, el tipo de novedad invalido (%s)" % (iLineas,tipo_novedad)
		return False

	if tipo_novedad == "A":
		if len(id_motivo_baja.strip()) > 0:
			prevalidaciones_msg="Error en la linea %s, no se acepta motivo de baja en la novedad alta (%s)" % (iLineas,id_motivo_baja)
			return False
			
		if len(motivo_pension.strip()) > 0:	
			if not motivo_pension in ("T", "E", "S", "O"):
				prevalidaciones_msg="En la linea %s error en el motivo de pension (%s), debe ser (T, E, S, O)  " % (iLineas,motivo_pension )
				return False

		if not funciones.is_documento_valido('N',nro_formulario, 10):
			prevalidaciones_msg="En la linea %s error en el numero del formulario (%s)" % (iLineas, nro_formulario)
			return False

		if not funciones.is_documento_valido('N',id_pensionado, 10):
			prevalidaciones_msg="En la linea %s error en el id pensionado(%s)" % (iLineas, id_pensionado)
			return False

		if len(id_nss.strip()) > 0:
			if not funciones.is_documento_valido('N',id_nss, 10):
				prevalidaciones_msg="En la linea %s error en el id nss (%s)" % (iLineas, id_nss)
				return False

		if not funciones.is_nombre_propio(nombres,50) :
			prevalidaciones_msg="En la linea %s error en el nombre (%s)" % (iLineas, nombres)
			return False
		
		if not funciones.is_nombre_propio(primer_apellido,40):
			prevalidaciones_msg="En la linea %s error en el primer apellido (%s)" % (iLineas, primer_apellido)
			return False
		
		if not funciones.is_nombre_propio(segundo_apellido,40):
			prevalidaciones_msg="En la linea %s error en el segundo apellido (%s)" % (iLineas, segundo_apellido)
			return False

		if len(tipo_documento.strip()) > 0 and len(no_documento.strip()) > 0:
			if funciones.is_tipo_documento(tipo_documento):	
				if not funciones.is_documento_valido(tipo_documento, no_documento, 25):
					prevalidaciones_msg="En la linea %s error en el numero de documento. (%s)" % (iLineas, no_documento)
					return False
			else:
				prevalidaciones_msg="En la linea %s error en el tipo de documento. (%s)" % (iLineas, tipo_documento)
				return False	

		elif (len(tipo_documento.strip()) > 0 and len(no_documento.strip()) == 0) or (len(tipo_documento.strip()) == 0 and len(no_documento.strip()) > 0):
			prevalidaciones_msg="En la linea %s error en el tipo o numero de documento." % (iLineas)
			return False
		
		#validando fecha nacimiento para que acepte campo en 00000000
		if len(fecha_nacimiento.strip()) > 0:
			if fecha_nacimiento != "00000000":
				if not funciones.is_fecha_alterna_vacia(fecha_nacimiento):
					prevalidaciones_msg="En la linea %s error en la fecha nacimiento (%s)" % (iLineas, fecha_nacimiento)
					return False
		
		if not funciones.is_nacionalidad_vacia(id_nacionalidad):
			prevalidaciones_msg="En la linea %s error en la Nacionalidad (%s)" % (iLineas, id_nacionalidad)
			return False		

		if not funciones.is_sexo(sexo):
			prevalidaciones_msg="En la linea %s error en el sexo (%s)" % (iLineas, sexo)
			return False

		if not estado_civil in ("S","C","U"):
			prevalidaciones_msg="En la linea %s error en el estado civil (%s)" % (iLineas, estado_civil)
			return False

		if not funciones.is_telefono(telefono_1):
			prevalidaciones_msg="En la linea %s error en primer numero telefono (%s)" % (iLineas, telefono_1)
			return False

		if not funciones.is_telefono(telefono_2):
			prevalidaciones_msg="En la linea %s error en segundo numero telefono (%s)" % (iLineas, telefono_2)
			return False

		if not funciones.is_telefono(telefono_3):
			prevalidaciones_msg="En la linea %s error en tercero numero telefono (%s)" % (iLineas, telefono_3)
			return False

		if not funciones.is_nombre_propio(direccion,150):
			prevalidaciones_msg="En la linea %s error en la direccion (%s)" % (iLineas, direccion)
			return False
		
		if len(id_municipio.strip()) > 0:
			if not funciones.is_numerico(id_municipio):
				prevalidaciones_msg="En la linea %s error en el municipio (%s)" % (iLineas, id_municipio)
				return False
		
		if len(hijos_menores.strip()) > 0:
			if not hijos_menores in ("S", "N"):
				prevalidaciones_msg="En la linea %s error en hijo menores (%s)" % (iLineas, hijos_menores)
				return False
		
		if hijos_menores == "S":
			if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_1):	
				prevalidaciones_msg="En la linea %s error en la fecha nacimiento menores (%s)" % (iLineas, fecha_nacimiento_1)
				return False

			if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_2):	
				prevalidaciones_msg="En la linea %s error en la fecha nacimiento menores (%s)" % (iLineas, fecha_nacimiento_2)
				return False
		
			if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_3):	
				prevalidaciones_msg="En la linea %s error en la fecha nacimiento menores (%s)" % (iLineas, fecha_nacimiento_3)
				return False
		
			if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_4):	
				prevalidaciones_msg="En la linea %s error en la fecha nacimiento menores (%s)" % (iLineas, fecha_nacimiento_3)
				return False	
		
			if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_5):	
				prevalidaciones_msg="En la linea %s error en la fecha nacimiento menores (%s)" % (iLineas, fecha_nacimiento_3)
				return False

		if len(id_nss_conyuge.strip()) > 0:		
			if not funciones.is_documento_valido('N',id_nss_conyuge,10):
				prevalidaciones_msg="En la linea %s error en el nombre (%s)" % (iLineas, nombres_conyuge)
				return False

		if not funciones.is_nombre_propio(nombres_conyuge,50):
			prevalidaciones_msg="En la linea %s error en el nombre (%s)" % (iLineas, nombres_conyuge)
			return False

		if not funciones.is_nombre_propio(primer_apellido_conyuge,40):
			prevalidaciones_msg="En la linea %s error en el primer apellido (%s)" % (iLineas, primer_apellido_conyuge)
			return False

		if not funciones.is_nombre_propio(segundo_apellido_conyuge,40):
			prevalidaciones_msg="En la linea %s error en el segundo apellido (%s)" % (iLineas, segundo_apellido_conyuge)
			return False

		if len(tipo_documento_conyuge.strip()) > 0 and len(no_documento_conyuge.strip()) > 0:
			if funciones.is_tipo_documento(tipo_documento_conyuge):			
				if not funciones.is_documento_valido(tipo_documento, no_documento_conyuge, 24):
					prevalidaciones_msg="En la linea %s error en el numero de documento del conyugue. (%s)" % (iLineas, no_documento_conyuge)
					return False
			else:
				prevalidaciones_msg="En la linea %s error en el tipo de documento del conyugue. (%s)" % (iLineas, tipo_documento_conyuge)
				return False			
		elif (len(tipo_documento_conyuge.strip()) > 0 and len(no_documento_conyuge.strip()) == 0) or (len(tipo_documento_conyuge.strip())== 0 and len(no_documento_conyuge.strip()) > 0):
			prevalidaciones_msg="En la linea %s error en el tipo o numero de documento del conyugue." % (iLineas)
			return False

		#validando fecha nacimiento conyugue para que acepte campo en 00000000	
		if len(fecha_nacimiento_conyuge.strip()) > 0:
			if fecha_nacimiento_conyuge != "00000000":
				if not funciones.is_fecha_alterna_vacia(fecha_nacimiento_conyuge):
					prevalidaciones_msg="En la linea %s error en la fecha nacimiento conyugue (%s)" % (iLineas, fecha_nacimiento_conyuge)
					return False

		if len(municipio_conyuge.strip()) > 0:
			if not funciones.is_numerico(municipio_conyuge):
				prevalidaciones_msg="En la linea %s error en el municipio conyugue (%s)" % (iLineas, municipio_conyuge)
				return False

		if not funciones.is_telefono(telefono_1_conyuge):
			prevalidaciones_msg="En la linea %s error en primer numero telefono conyugue (%s)" % (iLineas, telefono_1_conyuge)
			return False

		if not funciones.is_telefono(telefono_2_conyuge):
			prevalidaciones_msg="En la linea %s error en primer numero telefono conyugue (%s)" % (iLineas, telefono_1_conyuge)
			return False
			
		if not funciones.is_telefono(telefono_3_conyuge):
			prevalidaciones_msg="En la linea %s error en primer numero telefono conyugue (%s)" % (iLineas, telefono_1_conyuge)
			return False

		if not funciones.is_nacionalidad_vacia(id_nacionalidad_conyuge):
			prevalidaciones_msg="En la linea %s error en el nacionalidad conyugue (%s)" % (iLineas, id_nacionalidad_conyuge)
			return False

		if not funciones.is_nombre_propio(direccion_conyuge, 150):
			prevalidaciones_msg="En la linea %s error en la direccion del conyugue (%s)" % (iLineas,direccion_conyuge )
			return False

		if not funciones.is_nombre_propio(sector_conyuge,50):
			prevalidaciones_msg="En la linea %s error en la sector del conyugue (%s)" % (iLineas,sector_conyuge )
			return False
		
		if not funciones.is_nombre_propio(nombre_empresa,150):
			prevalidaciones_msg="En la linea %s error en la nombre empresa (%s)" % (iLineas,nombre_empresa )
			return False

		if not funciones.is_nombre_propio(direccion_empresa,150):
			prevalidaciones_msg="En la linea %s error en la direccion de la empresa (%s)" % (iLineas,direccion_empresa )
			return False

		if not funciones.is_nombre_propio(sector_empresa,50):
			prevalidaciones_msg="En la linea %s error en la sector de la empresa (%s)" % (iLineas,sector_empresa )
			return False

		if len(municipio_empresa.strip()) > 0:		
			if not funciones.is_numerico(municipio_empresa):
				prevalidaciones_msg="En la linea %s error en la id municipio de la empresa (%s)" % (iLineas,municipio_empresa )
				return False

		if len(inscrito_ars.strip()) > 0:
			if not inscrito_ars in ("S", "N"):
				prevalidaciones_msg="En la linea %s error en inscrito ARS (%s)" % (iLineas, inscrito_ars)
				return False

		if len(id_ars_inscrito.strip()) > 0 and len(id_ars_inscrito) != 3:
			prevalidaciones_msg="En la linea %s error en condigo ars inscrito (%s)" % (iLineas, id_ars_inscrito)
			return False	


    #para las novedades de bajas solo son requeridos Tipo Registro, Tipo de Novedad, Pensionado y Motivo Baja; 
	if tipo_novedad == "B":
		
		if not funciones.is_documento_valido('N',id_pensionado, 10):
			prevalidaciones_msg="En la linea %s error en el id pensionado(%s)" % (iLineas, id_pensionado)
			return False					
		
		if len(id_motivo_baja.strip()) != 3:
			prevalidaciones_msg="En la linea %s error en el motivo de baja (%s)" % (iLineas,id_motivo_baja)
			return False

		if len(motivo_pension.strip()) > 0:			
			if not motivo_pension in ("T", "E", "S", "O"):
				prevalidaciones_msg="En la linea %s error en el motivo de pension (%s) " % (iLineas,motivo_pension )
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
def insertar_detalle_bind(registros, nro_linea, linea, id_envio,id_error, status, usuario_carga,stack_msg_str):
	try:
		tipo_registro = linea[:1].strip()
		tipo_novedad = linea[1:2].strip() #(A=Alta, B=Baja)
		nro_formulario = linea[2:12].strip()
		id_pensionado = linea[12:22].strip()
		id_nss = linea[22:32].strip()
		nombres = linea[32:82].strip()
		primer_apellido = linea[82:122].strip()
		segundo_apellido = linea[122:162].strip()
		tipo_documento = linea[162:163].strip()
		no_documento = linea[163:188].strip()
		fecha_nacimiento = linea[188:196].strip()
		id_nacionalidad = linea[196:199].strip()
		sexo = linea[199:200].strip()
		estado_civil = linea[200:201].strip()
		telefono_1 = linea[201:211].strip()
		telefono_2 = linea[211:221].strip()
		telefono_3 = linea[221:231].strip()
		email = linea[231:281].strip()
		direccion = linea[281:431].strip()
		nro_casa = linea[431:443].strip()
		sector = linea[443:493].strip()
		id_municipio = linea[493:499].strip()
		hijos_menores = linea[499:500].strip()
		fecha_nacimiento_1 = linea[500:508].strip()
		fecha_nacimiento_2 = linea[508:516].strip()
		fecha_nacimiento_3 = linea[516:524].strip()
		fecha_nacimiento_4 = linea[524:532].strip()
		fecha_nacimiento_5 = linea[532:540].strip()
		id_nss_conyuge = linea[540:550].strip()
		nombres_conyuge = linea[550:600].strip()
		primer_apellido_conyuge = linea[600:640].strip()
		segundo_apellido_conyuge = linea[640:680].strip()
		tipo_documento_conyuge = linea[680:681].strip()
		no_documento_conyuge = linea[681:705].strip()
		fecha_nacimiento_conyuge = linea[705:713].strip()
		id_nacionalidad_conyuge = linea[713:716].strip()
		telefono_1_conyuge = linea[716:726].strip()
		telefono_2_conyuge = linea[726:736].strip()
		telefono_3_conyuge = linea[736:746].strip()
		email_conyuge = linea[746:796].strip()
		direccion_conyuge = linea[796:946].strip()
		sector_conyuge = linea[946:996].strip()
		municipio_conyuge = linea[996:1002].strip()
		nombre_empresa = linea[1002:1152].strip()
		direccion_empresa = linea[1152:1302].strip()
		sector_empresa = linea[1302:1352].strip()
		municipio_empresa = linea[1352:1358].strip()
		motivo_pension = linea[1358:1359].strip()
		inscrito_ars = linea[1359:1360].strip()
		id_ars_inscrito = linea[1360:1363].strip()
		id_motivo_baja = linea[1363:1366].strip()

		if tipo_novedad == 'A' and fecha_nacimiento == "00000000":
			fecha_nacimiento=None
		
		if tipo_novedad == 'B':			
			id_nss = None
			nombres = None
			primer_apellido = None
			segundo_apellido = None
			tipo_documento = None
			no_documento = None
			fecha_nacimiento = None
			id_nacionalidad = '0'
			sexo = None
			estado_civil = None
			telefono_1 = None
			telefono_2 = None
			telefono_3 = None
			email = None
			direccion = None
			nro_casa = None
			sector = None
			id_municipio = '000'
			hijos_menores = None
			fecha_nacimiento_1 = None
			fecha_nacimiento_2 = None
			fecha_nacimiento_3 = None
			fecha_nacimiento_4 = None
			fecha_nacimiento_5 = None
			id_nss_conyuge = None
			nombres_conyuge = None
			primer_apellido_conyuge = None
			segundo_apellido_conyuge = None
			tipo_documento_conyuge = None
			no_documento_conyuge = None
			fecha_nacimiento_conyuge = None
			id_nacionalidad_conyuge = '0'
			telefono_1_conyuge = None
			telefono_2_conyuge = None
			telefono_3_conyuge = None
			email_conyuge = None
			direccion_conyuge = None
			sector_conyuge = None
			municipio_conyuge = '000'
			nombre_empresa = None
			direccion_empresa = None
			sector_empresa = None
			municipio_empresa = '000'
			motivo_pension = None
			inscrito_ars = None
			id_ars_inscrito = None

		registros.append((int(id_envio), nro_linea,tipo_novedad, IdARS_encabezado, nro_formulario, id_pensionado, id_nss, nombres, primer_apellido, segundo_apellido, tipo_documento, no_documento,id_error, status, fecha_nacimiento, id_nacionalidad, sexo,
						 estado_civil, telefono_1, telefono_2, telefono_3, email, direccion, nro_casa, sector, id_municipio, hijos_menores,fecha_nacimiento_1,fecha_nacimiento_2,fecha_nacimiento_3, fecha_nacimiento_4, fecha_nacimiento_5,
						 id_nss_conyuge,nombres_conyuge, primer_apellido_conyuge, segundo_apellido_conyuge, tipo_documento_conyuge,no_documento_conyuge, fecha_nacimiento_conyuge, id_nacionalidad_conyuge, telefono_1_conyuge, 
						 telefono_2_conyuge, telefono_3_conyuge,email_conyuge, direccion_conyuge, sector_conyuge,municipio_conyuge,nombre_empresa, direccion_empresa, sector_empresa, municipio_empresa,motivo_pension,inscrito_ars,
						 id_ars_inscrito,id_motivo_baja, stack_msg_str,usuario_carga))
	except Exception, e:
		stack_msg.append(" Error de estructura en el archivo " % (e))
	return registros

#aqui insertamos en la tabla de "seh_det_nov_tmp_t", el arreglo anteriormente mencionado
def insertar_detalle_many(registros, id_envio, oCurs, stack_msg,exception_msg):
	db.borrar_tmp_movimiento(id_envio, tipo_proceso, oCurs)
	sSQL = """INSERT INTO suirplus.seh_det_nov_tmp_t ( id_recepcion, secuencia, tipo_novedad, id_ars, nro_formulario, id_pensionado, id_nss, nombres, primer_apellido, segundo_apellido,tipo_documento,no_documento,id_error,status, 
													fecha_nacimiento, id_nacionalidad, sexo, estado_civil,telefono_1,telefono_2, telefono_3,email,direccion, nro_casa, sector, id_municipio,hijos_menores,
													fecha_nacimiento_1, fecha_nacimiento_2, fecha_nacimiento_3, fecha_nacimiento_4, fecha_nacimiento_5,id_nss_conyuge,nombres_conyuge, primer_apellido_conyuge,
													segundo_apellido_conyuge, tipo_documento_conyuge,no_documento_conyuge, fecha_nacimiento_conyuge, id_nacionalidad_conyuge, telefono_1_conyuge, telefono_2_conyuge, 
													telefono_3_conyuge,email_conyuge, direccion_conyuge,sector_conyuge, id_municipio_conyuge, nombre_empresa, direccion_empresa, sector_empresa, id_municipio_empresa,
													motivo_pension, inscrito_ars, id_ars_inscrito, id_motivo_baja,observacion,ult_fecha_act, ult_usuario_act) 
			VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23,:24,:25,:26,:27,:28,:29,:30,:31,:32,:33,:34,:35,:36,:37,:38,:39,:40,:41,:42,:43,:44,:45,:46,:47,:48,:49,:50,:51,:52,:53,:54,:55,:56,sysdate,:58)"""

	try:

		oCurs.prepare(sSQL) #Aqui va el SQL con el arreglo
		oCurs.executemany(None, registros)

	except Exception, e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error insertando los registros del archivo con Nro. Envio: %s." % (id_envio)) 

	"""NOTA:Luego que tenemos el archivo correctamente insertado en la tabla "seh_det_nov_tmp_t" procedemos a insertar el movimiento.
		este metodo(sre_procesar_PN_pkg.insertar_movimientos) se ejecuta desde la bd y se encarga de revalidar el archivo y afectar los objetos involucrados.
		luego de insertar, Aplicamos los movimientos de los registros sin errores. En este momento se actualiza la tabla (seh_pensionados_t) en donde previamente 
		debe existir el pensionado en curso( esta tabla se alimenta cada cierto tiempo por el departamento de operaciones mediante un CD que se le envia)"""

def cargar_movimiento(id_envio, oCurs, stack_msg,exception_msg):	
	v_result = "0"
	try:
		oCurs.callproc("suirplus.sre_procesar_python_pkg.Procesar_pn",[id_envio, v_result])
		#oCurs.callproc("suirplus.procesar_archivos_python",[id_envio,tipo_proceso, v_result])
	except cx_Oracle.DatabaseError as e:
		exception_msg.append("E500- Error llamando el metodo en la BD (Oracle: %s) " % (e))
		stack_msg.append(" Error procesando el archivo con ID_Envio: %s." % (id_envio))	