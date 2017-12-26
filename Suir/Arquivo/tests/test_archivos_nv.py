# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_nv
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_nv(unittest2.TestCase):

	def test_validar_encabezado(self):
		global stack_msg  
		self.assertEqual(archivos_nv.validar_encabezado("ENV12345678912122012", stack_msg), True)
		self.assertEqual(archivos_nv.validar_encabezado("ENV  123456789112010", stack_msg), True)
	
	def test_validar_encabezado_longitud_menor(self):
		self.assertEqual(archivos_nv.validar_encabezado("ENV123452122012", []), False)

	def test_validar_encabezado_longitud_mayor(self):
	    self.assertEqual(archivos_nv.validar_encabezado("ENV1235646546452122012", []), False)	

	def test_validar_encabezado_tipo_proceso(self):
		self.assertEqual(archivos_nv.validar_encabezado("ANV12345212123122012", []), False)
		self.assertEqual(archivos_nv.validar_encabezado(" NV12345212123122012", []), False)

	def test_validar_encabezado_tipo_archivo(self):
		self.assertEqual(archivos_nv.validar_encabezado("EAM12345212123122012", []), False)
		self.assertEqual(archivos_nv.validar_encabezado("EAR12345212123122012", []), False)
		self.assertEqual(archivos_nv.validar_encabezado("E  12345212123122012", []), False)

	def test_validar_encabezado_periodo(self):
		self.assertEqual(archivos_nv.validar_encabezado("ENV12345212123      ", []), False)
		self.assertEqual(archivos_nv.validar_encabezado("EAM12345212123201212", []), False)

	def test_validar_encabezado_rnc_o_cedula_en_blanco(self):
		self.assertEqual(archivos_nv.validar_encabezado("ENV          122012", []), False)

	def test_validar_encabezado_con_letras(self):
		self.assertEqual(archivos_nv.validar_encabezado("ENV1234abc8912122012", []), False)

		i = cons.char_especiales [:11]
		self.assertEqual(archivos_nv.validar_encabezado("ENV" + i + "122012", []), False)

	def test_validar_encabezado_con_espacios_izquierda(self):
		self.assertEqual(archivos_nv.validar_encabezado(" ENV1123456712122012", []), False)

	def test_validar_encabezado_en_blanco(self):
		self.assertEqual(archivos_nv.validar_encabezado("                    ", []), False)

	'''def test_validar_detalle(self):

		global stack_msg  
		#self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", stack_msg), True) # formato correcto, pero con loa campos que no son obligatorios en blanco
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        P00118179209              kerlin santiago                                  de la cruz                              alvarez                                  M121220120000000000000.000000000000000.000000000000000.000000000000000.00123456789210000000000000.000000000000000.000000000000000.000000000000000.000001", stack_msg), True) # formato correcto con todos los campos completos'''

	def test_validar_detalle_salarios(self):
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.00                    ", []), False) # los salarios deben estar rellenos de 0 con 2 espacios decimales

	def test_validar_detalle_tipo_novedad(self):
		self.assertEqual(archivos_nv.validar_detalle("D001  12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)
		self.assertEqual(archivos_nv.validar_detalle("D001$a12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)

	def test_validar_detalle_constante(self):
		self.assertEqual(archivos_nv.validar_detalle("S001SA12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)
		self.assertEqual(archivos_nv.validar_detalle(" 001SA12122012        C00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)

	def test_validar_detalle_fechas_rellena_cero(self):
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        PRD-12345687                                                                                                                                                 000000000000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)

	def test_validar_detalle_tipo_documento(self):
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        M00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012         00118179209                                                                                                                                                         0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)

	def test_validar_detalle_nro_documento_en_blanco(self):
		self.assertEqual(archivos_nv.validar_detalle("D001IN12122012        C                                                                                                                                                                    0000000000000.000000000000000.000000000000000.000000000000000.00           0000000000000.000000000000000.000000000000000.000000000000000.00    ", []), False)
	def test_validar_sumario(self):

		global stack_msg  
		self.assertEqual(archivos_nv.validar_sumario("S000000", stack_msg), True)

	def test_validar_sumario_constante(self):
		self.assertEqual(archivos_nv.validar_sumario(" 000000", []), False)
		self.assertEqual(archivos_nv.validar_sumario("A000000", []), False)

	def test_validar_sumario_con_espacios(self):
		self.assertEqual(archivos_nv.validar_sumario("S  0000", []), False)
		self.assertEqual(archivos_nv.validar_sumario("S     0", []), False)

	def test_validar_sumario_con_letras(self):
		self.assertEqual(archivos_nv.validar_sumario("S000abc", []), False)
		self.assertEqual(archivos_nv.validar_sumario("Sabdc00", []), False)
		
		i = cons.char_especiales [:6]
		self.assertEqual(archivos_nv.validar_sumario("S" + i, []), False)

	def test_validar_sumario_longitud_menor(self):
		self.assertEqual(archivos_nv.validar_sumario("S00", []), False)

	def test_validar_sumario_longitud_mayor(self):
		self.assertEqual(archivos_nv.validar_sumario("S000000000", []), False)

	def test_validar_sumario_en_blanco(self):
		self.assertEqual(archivos_nv.validar_sumario("       ", []), False)
	

	'''def test_insertar_detalle_many(self):

		oConn = cx_Oracle.connect(db.connString())
		oCurs = oConn.cursor()

		global stack_msg
		registros = ['D001AD01082012        C12300014706              Pedro Antonio Ventura Mejía                                                                                                       M        0000000032629.940000000000000.000000000032629.940000000016912.32           0000000000000.000000000000000.000000000000000.000000000032629.940001']	
		id_envio = '' 
				
		self.assertRaises(TypeError, lambda: archivos_nv.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])
		
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
