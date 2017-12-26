# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_ra
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []


class pruebas_archivos_ra(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		
		self.assertEqual(archivos_ra.validar_encabezado("ERA123456789  ", stack_msg), True)
		self.assertEqual(archivos_ra.validar_encabezado("ENA123456789  ", stack_msg), True)
		self.assertEqual(archivos_ra.validar_encabezado("ERA12345678912", stack_msg), True)
		self.assertEqual(archivos_ra.validar_encabezado("ENA12345678912", stack_msg), True)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_ra.validar_encabezado(" RA12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado(" NA12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("DNA12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("SNA12345678912", []), False)

	def test_validar_encabezado_proceso(self):
		self.assertEqual(archivos_ra.validar_encabezado("E  12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("E  123456789  ", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EAC12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EAM12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EBO12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EDA12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EEP12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EMO12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ENV12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EPN12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EPT12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ERD12345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ET312345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ET412345678912", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("EVS12345678912", []), False)

	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_ra.validar_encabezado("ERA           ", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ENA           ", []), False)
		self.assertEqual(archivos_ra.validar_encabezado("ERA12345asdvfg", []), False)

	def test_validar_detalle(self):
		global stack_msg

		self.assertEqual(archivos_ra.validar_detalle("D999072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", stack_msg), True)

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_ra.validar_detalle(" 999072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("E999072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("S999072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)

	def test_validar_detalle_clave_nomina(self):
		self.assertEqual(archivos_ra.validar_detalle("D   072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("Dasc072009C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)

	def test_validar_detalle_periodo_aplicacion(self):
		self.assertEqual(archivos_ra.validar_detalle("D999      C00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D9990120asC00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)

	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_ra.validar_detalle("D999201401 00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D999201401P00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D999201401N00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D999201401U00100423417                                                                                                                                                0000000005437.470000000000000.00", []), False)

	def test_validar_detalle_numero_documento(self):
		self.assertEqual(archivos_ra.validar_detalle("D999201401C                                                                                                                                                           0000000005437.470000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D999201401C           00118179209                                                                                                                                     0000000005437.470000000000000.00", []), False)

	def test_validar_detalle_salario_ss(self):
		self.assertEqual(archivos_ra.validar_detalle("D999072009C00100423417                                                                                                                                                                0000000000000.00", []), False)
		self.assertEqual(archivos_ra.validar_detalle("D999072009C00100423417                                                                                                                                                0000000000asd.000000000000000.00", []), False)

	def test_validar_sumario(self):
		global stack_msg
		
		self.assertEqual(archivos_ra.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_ra.validar_sumario(" 000002", []), False)
		self.assertEqual(archivos_ra.validar_sumario("E000002", []), False)
		self.assertEqual(archivos_ra.validar_sumario("D000002", []), False)		

	def test_validar_sumario_numero_registros(self):
		self.assertEqual(archivos_ra.validar_sumario("Sas0002", []), False)
		self.assertEqual(archivos_ra.validar_sumario("S0000as", []), False)
		self.assertEqual(archivos_ra.validar_sumario("S      ", []), False)

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