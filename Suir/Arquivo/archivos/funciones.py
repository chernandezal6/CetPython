# coding=utf-8
import datetime as dt
import time
import re
import array
import os
import codecs
import main
import sys
import string
import hashlib


#Funcion para determinar si un caracter es numerico.
def is_numerico(campo):	
	return campo.isdigit()
	
#Funcion para validar si un caracter es o no decimal.
def is_decimal(campo):
 	
	if (not len(campo) >= 3):
		return False
	
	if (not campo[len(campo)-3] == '.'):
		return False
	
	if (campo < "0"):
		return False

	if (campo.endswith(" ", len(campo)-1)):
		return False

	try:
		float(campo)
	except Exception, e:
		return False

	return True
	
#Funcion si la fecha es valida en formato dd/mm/yyyy
def is_fecha(campo):
	
	if not len(campo.strip()) == 8:
		return False

	dias = campo[:2]
	meses = campo[2:4]
	year = campo[4:8]		

	fecha = dias + "/" + meses + "/" + year
	
	try:
	    campo = time.strptime(fecha, '%d/%m/%Y')
	except:
		return False

	return True

def is_fecha_vacia(campo):

	if len(campo.strip()) == 0 and len(campo) == 8:  
		return True
	else:	
		return is_fecha(campo)

def is_fecha_alterna_vacia(campo):
	
	if len(campo.strip()) == 0 and len(campo) == 8:
		return True
	else:	
		return is_fecha_alterna(campo)
	
	return True	

def is_fecha_alterna(campo):

	if not len(campo) == 8:
		return False

	year = campo[:4]
	meses = campo[4:6]
	dias = campo[6:8]		

	fecha = dias + "/" + meses + "/" + year

	try:
	    campo = time.strptime(fecha, '%d/%m/%Y')
	except:
		return False

	return True

#Existente en archivos dgt3 y dgt4
def is_fecha_vacaciones(tipo, campo, campo1):

	# Los 2 ultimos campos recibidos en esta funcion son una fecha correspondiente al incio de la vacaciones
	# y el segundo campo es el periodo correspondiente al que se esta enviando el archivo.

	#No registrar vacaciones de años anteriores al año actual o corriente (A = años anteriores)		
	if tipo == "A":	
		fecha_ini = campo[4:8]
		periodo_enviado = campo1[:4]				

		if fecha_ini < periodo_enviado:			
			return False
		else :
			return True

	#Fecha futura de la fecha de inicio de vacaciones (F = fecha futura)
	elif tipo == "F":		
		fecha_ini = campo[4:8]
		periodo_enviado = campo1[:4]				

		if fecha_ini > periodo_enviado:
			return False
		else:
			return True

	#Fechas de vacaciones del trabajador incompletas (I = Incompleta)
	elif tipo == "I":
		fecha_ini =  campo[:8]
		fecha_fin = campo1[:8]

		if (len(fecha_ini.strip()) == 0) and  (len(fecha_fin.strip())  == 0):
		 	return True
		elif (len(fecha_ini.strip()) == 8) and  (len(fecha_fin.strip())  == 8) :
	 		return True
	 	else:
	 	 	return False		

	#Fechas fin de vacacion invalida con relacion a la fecha inicio de vacacion (R = rango de fecha invalido)
	elif tipo == "R":

		dia = campo[:2]
		mes = campo[2:4]
		year = campo[4:8]

		dia1 = campo1[:2]
		mes1 = campo1[2:4]
		year1 = campo1[4:8]				

		fecha_ini = dia + "/" + mes + "/" + year
		fecha_fin = dia1 + "/" + mes1 + "/" + year1

		vac_ini = time.strptime(fecha_ini, '%d/%m/%Y')
		vac_fin = time.strptime(fecha_fin, '%d/%m/%Y')
	
		if (vac_ini) > (vac_fin):
			return False
		else:
			return True	
	
	return True	

#Funcion para validar si el campo es alfanumerico
def is_alfanumerico(campo):
	campo=campo.replace(" ", "")
	if not campo.isalnum():
		return False
	return True

def is_nombre_propio(campo, longitud):
	if len(campo.strip()) > 0:
		if not len(campo) == longitud:
			return False
	return True

def is_tipo_ingreso(campo):
    
	#Valida que tenga data, que sea numerico o alfanumerico y que no tenga espacios a la izquierda.
	if not is_numerico(campo.strip()):
		return False	
		
	if not len(campo.strip()) == 4:
		return False

	return True

#Funcion para validar que el periodo sea de 6 posiciones, numerico y formato mm/yyyy
def is_periodo(campo):

	if not len(campo) == 6:
		return False

	if not is_numerico(campo):
		return False

	meses = campo[:2]
	years = campo[2:6]
	
	if  ((meses > "0") and (meses <="12") and (years >= "2003") ):
		return True
	else :
		return False

#Para el uso de los archivos pensionados.
def is_periodo_alterno(campo):
	if not len(campo) == 6:
		return False

	if not is_numerico(campo):
		return False

	meses = campo[4:6]
	years = campo[:4]

	if  ((meses > "0") and (meses <="12") and (years >= "2002") ):
		return True
	else :
		
		return False

#Funcion para validar que el sexo sea F o M.		
def is_sexo(campo):
	if not (campo == "F" or campo == "M") :
		return False
	return True

def is_sexo_vacio(campo):
	if len(campo.strip()) > 0:
		return is_sexo(campo)
	return True	

#Valida las longitudes del campo y los literales.
def is_salario(campo):
	if len(campo.strip()) == 0:
		return False

	if not len(campo) == 16:
		return False

	return is_decimal(campo)

def is_salario_valido(campo):
	if len(campo.strip()) == 0:
		return False

	if not len(campo) == 16:
		return False

	if (campo[len(campo)-3] == '.') == True:
		return is_decimal(campo)
	else:
		return is_numerico(campo)	

def is_documento_valido(tipo, campo, longitud):

	if campo.startswith(" "):
		return False
	
	#verificamos que el valor en el campo enviado no contenga espacios.
	if ' ' in campo.strip():
		return  False

	if not len(campo) == longitud:	
		return False

	if tipo == "C":	
		if not len(campo.strip()) == 11:
			return False

		if not is_numerico(campo.strip()):
			return False			
	
	elif tipo == "N":

		if len(campo.strip()) > 10:
			return False

		if not is_numerico(campo.strip()):
			return False			

	elif tipo == "P":
		pass

	return True	


def is_rnc_o_cedula(campo):
	if not is_numerico(campo.strip()):
		return False

	#para que el rnc no pueda tener mas espacios de los correspondientes
	if not len(campo.strip()) == 11 and not len(campo.strip()) == 9:
		return False

	return True
#Para que se valide en caso de que el agente de retencion venga vacio que cumpla con los espacios indicados.	
def is_agente_retencion(campo):
	if len(campo.strip())>0:
		return is_rnc_o_cedula(campo)
	return True

def is_tipo_documento(campo):
	
	if campo.startswith(" "):
		return False

	if not campo.strip() == "C" and not campo.strip() == "P" and not campo.strip() == "N":
		return False
		
	if len(campo.strip()) == 0:
		return False	
	return True
	
def is_nacionalidad_vacia(campo):

	if len(campo.strip()) > 0:
		return is_nacionalidad(campo)
	return True	

def is_nacionalidad(campo):

	if not len(campo) == 3:
		return False
	
	if not is_numerico(campo.strip()):
		return False

	return True			
	
def is_tipo_novedad(campo, tipo_archivo):

	if tipo_archivo == "T3" or tipo_archivo == "T4":
		if not len(campo) == 3:
			return False

		if tipo_archivo == "T3" and campo.strip() != "NI":
			return False

		#Se hace de esta manera porque el tipo de novedad en estos tipos de archivo termina en espacios en blanco.		
		if not campo.strip() in ("NI","NS","NC"):	
			return False

	if tipo_archivo == "PN":

		if not (campo == "A" or campo == "B"):
			return False

	if tipo_archivo == "NV":

		if not len(campo) == 2:
			return False

		if campo != "AD" and campo != "IN" and campo != "SA" and campo != "VC" and campo != "LM" and campo != "LV" and campo != "LD":
			return False		
	
	if tipo_archivo == "RD":
		if not len(campo) == 2:
			return False

		if campo != "ID" and campo != "SD":
			return False	
 	return True

#Existente en archivos dgt3 y dgt4
def is_ocupacion(campo):
	if len(campo.strip()) == 0:
		return False
 	if len(campo) != 150:
 		return False
 	return True

#Para archivos de pagos.
def is_hora(campo):

	if not len(campo) ==5:
		return False

	horas = campo[:2]
	minutos = campo[2:4]

	hora = horas + minutos
	
	try:
	    campo = time.strptime(hora, '%H:%M')

	except:
		return False

	return True

def is_telefono(campo):
	if len(campo.strip()) > 0:
		if len(campo.strip()) != 10:
			return False
		else:	
			return is_numerico(campo)
	return True	

#Para grabar en el archivo de log algun error que pueda suceder con la conexion a base de datos
def grabar_log(tipo, msg):

	now = dt.datetime.now()
	now = now.strftime("%d-%m-%Y %H:%M:%p")	
	
	if len(main.ruta_general()) == 0:
		print(now +' - '+ msg + '\n')
	else:
		log_file = main.ruta_general() + "\logfile.txt"
		fh = open(log_file, 'a')
		fh.write(now +' - '+ msg + '\n')
		fh.close()

#funcion para la creacion del numero de hash del archivo
def crear_hash_archivo(linea):
	return hash(linea) & 0xffffffff

def crear_hash_md5(md5,linea):
	
	md5.update( linea.encode('ascii', 'ignore'))
	numHash =  md5.hexdigest()
	return numHash

if __name__ == "__main__":
	
	md5 = hashlib.md5()
	print crear_hash_md5(md5,'')
	pass
