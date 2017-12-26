# coding=utf-8
import os
import db
import archivos
from sys import argv
import sys
import funciones
import shlex


def config_file():
	return ruta_general() + '\config.cnf'

def ruta_general():
	
	if not os.environ.has_key("path_fix"):
		os.environ["path_fix"] = ""

	return os.environ["path_fix"]


if __name__ == "__main__":
	
	try:
		script, archivo, id_envio,tipo, usuario_carga= argv				
		path_fix = os.path.dirname(os.path.abspath(sys.argv[0]))
		path_fix = path_fix[0:path_fix.index('\\archivos')]
		os.environ["path_fix"] = path_fix

	except Exception, e:
		# Aqui no se puede grabar en el log ya que el problema viene desempaquetando las variables
		# y el path viene desde una de las variables
		funciones.grabar_log("E", "Error desempaquetando las variables - " + str(e))
		sys.exit(-1)

		funciones.grabar_log("I", "-=-=-=--=-=-=--=-=-=--=-=-=--=-=-=-")
		funciones.grabar_log("I", "Inicio del proceso (main.py)")
		funciones.grabar_log("I", "script: " + script)
		funciones.grabar_log("I", "archivo: " + archivo)
		funciones.grabar_log("I", "id_envio: " + id_envio)
		funciones.grabar_log("I", "tipo: " + tipo)
		funciones.grabar_log("I", "usuario_carga: " + usuario_carga)

	oCurs = ""
	envio = ""

	os.system('cls')	
	archivos.procesar(archivo, id_envio, tipo, usuario_carga)
