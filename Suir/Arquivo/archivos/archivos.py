# coding=utf-8
import archivos_rd
import archivos_am
import archivos_nv
import archivos_bo
import archivos_t3
import archivos_t4
import archivos_pn
import archivos_da
import archivos_vs
import archivos_pt
import archivos_ep
import archivos_ac
import archivos_mo
import archivos_ra
import archivos_rt
import db
import codecs
import datetime
import re
import funciones
import cx_Oracle

def procesar(archivo, id_envio, usuario_carga):

	oConn = cx_Oracle.connect(db.connString())
	oCurs = oConn.cursor()

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
		v_E =""
		v_D =""
		v_S =""
		
		fh = codecs.open(archivo, encoding='latin-1')
		line = fh.readline()
		fh.close()
		#para manejar la estructura de constantes en el archivo(E=encabezado, D=detalle,S=sumario)-----------	
		fr = codecs.open(archivo, encoding='latin-1')			
		for row in fr.readlines():
			iLineas = iLineas + 1
			if row[:1] == "E":
				if v_E=="":
					v_E="E"
			elif row[:1] == "D":
				if v_D=="":
					v_D="D"				
			elif row[:1] == "S":
				if v_S=="":
					v_S="S"
	
		if v_E != "E":
			stack_msg.append("PY-1:Error en el encabezado, es obligatorio y debe comenzar con E ")
		if v_D != "D":			
			stack_msg.append("PY-2:Error en el detalle, es obligatorio y debe comenzar con D ")
		if v_S != "S":		
			stack_msg.append("PY-3:Error en el sumario, es obligatorio y debe comenzar con S ")

		if (len(line.strip()) > 3) or (len(line[1:3].strip()) > 0):			
			tipo_archivo = line[1:3]
			envio = id_envio
		else:			
			stack_msg.append("PY-4:Error en encabezado, datos fuera de la estructura del archivo,(%s)" % line[1:3].strip())	    
		fr.close()

		if len(stack_msg) == 0:			
		#--------------------------------------------------------------------------------------------------
			funciones.grabar_log("I", "Va a ser procesado el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))
			#Determinar el tipo de archivo que estamos procesando		
			if (tipo_archivo == "AM") or (tipo_archivo == "AR"):
				iLineas = archivos_am.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)			

			elif tipo_archivo == "MO":
				iLineas = archivos_mo.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)		

			elif tipo_archivo == "NV":
				iLineas = archivos_nv.procesar(archivo, id_envio, usuario_carga, stack_msg)
				
			elif tipo_archivo == "BO":
				iLineas = archivos_bo.procesar(archivo, id_envio, usuario_carga, stack_msg)
			
			elif tipo_archivo == "RD":
				iLineas = archivos_rd.procesar(archivo, id_envio, usuario_carga, stack_msg)	

			elif tipo_archivo == "T3":
				iLineas = archivos_t3.procesar(archivo, id_envio, usuario_carga, stack_msg)
			
			elif tipo_archivo == "T4":
				iLineas = archivos_t4.procesar(archivo, id_envio, usuario_carga, stack_msg)
					
			elif tipo_archivo == "PN":
				iLineas = archivos_pn.procesar(archivo, id_envio,usuario_carga, stack_msg)			
			
			elif tipo_archivo == "DA":
				iLineas = archivos_da.procesar(archivo, id_envio,usuario_carga, stack_msg)

			elif tipo_archivo == "VS":
				iLineas = archivos_vs.procesar(archivo, id_envio,usuario_carga, stack_msg)	
			
			elif tipo_archivo == "PT":
				iLineas = archivos_pt.procesar(archivo, id_envio, usuario_carga, stack_msg)			
				
			elif tipo_archivo == "RA" or tipo_archivo == "NA":
				iLineas = archivos_ra.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)	
			
			elif tipo_archivo == "RT":
				iLineas = archivos_rt.procesar(archivo, id_envio, usuario_carga, stack_msg)		
			
			#para archivos de procesamiento de pagos cuya constante es RE pero existen 2 tipos AC y EP
			elif tipo_archivo == "RE":
				tipo_archivo_alterno = line[3:5]
			
				if tipo_archivo_alterno == "EP":	
					iLineas = archivos_ep.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)			
				if tipo_archivo_alterno == "AC":
					iLineas = archivos_ac.procesar(archivo, id_envio, usuario_carga, stack_msg, exception_msg)
			else:
				stack_msg.append("Error en la linea 1, el tipo de archivo no se encuentra definido (%s)" % tipo_archivo)
		 	#Mostrar el resultado
		 	print "=-=-= Fin   : %s " % datetime.datetime.time(datetime.datetime.now())
		 	
			funciones.grabar_log("I", "Ya fue procesado el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))

	 	if len(stack_msg) > 0:
	 		funciones.grabar_log("I","Se encontraron errores en el archivo,(tipo archivo: %s, Nro Envio: %s, %s):" % (tipo_archivo, id_envio,stack_msg))
			if len(exception_msg)>0:
				funciones.grabar_log("I", "%s :" % (str(exception_msg[0])))
			#para procesar los tipos de archivos de recaudo y aclaracion
	 		if tipo_archivo == "RE":
	 			tipo_archivo_alterno=line[3:5]
	 			tipo_archivo= tipo_archivo_alterno
			
			db.borrar_tmp_movimiento(id_envio,tipo_archivo, oCurs)
		
			db.marcar_status_archivo(id_envio, "R", stack_msg,usuario_carga)

		 	print "=-=-= Se encontraron %s errores en el archivo de %s lineas, a continuacion el detalle: %s " % (len(stack_msg), iLineas, stack_msg)
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
		else:
			funciones.grabar_log("I", "No se encontraron errores en el archivo (tipo archivo: %s, Nro Envio: %s)" % (tipo_archivo, id_envio))
			print "=-=-= Archivo procesado correctamente (%s lineas)" % (iLineas)

		print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

	except Exception, e:

		pass
		#oCurs.callproc("SYSTEM.Html_Mail",['info@mail.tss2.gov.do', '_operaciones@mail.tss2.gov.do; kerlin_delacruz@mail.tss2.gov.do', 'Error procesando el archivo ',e])

	oCurs.close()
	oConn.close()

		