# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import db
import archivos_ac
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_ac(unittest2.TestCase):

    def test_validar_encabezado(self):

        global stack_msg
        self.assertEqual(archivos_ac.validar_encabezado("EREAC1050400                                                                                             ", stack_msg), True)

    def test_validar_encabezado_tipo_registro(self):
    	self.assertEqual(archivos_ac.validar_encabezado(" REAC1050400                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("SREAC1050400                                                                                             ", []), False)

    def test_validar_encabezado_clave_proceso(self):
    	self.assertEqual(archivos_ac.validar_encabezado("E  AC1050400                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("ENVAC1050400                                                                                             ", []), False)

    def test_validar_encabezado_clave_sub_proceso(self):
    	self.assertEqual(archivos_ac.validar_encabezado("ERE  1050400                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("ERERE1050400                                                                                             ", []), False)

    def test_validar_encabezado_tamano_registro(self):
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC   0400                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC1040400                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("EREACABC0400                                                                                             ", []), False)

    def test_validar_encabezado_tipo_entidad(self):
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC105  00                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC105AB00                                                                                             ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC105 100                                                                                             ", []), False)
        self.assertEqual(archivos_ac.validar_encabezado("EREAC1051200                                                                                             ", []), False)

    def test_validar_encabezado_clave_entidad_emisora(self):
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC10504                                                                                               ", []), False)
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC105041A                                                                                             ", []), False)

    def test_validar_encabezado_espacios_en_blanco(self):
    	self.assertEqual(archivos_ac.validar_encabezado("EREAC1050400                                 1234                                                        ", []), False)    

    def test_validar_detalle(self):

        global stack_msg
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", stack_msg), True) #verificar, la longitud de estas lineas es 105
        self.assertEqual(archivos_ac.validar_detalle("D0112345678912345121220121234567891234567                0000000000.000000000000.009999999999888888888801", stack_msg), False)#REVISAR

    def test_validar_detalle_tipo_registro(self):
        self.assertEqual(archivos_ac.validar_detalle(" 011234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("S011234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("E011234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)

    def test_validar_detalle_tipo_movimiento(self):
        self.assertEqual(archivos_ac.validar_detalle("D  1234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("Das1234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D231234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)

    def test_validar_detalle_lote_corregir(self):
        self.assertEqual(archivos_ac.validar_detalle("D01         1234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D0112345asd91234512122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)

    def test_validar_detalle_id_registro(self):
        self.assertEqual(archivos_ac.validar_detalle("D01123456789     12122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D0112345678912as812122012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)

    def test_validar_detalle_fecha_envio(self):
        self.assertEqual(archivos_ac.validar_detalle("D0112345678912345        123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512152012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512--2012123456789123456712345678912345670000000000.000000000000.009999999999888888888801", []), False)

    def test_validar_detalle_referencia_original(self):
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012                12345678912345670000000000.000000000000.009999999999888888888801", []), True)
        
    def test_validar_detalle_importe_original(self):
        self.assertEqual(archivos_ac.validar_detalle("D01123456789123451212201212345678912345671234567891234567             0000000000.009999999999888888888801", []), True)
        self.assertEqual(archivos_ac.validar_detalle("D0112345678912345121220121234567891234567123456789123456700000000000000000000000.009999999999888888888801", []), True)
        self.assertEqual(archivos_ac.validar_detalle("D01123456789123451212201212345678912345671234567891234567123asd5158.000000000000.009999999999888888888801", []), True)

    def test_validar_detalle_importe_nuevo(self):
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.00             9999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.0000000000000009999999999888888888801", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.001234asde12.009999999999888888888801", []), False)

    def test_validar_detalle_numero_autorizacion_original(self):
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.00          888888888801", []), True )
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.0099999asdf0888888888801", []), True)

    def test_validar_detalle_numero_autorizacion_nueva(self):
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.009999999999          01", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.00999999999988888asdf901", []), False)

    def test_validar_detalle_motivo_error(self):
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.0099999999998888888888  ", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.0099999999998888888888ab", []), False)
        self.assertEqual(archivos_ac.validar_detalle("D011234567891234512122012123456789123456712345678912345670000000000.000000000000.0099999999998888888888 1", []), False)

    def test_validar_sumario(self):

        global stack_msg 
        self.assertEqual(archivos_ac.validar_sumario("S000000000000000000000000000.00                                                                          ", stack_msg), True)

    def test_validar_sumario_tipo_registro(self):
        self.assertEqual(archivos_ac.validar_sumario(" 000000000000000000000000000.00                                                                          ", []), False)
        self.assertEqual(archivos_ac.validar_sumario("D000000000000000000000000000.00                                                                          ", []), False)
        self.assertEqual(archivos_ac.validar_sumario("E000000000000000000000000000.00                                                                          ", []), False)

    def test_validar_sumario_numero_registros(self):
        self.assertEqual(archivos_ac.validar_sumario("S     0000000000000000000000.00                                                                          ", []), False)
        self.assertEqual(archivos_ac.validar_sumario("S000ad0000000000000000000000.00                                                                          ", []), False)

    def test_validar_sumario_importe_total(self):
        self.assertEqual(archivos_ac.validar_sumario("S00000                                                                                                   ", []), False)
        self.assertEqual(archivos_ac.validar_sumario("S     0000000000000000000000000                                                                          ", []), False)
        self.assertEqual(archivos_ac.validar_sumario("S     00000000asda0000000000.00                                                                          ", []), False)

    def test_validar_sumario_espacios_en_blanco(self):
        self.assertEqual(archivos_ac.validar_sumario("S000000000000000000000000000.00              asdfgh     1235                                             ", []), False)

    def test_validar_sumario_longitud_mayor(self):
        self.assertEqual(archivos_ac.validar_sumario("S     0000000000000000000000.00                                                                                   ", []), False)
        # hola
	

    '''def test_insertar_detalle_many(self):

        oConn = cx_Oracle.connect(db.connString())
        oCurs = oConn.cursor()

        global stack_msg
        #prueba
         

        registros = ['D010010505720107501082012501207147314340150120714731434010000000839.000000000839.0000718674730005998015011']
        id_envio = '' 

        self.assertRaises(TypeError, lambda: archivos_ac.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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
