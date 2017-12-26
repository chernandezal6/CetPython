# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_pt
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_pt(unittest2.TestCase):
    
    def test_validar_encabezado(self):

        global stack_msg
        self.assertEqual(archivos_pt.validar_encabezado("EPT98", stack_msg), True)

    def test_validar_encabezado_tipo_registro(self):
    	self.assertEqual(archivos_pt.validar_encabezado(" PT98", []), False)
    	self.assertEqual(archivos_pt.validar_encabezado("SPT98", []), False)

   	def test_validar_encabezado_proceso(self):
   		self.assertEqual(archivos_pt.validar_encabezado("E  98", []), False)
   		self.assertEqual(archivos_pt.validar_encabezado("EPN98", []), False)
   		self.assertEqual(archivos_pt.validar_encabezado("EAM98", []), False)

   	def test_validar_encabezado_id_ars(self):
   		self.assertEqual(archivos_pt.validar_encabezado("EPT  ", []), False)
   		self.assertEqual(archivos_pt.validar_encabezado("EPTan", []), False)
   		self.assertEqual(archivos_pt.validar_encabezado("EPT01", []), False)

   	def test_validar_encabezado_en_blanco(self):
   		self.assertEqual(archivos_pt.validar_encabezado("     ", []), False)

    def test_validar_detalle(self):
        global stack_msg 
        self.assertEqual(archivos_pt.validar_detalle("D1234567891052025", stack_msg), True)
        #self.assertEqual(archivos_pt.validar_detalle("D1234567891      ", stack_msg), True)

    def test_validar_detalle_tipo_registro(self):
    	self.assertEqual(archivos_pt.validar_detalle(" 1234567891052025", []), False)
    	self.assertEqual(archivos_pt.validar_detalle("S1234567891052025", []), False)

    def test_validar_detalle_pensionado(self):
    	self.assertEqual(archivos_pt.validar_detalle("D          052025", []), False)
    	self.assertEqual(archivos_pt.validar_detalle("D  12345678052025", []), False)

        i = cons.char_especiales [:10]
    	self.assertEqual(archivos_pt.validar_detalle("D" + i + "052025", []), False)

    def test_validar_detalle_codigo_ars(self):
    	self.assertEqual(archivos_pt.validar_detalle("D1234567891   121", []), False)
    	self.assertEqual(archivos_pt.validar_detalle("D1234567891102   ", []), False)
        self.assertEqual(archivos_pt.validar_detalle("D1234567891aaa121", []), False)
        self.assertEqual(archivos_pt.validar_detalle("D1234567891102aaa", []), False)

    def test_validar_sumario(self):

        global stack_msg
        self.assertEqual(archivos_pt.validar_sumario("S000000", stack_msg), True)

    def test_validar_sumario_constante(self):
        self.assertEqual(archivos_pt.validar_sumario("A000000", []), False)
        self.assertEqual(archivos_pt.validar_sumario("1234567", []), False)

    def test_validar_sumario_en_blanco(self):
        self.assertEqual(archivos_pt.validar_sumario("", []), False)
        self.assertEqual(archivos_pt.validar_sumario("       ", []), False)

    def test_validar_sumario_longitud_menor(self):        
        self.assertEqual(archivos_pt.validar_sumario("S00", []), False)

    def test_validar_sumario_longitud_mayor(self):         
        self.assertEqual(archivos_pt.validar_sumario("S1234567", []), False)

    def test_validar_sumario_con_espacios(self):
        self.assertEqual(archivos_pt.validar_sumario("S 23456", []), False)
        self.assertEqual(archivos_pt.validar_sumario("S     6", []), False)

    def test_validar_sumario_con_letras_no_constante(self):        
        self.assertEqual(archivos_pt.validar_sumario("S0000as", []), False)
        i = cons.char_especiales [:6]
        self.assertEqual(archivos_pt.validar_sumario("S" + i, []), False)

    '''def test_insertar_detalle_many(self):
        oConn = cx_Oracle.connect(db.connString())
        oCurs = oConn.cursor()

        global stack_msg
        id_envio = '' 
        registros = ['D0000042240052002']

        self.assertRaises(TypeError, lambda: archivos_pt.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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