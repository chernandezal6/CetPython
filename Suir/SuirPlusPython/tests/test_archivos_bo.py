# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_bo
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_bo(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		self.assertEqual(archivos_bo.validar_encabezado("EBO12345678912122012", stack_msg), True)
		self.assertEqual(archivos_bo.validar_encabezado("EBO  345678912122012", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_bo.validar_encabezado("DBO12345678912122012", []), False)
		self.assertEqual(archivos_bo.validar_encabezado(" BO12345678912122012", []), False)
	
	def test_validar_encabezado_proceso(self):
		self.assertEqual(archivos_bo.validar_encabezado("EAM12345678912122012", []), False)
		self.assertEqual(archivos_bo.validar_encabezado("ENV12345678912122012", []), False)
		self.assertEqual(archivos_bo.validar_encabezado("E  12345678912122012", []), False)
	
	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_bo.validar_encabezado("EBO           122012", []), False)

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_bo.validar_encabezado("EBO" + i + "122012", []), False)
	
	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_bo.validar_encabezado("EBO12345678912      ", []), False)
		self.assertEqual(archivos_bo.validar_encabezado("EBO12345678912201212", []), False)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_bo.validar_encabezado("EBO123452102012", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_bo.validar_encabezado("EBO1234567892541092012", []), False)

	def test_validar_detalle(self):
		global stack_msg 
		self.assertEqual(archivos_bo.validar_detalle("DC00118179209                                                                                                                                                         0000000012545.00", stack_msg), True)#182 posiciones		

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_bo.validar_detalle(" PRD-125481                kerlin santiago                                   de la cruz                              alvarez                                 M291119870000000012545.00", []), False)
		self.assertEqual(archivos_bo.validar_detalle("APRD-125481                kerlin santiago                                   de la cruz                              alvarez                                 M291119870000000012545.00", []), False)

	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_bo.validar_detalle("DARD-125481                kerlin santiago                                   de la cruz                              alvarez                                 M291119870000000012545.00", []), False)
		self.assertEqual(archivos_bo.validar_detalle("D RD-125481                kerlin santiago                                   de la cruz                              alvarez                                 M291119870000000012545.00", []), False)

	def test_validar_detalle_monto_bonificacion(self):
		self.assertEqual(archivos_bo.validar_detalle("DC00118179209                                                                                                                                                         0000000000000	.00", []), False)
		self.assertEqual(archivos_bo.validar_detalle("DPRD-125481                kerlin santiago                                   de la cruz                              alvarez                                 M29111987                ", []), False)

	def test_validar_detalle_fecha_nacimiento(self):
		self.assertEqual(archivos_bo.validar_detalle("DP00118179209                                                                                                                                                 000000000000000012545.00", []), False) # fecha rellena de 0
		self.assertEqual(archivos_bo.validar_detalle("DP00118179209                                                                                                                                                 198712120000000012545.00", []), False) # formato de la fecha invalido

	def test_validar_detalle_caracteres_en_nro_documento(self):
		i = cons.char_especiales [:25]
		self.assertEqual(archivos_bo.validar_detalle("DP" + i +                                                                                                                                                          "0000000012545.00", []), False)	

	def test_validar_sumario(self):
		global stack_msg 
		self.assertEqual(archivos_bo.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_bo.validar_sumario(" 000000", []), False)
		self.assertEqual(archivos_bo.validar_sumario("A000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_bo.validar_sumario("       ", []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_bo.validar_sumario("S000", []), False)
		self.assertEqual(archivos_bo.validar_sumario("", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_bo.validar_sumario("S00000000", []), False)

	def test_validar_sumario_con_letras(self):
		i = cons.char_especiales [:6]
		self.assertEqual(archivos_bo.validar_sumario("S" + i , []), False)
		self.assertEqual(archivos_bo.validar_sumario("Sadf122", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_bo.validar_sumario("S  0000", []), False)
		self.assertEqual(archivos_bo.validar_sumario("S00000 ", []), False)

	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()

		global stack_msg
		registros = ['DC09400069515              Jose Octavio                                      Estevez                                 Garcia                                  M        0000000034410.41']
		id_envio = ''

		self.assertRaises(TypeError, lambda: archivos_bo.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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