import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')
import base64
import os.path
import cx_Oracle
import archivos
from ConfigParser import SafeConfigParser
import funciones
import main
import traceback

# Funcion para leer desde el archivo de conexion config.cnf.
def connString():
	try:
		resultado = ""
		config_file = main.ruta_general() + '\config.cnf'
		
		if not os.path.isfile(config_file):
			config_file = '..\config.cnf'
		
		if not os.path.isfile(config_file):
			config_file = 'config.cnf'
			
		if not os.path.isfile(config_file):
			funciones.grabar_log("E", "Error en la conexion a base de datos, tipo: " + archivos.tipo_archivo  + ", envio:" + archivos.envio)

		parser = SafeConfigParser()
		parser.read(config_file)
		oConnString = parser.get('db', 'oConnString')

		return oConnString

	except:
		exc_info = sys.exc_info()
		stack_msg.append("Error en la connection %s , (%s)" % (iLineas, exc_info[1]))

def insert(sql):
	oConn = cx_Oracle.connect(connString().decode("base64"))
	global oCurs
	oCurs = oConn.cursor()
	oCurs.execute(sql)
	oConn.commit()
	oCurs.close()
	oConn.close()

def borrar_tmp_movimiento(id_envio, tipo_movimiento, oCurs):
	if tipo_movimiento.upper() in ["RD","DA", "NV", "AR", "AM", "BO", "VS", "RA", "RT" ]:
		insert("delete from suirplus.sre_tmp_movimiento_t t where t.id_recepcion = '" + id_envio + "'")
	
	elif tipo_movimiento.upper() in ["AC", "EP"]:
		insert("delete from suirplus.sre_tmp_movimiento_recaudo_t t where t.id_recepcion = '" + id_envio + "'")

	elif  tipo_movimiento.upper() in ["PN", "PT"]:
		insert("delete from suirplus.seh_det_nov_tmp_t t where t.id_recepcion = '" + id_envio + "'")
	else:
		pass
		
def marcar_status_archivo(id_envio, resultado, stack_msg, usuario_carga):
	#erPy = [x[0:3] for x in stack_msg]

	Er = [x[0:4] for x in stack_msg]
	if Er in (["E650"],["E500"],["E600"]):		
		try:
			insert("update suirplus.sre_archivos_t a set  id_error = 'PY2' , status = 'R', registros_bad = '"+ str(len(stack_msg)) +"' , ult_fecha_act=sysdate, ult_usuario_act='"+ usuario_carga +"'  where id_recepcion = '"+ id_envio + "'")
		except Exception, e:
			stack_msg.append(" Error actualizando el archivo en sre_archivos_t (Oracle: %s)  " % (e))			

	elif resultado == "R":
			insert("update suirplus.sre_archivos_t a set  id_error = 'PY1' , status = 'R', registros_bad = '"+ str(len(stack_msg)) +"' , ult_fecha_act=sysdate, ult_usuario_act='"+ usuario_carga +"'  where id_recepcion = '"+ id_envio + "'")


def marcar_error_archivo(id_envio, tipo_movimiento, linea, stack_msg, usuario_carga):
	tipo_movimiento = tipo_movimiento.upper()
	error = stack_msg[1:4]
	stack_mens = stack_msg 
	stack_msg = stack_msg[5:200]

	#para errores de estructura basica(E=encabezado, D=detalle,S=sumario)limpiamos los mensajes...
	if tipo_movimiento in ["RD","DA", "NV", "AR", "AM","MO", "BO", "VS", "RA", "RT"] :		
		if error in ("650","500","600"):
			try:			
				insert("insert into suirplus.sre_tmp_movimiento_t (id_recepcion, secuencia_movimiento, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), 'PY2',('R'), ('"+ stack_msg +"'), sysdate, ('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en sre_tmp_movimiento_t (Oracle: %s)  " % (e))
		else:
			try:			
				insert("insert into suirplus.sre_tmp_movimiento_t (id_recepcion, secuencia_movimiento, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), ('PY1'),('R'), ('"+ stack_mens +"'), sysdate, ('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en sre_tmp_movimiento_t (Oracle: %s)  " % (e))		
		
	elif tipo_movimiento  in ["AC","EP"]:
		if error in ("650","500","600"):
			try:			
				insert("insert into suirplus.sre_tmp_movimiento_recaudo_t (id_recepcion, secuencia_mov_recaudo, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), ('PY2'),('RE'), ('"+ stack_msg +"'), sysdate,('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en sre_tmp_movimiento_recaudo_t (Oracle: %s)  " % (e))		
		else:		
			try:
				insert("insert into suirplus.sre_tmp_movimiento_recaudo_t (id_recepcion, secuencia_mov_recaudo, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), ('PY1'),('RE'), ('"+ stack_msg +"'), sysdate,('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en sre_tmp_movimiento_recaudo_t (Oracle: %s)  " % (e))			

	elif tipo_movimiento  in ["PN", "PT"]:
		if error in ("650","500","600"):
			try:			
				insert("insert into suirplus.seh_det_nov_tmp_t (id_recepcion, secuencia, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), ('PY2'),('R'), ('"+ stack_msg +"'), sysdate,('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en seh_det_nov_tmp_t (Oracle: %s)  " % (e))		
		else:
			try:
				insert("insert into suirplus.seh_det_nov_tmp_t (id_recepcion, secuencia, id_error,status, observacion,ult_fecha_act, ult_usuario_act)  values (( '"+ id_envio +"'), ('"+ str(linea) +"'), ('PY1'),('R'), ('"+ stack_msg +"'), sysdate,('"+ usuario_carga +"'))")
			except Exception, e:
				stack_msg.append(" Error insertando el archivo en seh_det_nov_tmp_t (Oracle: %s)  " % (e))		
	else:
		pass	

def marcar_hash_archivo(id_envio, numHash, stack_msg):

	try:
		insert("update suirplus.sre_archivos_t a set  numero_hash = '"+ str(numHash) +"' where id_recepcion = '"+ str(id_envio) + "'")
	except Exception, e:
		stack_msg.append(" Error insertando numero Hash para el archivo (Oracle: %s)  " % (e))

if __name__ == '__main__':

	#print ("Probando connection a la db")	
	#print insert("select id_modulo,ftp_dir from srp_config_t where id_modulo = 'ARCHI_PY'")
	#print ("Prueba superada..!!")
	
	pass
