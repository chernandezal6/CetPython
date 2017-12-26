# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_rt
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []


class pruebas_archivos_rt(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg
		
		self.assertEqual(archivos_rt.validar_encabezado("ERT  123456789052014", stack_msg), True)
		self.assertEqual(archivos_rt.validar_encabezado("ERT12345678912052014", stack_msg), True)
		self.assertEqual(archivos_rt.validar_encabezado("ERT123456789  052014", stack_msg), True)			

	def test_validar_encabezado_tipo_registro(self):

		self.assertEqual(archivos_rt.validar_encabezado(" RT12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("DRT12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("SRT12345678912052014", []), False)			

	def test_validar_encabezado_proceso(self):
		self.assertEqual(archivos_rt.validar_encabezado("E  12345678912052014", []), False)		
		self.assertEqual(archivos_rt.validar_encabezado("EAC12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EAM12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EBO12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EDA12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EEP12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EMO12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ENV12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EPN12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EPT12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ERD12345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ET312345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ET412345678912052014", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("EVS12345678912052014", []), False)

	def test_validar_encabezado_rnc_o_cedula(self):
		self.assertEqual(archivos_rt.validar_encabezado("ETR           052014", []), False)		
		self.assertEqual(archivos_rt.validar_encabezado("ERA12345asdvfg052014", []), False)

	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_rt.validar_encabezado("ERT  123456789      ", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ERT12345678912      ", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ERT  12345678905201a", []), False)
		self.assertEqual(archivos_rt.validar_encabezado("ERT12345678912as2014", []), False)

	def test_validar_detalle(self):
		global stack_msg

		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DNN000116486                LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DNP00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DPC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DPN1164867211               LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DPN011648672                LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)
		self.assertEqual(archivos_rt.validar_detalle("DPP00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", stack_msg), True)

	def test_validar_detalle_tipo_registro(self):
		self.assertEqual(archivos_rt.validar_detalle(" NC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("ENC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("SNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_tipo_trabajador(self):
		self.assertEqual(archivos_rt.validar_detalle("D C00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("DAC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("D1C00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_numero_documento(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC                         LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_sexo(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                 N        0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                 1        0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_fecha_nacimiento(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                  120520re0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                  asdvfgrt0000000083900.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		
	def test_validar_detalle_salario_isr(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                                          0000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          00000000df121.000000000055888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_otras_remuneraciones(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.0000000000aa888.72  1308314750000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_rnc_agente_retencion(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.000000000055888.72aa1308314750000000000000.000000000006448.680000000000000.00", []), False)
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.000000000055888.72  12345asdf0000000000000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_remuneraciones_otros_agentes(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.000000000055888.72  12345524100000000aa000.000000000006448.680000000000000.00", []), False)

	def test_validar_detalle_ingresos_exentos(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.000000000055888.72  1234552410000000000000.00000000000aa48.680000000000000.00", []), False)

	def test_validar_detalle_saldo_a_favor(self):
		self.assertEqual(archivos_rt.validar_detalle("DNC00116486721              LAURA ANDREA                                      GONZALEZ                                AUFFANT                                          0000000012121.000000000055888.72  1234552410000000000000.000000000004548.6800000000ss000.00", []), False)		
	
	def test_validar_sumario(self):
		global stack_msg
		
		self.assertEqual(archivos_rt.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_tipo_registro(self):
		self.assertEqual(archivos_rt.validar_sumario(" 000002", []), False)
		self.assertEqual(archivos_rt.validar_sumario("E000002", []), False)
		self.assertEqual(archivos_rt.validar_sumario("D000002", []), False)		

	def test_validar_sumario_numero_registros(self):
		self.assertEqual(archivos_rt.validar_sumario("Sas0002", []), False)
		self.assertEqual(archivos_rt.validar_sumario("S0000as", []), False)
		self.assertEqual(archivos_rt.validar_sumario("S      ", []), False)

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
