# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_da
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_da(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		self.assertEqual(archivos_da.validar_encabezado("EDA123456789121234567893214567", stack_msg), True)
		self.assertEqual(archivos_da.validar_encabezado("EDA003456789121234567893214567", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_da.validar_encabezado(" DA123456789121234567893214567", []), False)
		self.assertEqual(archivos_da.validar_encabezado("SDA123456789121234567893214567", []), False)
		self.assertEqual(archivos_da.validar_encabezado("1DA123456789121234567893214567", []), False)

	def test_validar_encabezado_proceso(self):
		self.assertEqual(archivos_da.validar_encabezado("E  123456789121234567893214567", []), False)
		self.assertEqual(archivos_da.validar_encabezado("EBO123456789121234567893214567", []), False)
		self.assertEqual(archivos_da.validar_encabezado("ENV123456789121234567893214567", []), False)
		self.assertEqual(archivos_da.validar_encabezado("EAM123456789121234567893214567", []), False)

	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_da.validar_encabezado("EDA  3456789121234567893214567", []), False)
		i = cons.char_especiales [:11]
		self.assertEqual(archivos_da.validar_encabezado("EDA" + i + "1234567893214567", []), False)

	def test_validar_encabezado_nro_reclamacion(self):
		self.assertEqual(archivos_da.validar_encabezado("EDA12345678912123456789AB14567", []), False)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_da.validar_encabezado("EDA123456789121234567893214", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_da.validar_encabezado("EDA123456789121234567893214567123123", []), False)

	def test_validar_detalle(self):
		global stack_msg
		self.assertEqual(archivos_da.validar_detalle("D123456789123456712345678912              0000000000123.000000000000123.00P001", stack_msg), True)
		self.assertEqual(archivos_da.validar_detalle("D123456789123456712345678912              00000000000000000000000000000000T001", stack_msg), True)

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_da.validar_detalle(" 201212345678912300000000000000001181792090000000000000.000000000000000.00T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("S201212345678912300000000000000001181792090000000000000.000000000000000.00T001", []), False)

	def test_validar_detalle_nro_referencia(self):
		self.assertEqual(archivos_da.validar_detalle("D2012254!@#$%^&*(00000000000000001181792090000000000000.000000000000000.00T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D                00000000000000001181792090000000000000.000000000000000.00T001", []), False)

	def test_validar_detalle_nro_documento(self):
		self.assertEqual(archivos_da.validar_detalle("D2012123456789123              001181792090000000000000.000000000000000.00T001", []), False)
		
	def test_validar_detalle_salario(self):
		self.assertEqual(archivos_da.validar_detalle("D20121234567891230000000000000000118179209                0000000000000.00T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D2012123456789123000000000000000011817920900000000000000000000000000000.00T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D20121234567891230000000000000000118179209sadjn00000000.000000000000000.00T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D2012123456789123000000000000000011817920900000000000000000000000000000.00P001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000000000000.00P001", []), False)

	def test_validar_detalle_aportes_voluntario(self):
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.00                T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000000000000000T001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000ansc00000.00T001", []), False)

	def test_validar_detalle_tipo_reclamacion(self):
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000000000000.00 001", []), False)
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000000000000.00M001", []), False)

	def test_validar_detalle_motivo_devolucion(self):
		self.assertEqual(archivos_da.validar_detalle("D201212345678912300000000000000001181792090000000000000.000000000000000.00T   ", []), False)


	def test_validar_sumario(self):
		global stack_msg
		self.assertEqual(archivos_da.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_da.validar_sumario("C000000", []), False)
		self.assertEqual(archivos_da.validar_sumario(" 000000", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_da.validar_sumario("S      ", []), False)
		self.assertEqual(archivos_da.validar_sumario("S   000", []), False)

	def test_validar_sumario_con_letras(self):
		self.assertEqual(archivos_da.validar_sumario("S00asd0", []), False)
		i = cons.char_especiales [:6]
		self.assertEqual(archivos_da.validar_sumario("S" + i, []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_da.validar_sumario("S000", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_da.validar_sumario("S0000000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_da.validar_sumario("       ", []), False)

	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()

		global stack_msg
		registros = ['D052012146433350500000000000000031038090790000000000000.000000000000000.00P002']
		id_envio = ''

		self.assertRaises(TypeError, lambda: archivos_da.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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