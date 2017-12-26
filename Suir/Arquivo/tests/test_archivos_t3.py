import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_t3
from archivos_t3 import *
import unittest2
import teamcity
import teamcity.unittestpy
import array
import cons
import db
import cx_Oracle

stack_msg = []
registros = []
periodo_encabezado = ""

class pruebas_archivos_t3(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		self.assertEqual(archivos_t3.validar_encabezado("ET312345678912122012", stack_msg), True)
		self.assertEqual(archivos_t3.validar_encabezado("ET312345678900112012", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_t3.validar_encabezado(" T312345678912012012", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("AT312345678912012012", []), False)

	def test_validar_encabezado_tipo_novedad(self):
		self.assertEqual(archivos_t3.validar_encabezado("E  12345678912012012", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("ENV12345678912012012", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("EAM12345678912012012", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("EBO12345678912012012", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("EPN12345678912012012", []), False)

	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_t3.validar_encabezado("ET312345678912      ", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("ET312345678912201212", []), False)
		self.assertEqual(archivos_t3.validar_encabezado("ET312345678912201abs", []), False)

	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_t3.validar_encabezado("ET3  123456789", []), False)

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_t3.validar_encabezado("ET3" + i + "122012", []), False)

	def test_validar_encabezado_en_blanco(self):
		self.assertEqual(archivos_t3.validar_encabezado("                    ", []), False)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_t3.validar_encabezado("ET3125458122012", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_t3.validar_encabezado("ET3123456789121220121005", []), False)

	def	test_validar_detalle(self):
		global stack_msg
		self.assertEqual(archivos_t3.validar_detalle("DNI PG122545599                                                                                                                                                 09121986F0000000015100.00011020130000206RECEPCONISTAAa                                                                                                                                       0106201415062014000003000001  4        VACACIONES COLECTIVAS                                                                                                                         ", "201401",stack_msg), True)
		#self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                    09121986F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0110201422102014000001000001001  1        VACACIONES COLECTIVAS                                                                                                                      ", stack_msg), True)
		#self.assertEqual(archivos_t3.validar_detalle("DNI N18179209                                                                                                                                                           M0000000000000.0012122012001908bombero                                                                                                                                               1212201212122012000123000123                                                                                                                                                         ", stack_msg), True)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ","201401", stack_msg), True)

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", stack_msg), True)
		self.assertEqual(archivos_t3.validar_detalle("DNI P000154236                    JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", stack_msg), True)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0110201422102014000001000001001           VACACIONES COLECTIVAS                                                                                                                      ", "201401", stack_msg), True)		
		
	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_t3.validar_detalle("SNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle(" NI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_tipo_novedad(self):
		self.assertEqual(archivos_t3.validar_detalle("DNC C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("SNS C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI  00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI M00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_sexo(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                            0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           P0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_salario(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           M                30092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           M00000000000000aa30092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_fecha_ingreso(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F               30012011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.88300520as005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_ocupacion(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830052011      ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830052011asc210ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_ocupacion_des(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416                                                                                                                                                      0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_fechas_vacaciones(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA        30022014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA30012014        000001000001001                                                                                                                                                      ", "201401", []), False)
	
	def test_validar_detalle_turno(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014      000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014123asc000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_localidad(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001      001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t3.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014      000acv001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_nacionalidad(self):
		self.assertEqual(archivos_t3.validar_detalle("DNI P00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001                                                                                                                                                         ", "201401", []), False)

	def test_validar_sumario(self):
		global stack_msg
		self.assertEqual(archivos_t3.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_t3.validar_sumario("C000000", []), False)
		self.assertEqual(archivos_t3.validar_sumario(" 000000", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_t3.validar_sumario("S      ", []), False)
		self.assertEqual(archivos_t3.validar_sumario("S   000", []), False)

	def test_validar_sumario_con_letras(self):
		self.assertEqual(archivos_t3.validar_sumario("S00asd0", []), False)

		i = cons.char_especiales [:6]
		self.assertEqual(archivos_t3.validar_sumario("S" + i, []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_t3.validar_sumario("S000", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_t3.validar_sumario("S0000000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_t3.validar_sumario("       ", []), False)

	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()
		
		global stack_msg
		registros = ['DNI C00114675887                SILVESTRE                                         SORIANO                                 SOSA                                    01/02/19M000000000001300016072006005405AGENTE DE ALQUILER                                                                                                                                    1607201202082012000003000002   todos los horarios de almuerzo y descanzo semanal son rotativo                                                                                        ']
		id_envio = ''

		self.assertRaises(TypeError, lambda: archivos_t3.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])
		oConn.commit()
		oCurs.close()
		oConn.close()'''

	def tearDown(self):
		global stack_msg

		if len(stack_msg) > 0:
			print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"
			for x in stack_msg:
			    print x
			print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-"

if __name__ == '__main__':

    #unittest2.main()

    #if teamcity.underTeamcity():
    #    runner = teamcity.unittestpy.TeamcityTestRunner()
    #    unittest2.main(testRunner=runner)
    #else:
    #    suite = unittest2.TestLoader().loadTestsFromTestCase(Funciones)
    #    unittest2.TextTestRunner(verbosity=2).run(suite)
    pass 
