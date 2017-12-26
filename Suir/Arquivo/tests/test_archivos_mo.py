# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_mo
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_mo(unittest2.TestCase):

	def test_validar_encabezado(self):

		global stack_msg

		self.assertEqual(archivos_mo.validar_encabezado("EMO  123456789122012", stack_msg), True)
		self.assertEqual(archivos_mo.validar_encabezado("EMO12345678978012012", stack_msg), True)

	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_mo.validar_encabezado("EMO12345678998", []), False)
		self.assertEqual(archivos_mo.validar_encabezado("EMO123456789129", []), False)

	def test_validar_encabezado_tipo_registro(self):
		self.assertEqual(archivos_mo.validar_encabezado("AMO12345678912122012", []), False)
		self.assertEqual(archivos_mo.validar_encabezado(" MO12345678912122012", []), False)

	def test_validar_encabezado_longitud_mayor(self):
		self.assertEqual(archivos_mo.validar_encabezado("EMO001234567892012121258", []), False)

	def test_validar_encabezado_constante(self):
 		self.assertEqual(archivos_mo.validar_encabezado("MO123456789128888000", []), False)
 		self.assertEqual(archivos_mo.validar_encabezado("#EMO0012345678912012", []), False)

 	def test_validar_encabezado_tipo_registro(self):
 		self.assertEqual(archivos_mo.validar_encabezado("ENV00145678987999999", []), False)
 		self.assertEqual(archivos_mo.validar_encabezado("EAR00145678998888888", []), False)
 		self.assertEqual(archivos_mo.validar_encabezado("E  12345678912888888", []), False)

	def test_validar_encabezado_con_espacios_izquierda(self):
		self.assertEqual(archivos_mo.validar_encabezado(" EMO1234567899822222", []), False)

	def test_validar_encabezado_con_letras_rnc(self):
		self.assertEqual(archivos_mo.validar_encabezado("EMO001234gb789@22012", []), False)

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_mo.validar_encabezado("EMO" + i + "122012", []), False)

	def test_validar_encabezado_en_blanco(self):
		self.assertEqual(archivos_mo.validar_encabezado("                    ", []), False)
	
	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_mo.validar_encabezado("EMO12345678978      ", []), False)
		self.assertEqual(archivos_mo.validar_encabezado("EMO12345678978201212", []), False)

	def test_validar_encabezado_rnc_o_cedula_en_blanco(self):
		self.assertEqual(archivos_mo.validar_encabezado("EMO           122012", []), False)

	def test_validar_detalle(self):

		global stack_msg
		self.assertEqual(archivos_mo.validar_detalle("D001002C00118179209              0000000000234.000000000000000.000000000000000.000000000000000.00123456789120000000000000.000000000000000.000000000000000.000000000000000.000001", stack_msg), True) # Formato correcto
		
	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_mo.validar_detalle("D001001 12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False) 
		self.assertEqual(archivos_mo.validar_detalle("D001001M12345678912              0000000004500.000000000004500.0000000000000O0.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False) 

	def test_validar_detalle_nro_documento(self):
		self.assertEqual(archivos_mo.validar_detalle("D001001C                         0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False) 

	def test_validar_detalle_codigo_ingreso(self):
		self.assertEqual(archivos_mo.validar_detalle("D001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.00abcd", []), False) # El tipo de ingreso debe estar en el formato correcto 	
		self.assertEqual(archivos_mo.validar_detalle("D001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.00   1", []), False)# formato invalido del tipo ingreso
			
	def test_validar_detalle_error_constante(self):
		self.assertEqual(archivos_mo.validar_detalle("A001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# la Constante debe ser D en el detalle
		self.assertEqual(archivos_mo.validar_detalle(" 001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# la Constante debe ser D en el detalle

	def test_validar_detalle_clave_nomina(self):
		#self.assertEqual(archivos_mo.validar_detalle("D  1001C12345678912              kerlin                                            de la cruz                              alvarez                                 M291119870000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# formato del id nomina es incorrecto
		self.assertEqual(archivos_mo.validar_detalle("D  1001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# formato del id nomina es incorrecto
		self.assertEqual(archivos_mo.validar_detalle("D001  1C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# formato del id nomina es incorrecto
		self.assertEqual(archivos_mo.validar_detalle("D00100sC12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# formato del id nomina es incorrecto
		self.assertEqual(archivos_mo.validar_detalle("D0n1001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# formato del id nomina es incorrecto
	
	def test_validar_detalle_const_tip_reg_obligatorio(self):
		self.assertEqual(archivos_mo.validar_detalle("                                 0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.000001", []), False)# la linea del encabezado esta vacia

	def test_validar_detalle_salarios_en_blanco(self):
		self.assertEqual(archivos_mo.validar_detalle("D001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.000000000000000.  0001", []), False)# formato invalido del salario infotep
		self.assertEqual(archivos_mo.validar_detalle("D001001C12345678912              0000000004500.000000000004500.000000000000000.000000000000000.00000000000000000000000000.000000000000000.000000000000000.00                0001", []), False)# Ninguno de los salarios puede venir en blanco

	def test_validar_sumario(self):

		global stack_msg
		self.assertEqual(archivos_mo.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_constante(self):
		self.assertEqual(archivos_mo.validar_sumario("A000000", []), False)
		self.assertEqual(archivos_mo.validar_sumario("1234567", []), False)
	
	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_mo.validar_sumario("", []), False)
		self.assertEqual(archivos_mo.validar_sumario("       ", []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_mo.validar_sumario("S00", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_mo.validar_sumario("S1234567", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_mo.validar_sumario("S 23456", []), False)
		self.assertEqual(archivos_mo.validar_sumario("S     6", []), False)

	def test_validar_sumario_con_letras_no_constante(self):
		self.assertEqual(archivos_mo.validar_sumario("S0000as", []), False)
		i = cons.char_especiales [:6]
		self.assertEqual(archivos_mo.validar_sumario("S" + i, []), False)
	
	'''def test_insertar_detalle_many(self):
		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()

		global stack_msg

		registros = ['D001001C00101638211              SERGIO                                            TERRERO CARVAJAL                                                                M160519610000000066780.000000000000000.000000000066780.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000066780.000001']
		id_envio = 911121
		self.assertRaises(TypeError, lambda: archivos_am.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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