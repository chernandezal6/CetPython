# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_rd
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_rd(unittest2.TestCase):
	def test_validar_encabezado(self):
		global stack_msg
		self.assertEqual(archivos_rd.validar_encabezado("ERD12345678932", stack_msg), True)
		self.assertEqual(archivos_rd.validar_encabezado("ERD  345678932", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_rd.validar_encabezado("ARD12345678912", []), False)
		self.assertEqual(archivos_rd.validar_encabezado(" RD12345678912", []), False)

	def test_validar_encabezado_tipo_proceso(self):
		self.assertEqual(archivos_rd.validar_encabezado("E  12345678912", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("ENV12345678912", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("EAM12345678912", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("EAR12345678912", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("EBO12345678912", []), False)

	def test_validar_encabezado_rnc_o_cedula_con_espacios(self):
		self.assertEqual(archivos_rd.validar_encabezado("ERD           ", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("ERD123456     ", []), False)

	def test_validar_encabezado_rnc_o_cedula_con_letras(self):
		self.assertEqual(archivos_rd.validar_encabezado("ERD1235sdgr222", []), False)

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_rd.validar_encabezado("ERD" + i , []), False)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_rd.validar_encabezado("ERD12564", []), False)
		self.assertEqual(archivos_rd.validar_encabezado("", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_rd.validar_encabezado("ERD1234569874521", []), False)

	def test_validar_detalle(self):

		global stack_msg
		self.assertEqual(archivos_rd.validar_detalle("D001C00112458161IDN000741064  pepe                                              coco                                    moreno                                  ", stack_msg), True)
		#self.assertEqual(archivos_rd.validar_detalle("D001N00584131932SD                                                                                                                                N00012923784", stack_msg), False) #Longitud menor, 158
		#self.assertEqual(archivos_rd.validar_detalle("D001N00584131932SD                                                                                                                                N00012923784", stack_msg), False)


	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_rd.validar_detalle("S001N584131932                                                                                                                                    N12923784   ", []), False)
		self.assertEqual(archivos_rd.validar_detalle(" 001N584131932                                                                                                                                    N12923784   ", []), False)

	def test_validar_detalle_clave_nomina(self):
		self.assertEqual(archivos_rd.validar_detalle("S   N584131932                                                                                                                                    N12923784   ", []), False)
		self.assertEqual(archivos_rd.validar_detalle("SABCN584131932                                                                                                                                    N12923784   ", []), False)

	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_rd.validar_detalle("D001 00118179209                                                                                                                                  C00102149002", []), False)
		self.assertEqual(archivos_rd.validar_detalle("D001A00118179209                                                                                                                                  C00102149002", []), False)

	def test_validar_detalle_nro_documento(self):

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_rd.validar_detalle("D001C" + i +                                                                                                                                   "C00102149002", []), False)
		self.assertEqual(archivos_rd.validar_detalle("D001C00118179209                                                                                                                                  C!@#$%^&*()-", []), False)

	def test_validar_sumario(self):

		global stack_msg
		self.assertEqual(archivos_rd.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_rd.validar_sumario("C000000", []), False)
		self.assertEqual(archivos_rd.validar_sumario(" 000000", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_rd.validar_sumario("S      ", []), False)
		self.assertEqual(archivos_rd.validar_sumario("S   000", []), False)

	def test_validar_sumario_con_letras(self):
		self.assertEqual(archivos_rd.validar_sumario("S00asd0", []), False)

		i = cons.char_especiales [:6]
		self.assertEqual(archivos_rd.validar_sumario("S" + i, []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_rd.validar_sumario("S000", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_rd.validar_sumario("S0000000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_rd.validar_sumario("       ", []), False)

	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()
		
		global stack_msg
		registros = ['D001C05600170764IDC05600631674                                                                                                                                  ']
		id_envio = ''

		self.assertRaises(TypeError, lambda: archivos_rd.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])
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


