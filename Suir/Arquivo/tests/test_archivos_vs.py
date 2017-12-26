# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_vs 
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import db
import cx_Oracle



stack_msg = []
registros = []

class pruebas_archivos_vs(unittest2.TestCase):
    
    def test_validar_encabezado(self):

        global stack_msg
        self.assertEqual(archivos_vs.validar_encabezado("EVS201001", stack_msg), True)

    def test_validar_encabezado_tipo_registro(self):
    	self.assertEqual(archivos_vs.validar_encabezado(" VS201010", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("SVS201010", []), False)

    def test_validar_encabezado_proceso(self):
    	self.assertEqual(archivos_vs.validar_encabezado("E  201010", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("ENV201010", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("EAM201010", []), False)

    def test_validar_encabezado_ano(self):
    	self.assertEqual(archivos_vs.validar_encabezado("EVS    10", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("EVS@#$%10", []), False)

    def test_validar_encabezado_mes(self):
    	self.assertEqual(archivos_vs.validar_encabezado("ENV2010  ", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("ENV2010@#", []), False)

    def test_validar_encabezado_en_blanco(self):
        self.assertEqual(archivos_vs.validar_encabezado("         ", []), False)

    def test_validar_detalle(self):

        global stack_msg 
        self.assertEqual(archivos_vs.validar_detalle("DC00118179209", stack_msg), True)

    def test_validar_detalle_tipo_registro(self):
    	self.assertEqual(archivos_vs.validar_encabezado(" C00102149002", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("EC00102149002", []), False)

    def test_validar_detalle_tipo_documento(self):
    	self.assertEqual(archivos_vs.validar_encabezado("D 00102149002", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("DP00102149002", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("DN00102149002", []), False)

    def test_validar_detalle_cedula(self):
    	self.assertEqual(archivos_vs.validar_encabezado("DC           ", []), False)
    	self.assertEqual(archivos_vs.validar_encabezado("DC  123456789", []), False)

        i = cons.char_especiales [:11]
    	self.assertEqual(archivos_vs.validar_encabezado("DC" + i, []), False)

    def test_validar_sumario(self):

        global stack_msg 
        self.assertEqual(archivos_vs.validar_sumario("S000000", stack_msg), True)

    def test_validar_sumario_constante(self):
        self.assertEqual(archivos_vs.validar_sumario("A000000", []), False)
        self.assertEqual(archivos_vs.validar_sumario("1234567", []), False)

    def test_validar_sumario_en_blanco(self):
        self.assertEqual(archivos_vs.validar_sumario("", []), False)
        self.assertEqual(archivos_vs.validar_sumario("       ", []), False)

    def test_validar_sumario_longitud_menor(self):        
        self.assertEqual(archivos_vs.validar_sumario("S00", []), False)

    def test_validar_sumario_longitud_mayor(self):         
        self.assertEqual(archivos_vs.validar_sumario("S1234567", []), False)

    def test_validar_sumario_con_espacios(self):
        self.assertEqual(archivos_vs.validar_sumario("S 23456", []), False)
        self.assertEqual(archivos_vs.validar_sumario("S     6", []), False)

    def test_validar_sumario_con_letras_no_constante(self):        
        self.assertEqual(archivos_vs.validar_sumario("S0000as", []), False)

        i = cons.char_especiales [:6]
        self.assertEqual(archivos_vs.validar_sumario("S" + i, []), False)

    '''def test_insertar_detalle_many(self):
        oConn = cx_Oracle.connect(db.connString())
        oCurs = oConn.cursor()

        global stack_msg
        id_envio = ''
        registros = ['D010010505720107501082012501207147314340150120714731434010000000839.000000000839.0000718674730005998015011']
    
        self.assertRaises(TypeError, lambda: insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])
        
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