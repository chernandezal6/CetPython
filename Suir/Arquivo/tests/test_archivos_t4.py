import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_t4
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_t4(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		self.assertEqual(archivos_t4.validar_encabezado("ET412345678912122010", stack_msg), True)
		self.assertEqual(archivos_t4.validar_encabezado("ET412345678900112009", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_t4.validar_encabezado(" T412345678912012012", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("AT412345678912012012", []), False)

	def test_validar_encabezado_tipo_novedad(self):
		self.assertEqual(archivos_t4.validar_encabezado("E  12345678912012012", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("ENV12345678912012012", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("EAM12345678912012012", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("EBO12345678912012012", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("EPN12345678912012012", []), False)

	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_t4.validar_encabezado("ET412345678912      ", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("ET412345678912201212", []), False)
		self.assertEqual(archivos_t4.validar_encabezado("ET412345678912201abs", []), False)

	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_t4.validar_encabezado("ET4125bnfd1542122012", []), False)

	def test_validar_encabezado_en_blanco(self):
		self.assertEqual(archivos_t4.validar_encabezado("                    ", []), False)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_t4.validar_encabezado("ET4125458122012", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_t4.validar_encabezado("ET4123456789121220121005", []), False) #encabezado

	def test_validar_detalle(self):
		global stack_msg		

		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", stack_msg), True)
		self.assertEqual(archivos_t4.validar_detalle("DNC C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", stack_msg), True)
		self.assertEqual(archivos_t4.validar_detalle("DNS C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.88        30052012005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001                                                                                                                                                         ", "201401", stack_msg), True)
		self.assertEqual(archivos_t4.validar_detalle("DNS C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.883001201230052012005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001                                                                                                                                                         ", "201401", stack_msg), True)

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_t4.validar_detalle(" NI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("SNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("ENI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_tipo_novedad(self):
		self.assertEqual(archivos_t4.validar_detalle("DLV C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("D   C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DAD C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DIN C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DVC C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DLM C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DLD C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DSA C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI  00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI M00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNC  00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNC M00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNS  00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNS M00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_sexo(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                            0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           S0000000042978.8830092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_salario(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           M                30092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F                30092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           M0000000000000asd30092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000000000asd30092011        005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_detalle_fecha_ingreso(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.88                005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           M0000000042978.88                005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_detalle_fecha_salida(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.883001201230052012005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNC C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.883001201230052012005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNC C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.88        30052012005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNS C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.88                005416ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_ocupacion_des(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        005416                                                                                                                                                      0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_detalle_ocupacion(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011              ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011        asd123ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000001000001001                                                                                                                                                      ", "201401", []), False)

	def test_validar_detalle_turno(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011              ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014      000001001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011              ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014asd123000001001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_detalle_localidad(self):
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011              ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000123      001                                                                                                                                                      ", "201401", []), False)
		self.assertEqual(archivos_t4.validar_detalle("DNI C00113918122                  JRIewQdsAAa                                                                                                                           F0000000042978.8830092011              ADMINISTRADORAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0102201422052014000123asd123001                                                                                                                                                      ", "201401", []), False)
		
	def test_validar_sumario(self):
		global stack_msg
		self.assertEqual(archivos_t4.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_t4.validar_sumario("C000000", []), False)
		self.assertEqual(archivos_t4.validar_sumario(" 000000", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_t4.validar_sumario("S      ", []), False)
		self.assertEqual(archivos_t4.validar_sumario("S   000", []), False)

	def test_validar_sumario_con_letras(self):
		self.assertEqual(archivos_t4.validar_sumario("S00asd0", []), False)

		i = cons.char_especiales [:6]
		self.assertEqual(archivos_t4.validar_sumario("S" + i, []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_t4.validar_sumario("S000", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_t4.validar_sumario("S0000000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_t4.validar_sumario("       ", []), False)

	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()
		
		global stack_msg
		id_envio = ''
		registros = ['DNS C22800024063              Daiky Franchesca                                  Acevedo                                 Cabrera                                 29051990F0000000000010000        30092012004014NINGUNO                                                                                                                                                               000001000002  1NINGUNA                                                                                                                                               ']

		self.assertRaises(TypeError, lambda: archivos_t4.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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
