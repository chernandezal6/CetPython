# coding=utf-8
import base64
import archivos_rd
import archivos_am_ar
import archivos_nv
import archivos_bo
import archivos_pn
import archivos_da
import archivos_vs
import archivos_pt
import archivos_ep
import archivos_ac
import archivos_ra
import archivos_rt
import db
import codecs
import datetime
import re
import funciones
import cx_Oracle
import linecache

def procesar(archivo, id_envio, tipo, usuario_carga):
	# agregamos este codigo para desencriptar nombre base de datos
	try:
		oConn = cx_Oracle.connect(db.connString().decode("base64"))
		oCurs = oConn.cursor()
		funciones.grabar_log("I", "probando1 (mi conexion: %s)" % (db.connString().decode("base64")))

	except cx_Oracle.DatabaseError as e:
		error, = e.args
		if error.code == 1017:			
			funciones.grabar_log("C", "Favor verificar su credencial: %s)" % (db.connString().decode("base64")))		
			print('Please check your credentials.')
		else:
			funciones.grabar_log("C", "Error en la conexion a la base datos: %s)" % (db.connString().decode("base64")))		
			print('Database connection error: %s'.format(e))
		raise

	try:
		
		print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
		print "=-=-= Archivo: ", archivo
		print "=-=-= Inicio: %s " % datetime.datetime.time(datetime.datetime.now())

		stack_msg = []
		exception_msg = []
		global tipo_archivo
		global envio
		tipo_archivo = ""
		envio = 0		
		iLineas = 0
		tipo_registro = ""
		hashs = []
		numHash = 0
		NewRowEncabezado =""
		v_E =""
		v_D =""
		v_S =""
		print 'este es mi nuevo tipo de archivo',tipo
		tipo_archivo = tipo			
		envio = id_envio
		
		#para manejar la estructura de constantes en el archivo(E=encabezado, D=detalle,S=sumario)-----------	
		fr = codecs.open(archivo, encoding='latin-1')
		for row in fr.readlines():
			iLineas = iLineas + 1
			#solo para la primera linea limpiamos el encabezado
			if iLineas == 1:
				NewRowEncabezado = row[row.index(row[:1]):]
				row = NewRowEncabezado
    
		fr.close()

		if len(stack_msg) == 0:			
		#--------------------------------------------------------------------------------------------------
			funciones.grabar_log("I", "Va a ser procesado el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))
			#Determinar el tipo de archivo que estamos procesando	
			if (tipo_archivo == "AM") or (tipo_archivo == "AR"):
				iLineas = archivos_am_ar.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)

			elif tipo_archivo == "NV":
				iLineas = archivos_nv.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)
				
			elif tipo_archivo == "BO":
				iLineas = archivos_bo.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)
			
			elif tipo_archivo == "RD":
				iLineas = archivos_rd.procesar(archivo, id_envio, usuario_carga, stack_msg)	
					
			elif tipo_archivo == "PN":				
				iLineas = archivos_pn.procesar(archivo, id_envio,usuario_carga, stack_msg, exception_msg)			
			
			elif tipo_archivo == "DA":
				iLineas = archivos_da.procesar(archivo, id_envio,usuario_carga, stack_msg, exception_msg)

			elif tipo_archivo == "VS":
				iLineas = archivos_vs.procesar(archivo, id_envio,usuario_carga, stack_msg)	
			
			elif tipo_archivo == "PT":
				iLineas = archivos_pt.procesar(archivo, id_envio, usuario_carga, stack_msg)			
				
			elif tipo_archivo == "RA":
				iLineas = archivos_ra.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)	
			
			elif tipo_archivo == "RT":
				iLineas = archivos_rt.procesar(archivo, id_envio, usuario_carga, stack_msg)		
			
			#para archivos de procesamiento de pagos cuya constante es RE pero existen 2 tipos AC y EP
			elif tipo_archivo == "EP":	
				iLineas = archivos_ep.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)

			elif tipo_archivo == "AC":
				iLineas = archivos_ac.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)
			else:
				stack_msg.append("Error en la linea 1, el tipo de archivo no se encuentra definido (%s)" % tipo_archivo)

			'''elif tipo_archivo == "RE":
				tipo_archivo_alterno = NewRowEncabezado[3:5]
			
				if tipo_archivo_alterno == "EP":	
					iLineas = archivos_ep.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)			
				if tipo_archivo_alterno == "AC":
					iLineas = archivos_ac.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)
			else:
				stack_msg.append("Error en la linea 1, el tipo de archivo no se encuentra definido (%s)" % tipo_archivo)'''
		 	#Mostrar el resultado
		 	print "=-=-= Fin   : %s " % datetime.datetime.time(datetime.datetime.now())
		 	
			funciones.grabar_log("I", "Ya fue procesado el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))
		
		if ((len(stack_msg)>0) or (len(exception_msg)>0)):
			db.marcar_status_archivo(id_envio, "R", stack_msg, usuario_carga)

			#para procesar los tipos de archivos de recaudo y aclaracion
	 		if tipo_archivo == "RE":
	 			tipo_archivo_alterno=NewRowEncabezado[3:5]
	 			tipo_archivo= tipo_archivo_alterno
			
			db.borrar_tmp_movimiento(id_envio,tipo_archivo, oCurs)

		 	print "=-=-= Se encontraron %s errores en el archivo de %s lineas, a continuacion el detalle: %s " % (len(stack_msg), iLineas, stack_msg)
			#funciones.grabar_log("I","Se encontraron %s errores en el archivo de %s lineas, a continuacion el detalle: %s " % (len(stack_msg), iLineas, stack_msg))
			
			num_line = 0
			for x in stack_msg:
				x = x.encode('ascii', 'ignore') #Esto es para poder ignorar los caracteres especiales no manejados por la codificacion y proceder a la insercion del error.
				res =  re.findall(r'\d+',x)				
				if res == []:
				    num_line = 0
				else:
					#para detectar los numeros que vienen en las lineas del arreglo y asi poder tomar el numero correspondiente a la linea del error.
				    num_line = int(res[0])
		
				db.marcar_error_archivo(id_envio, tipo_archivo, num_line, str(x), usuario_carga)
				funciones.grabar_log("I", "%s ,tipo archivo: %s" % (str(exception_msg[0]),tipo_archivo))
		else:
			funciones.grabar_log("I", "No se encontraron errores en el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))
			print "=-=-= Archivo procesado correctamente (%s lineas)" % (iLineas)

		print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

	except Exception, e:
		#pendiente
		pass
		#oCurs.callproc("SYSTEM.Html_Mail",['info@mail.tss2.gov.do', '_operaciones@mail.tss2.gov.do; kerlin_delacruz@mail.tss2.gov.do', 'Error procesando el archivo ',e])

	oCurs.close()
	oConn.close()
