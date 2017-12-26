# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import archivos_ep
import unittest2
import teamcity
import teamcity.unittestpy
import db
import cx_Oracle

stack_msg = []
registros = []

class pruebas_archivos_ep(unittest2.TestCase):
    
    def test_validar_encabezado(self):

        global stack_msg
        self.assertEqual(archivos_ep.validar_encabezado("EREEP0650400                                                     ", stack_msg), True)

    def test_validar_encabezado_tipo_registro(self):
    	self.assertEqual(archivos_ep.validar_encabezado(" REEP0650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("SREEP0650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("DREEP0650400                                                     ", []), False)

    def test_validar_encabezado_clave_proceso(self):
    	self.assertEqual(archivos_ep.validar_encabezado("E  EP0650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("ENVEP0650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EAAEP0650400                                                     ", []), False)

    def test_validar_encabezado_clave_sub_proceso(self):
    	self.assertEqual(archivos_ep.validar_encabezado("ERE  0650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("ERENV0650400                                                     ", []), False)

    def test_validar_encabezado_tamano_registro(self):
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP   0400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP 650400                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEPABC0400                                                     ", []), False)

    def test_validar_encabezado_entidad_emisora(self):
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP065  00                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP065 100                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP065AB00                                                     ", []), False)
        self.assertEqual(archivos_ep.validar_encabezado("EREEP0651200                                                     ", []), False)

    def test_validar_encabezado_clave_entidad_emisora(self):
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP06504                                                       ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP06504AB                                                     ", []), False)
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP06504 1                                                     ", []), False)

    def test_validar_encabezado_espacios_en_blanco(self):
    	self.assertEqual(archivos_ep.validar_encabezado("EREEP0650412             123asdf                                 ", []), False)

    def test_validar_detalle(self):

        global stack_msg
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:120000000000.00999999999901", stack_msg), True)

    def test_validar_detalle_tipo_registro(self):
        self.assertEqual(archivos_ep.validar_detalle(" 000000010100000000000000001212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("S000000010100000000000000001212201212:120000000000.00999999999901", []), False)

    def test_validar_detalle_clave_transaccion(self):
        self.assertEqual(archivos_ep.validar_detalle("D      010100000000000000001212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D12as23010100000000000000001212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D  0000010100000000000000001212201212:120000000000.00999999999901", []), False)

    def test_validar_detalle_sucursal_banco(self):
        self.assertEqual(archivos_ep.validar_detalle("D000000    00000000000000001212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D0000000a0b00000000000000001212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000  1200000000000000001212201212:120000000000.00999999999901", []), False)

    def test_validar_detalle_referencia_nro(self):
        self.assertEqual(archivos_ep.validar_detalle("D0000000101                1212201212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000   fdf000001212201212:120000000000.00999999999901", []), False)

    def test_validar_detalle_fecha_pago(self):
        self.assertEqual(archivos_ep.validar_detalle("D00000001010000000000000000        12:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D0000000101000000000000000012abri1212:120000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001220101112:120000000000.00999999999901", []), False)

    def test_validar_detalle_hora_pago(self):
        self.assertEqual(archivos_ep.validar_detalle("D0000000101000000000000000012122012     0000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201226:200000000000.00999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D0000000101000000000000000012122012  :000000000000.00999999999901", []), False)

    def test_validar_detalle_importe_pagado(self):
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:20             999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000000999999999901", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:20abdv000000.00999999999901", []), False)

    def test_validar_detalle_numero_autorizacion(self):
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.00          01", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.00125asd888801", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.00   123456701", []), False)

    def test_validar_detalle_medio_pago(self):
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.009999999999  ", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.009999999999 1", []), False)
        self.assertEqual(archivos_ep.validar_detalle("D000000010100000000000000001212201212:200000000000.0099999999991a", []), False)


    def test_validar_sumario(self):

        global stack_msg 
        self.assertEqual(archivos_ep.validar_sumario("S000000000000000000000000000.00                                  ", stack_msg), True)

    def test_validar_sumario_tipo_registro(self):
    	self.assertEqual(archivos_ep.validar_sumario(" 000000000000000000000000000.00                                  ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("E000000000000000000000000000.00                                  ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("D000000000000000000000000000.00                                  ", []), False)

    def test_validar_sumario_numero_registros(self):
    	self.assertEqual(archivos_ep.validar_sumario("S     0000000000000000000000.00                                  ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("S00asc0000000000000000000000.00                                  ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("S00  00000000000000000000000.00                                  ", []), False)

    def test_validar_sumario_total_de_pago(self):
    	self.assertEqual(archivos_ep.validar_sumario("S00000                                                           ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("S00000000000asdfgrhhyn000000.00                                  ", []), False)
    	self.assertEqual(archivos_ep.validar_sumario("S000000000000000000000000000000                                  ", []), False)

   	def test_validar_sumario_espacios_en_blanco(self):
   		self.assertEqual(archivos_ep.validar_sumario("S000000000000000000000000000.00         asd123                   ", []), False)

    '''def test_insertar_detalle_many(self):
        oConn = cx_Oracle.connect(db.connString())
        oCurs = oConn.cursor()

        global stack_msg
        id_envio = '' 
        registros = ['D667509011120111214468042211307201211:190000005967.00000597251801']

        self.assertRaises(TypeError, lambda: archivos_ep.insertar_detalle_many(registros, id_envio, oCurs, stack_msg), [])

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