# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import funciones
import unittest2
import teamcity
import teamcity.unittestpy
import cons
import re
import hashlib


class pruebas_funciones(unittest2.TestCase):

    def test_is_alfanumerico(self):
        self.assertEqual(funciones.is_alfanumerico("ABcd15gr"), True)
    
    def test_is_alfanumerico_acentos(self):
        self.assertEqual(funciones.is_alfanumerico(u"abcáéíóúñÑ"), True)   

    def test_is_alfanumerico_char_especiales(self):
        self.assertEqual(funciones.is_alfanumerico(cons.char_especiales),False)

        i = 0
        for c in cons.char_especiales_array:            
            self.assertEqual(funciones.is_alfanumerico(cons.char_especiales_array[i]),False)
            i = i + 1   

    def test_is_numerico(self):
        self.assertEqual(funciones.is_numerico("0"), True)
        self.assertEqual(funciones.is_numerico("123"), True)

    def test_is_numerico_punto_decimal(self):
        self.assertEqual(funciones.is_numerico("123.00"), False)
        self.assertEqual(funciones.is_numerico("123,000.00"), False)

    def test_is_numerico_coma(self):
        self.assertEqual(funciones.is_numerico("12,300"), False)

    def test_is_numerico_letras(self):
        self.assertEqual(funciones.is_numerico(" "), False)
        self.assertEqual(funciones.is_numerico("ABC"), False)
        
    def test_is_numerico_negativo(self):
        self.assertEqual(funciones.is_numerico("-123"), False)
        self.assertEqual(funciones.is_numerico("-123.00"), False)

    def test_is_decimal(self):
        self.assertEqual(funciones.is_decimal("1.99"), True)
        self.assertEqual(funciones.is_decimal("123.00"), True)
        
    def test_is_decimal_negativo(self):
        self.assertEqual(funciones.is_decimal("-12"), False)
        self.assertEqual(funciones.is_decimal("-12.01"), False)

    def test_is_decimal_letras(self):
        self.assertEqual(funciones.is_decimal("ABC"), False)
        self.assertEqual(funciones.is_decimal("x"), False)
        self.assertEqual(funciones.is_decimal(re.sub('[.]','', cons.char_especiales)), False)

    def test_is_decimal_coma(self):
        self.assertEqual(funciones.is_decimal(","), False)
        self.assertEqual(funciones.is_decimal("123,123"), False)

    def test_is_decimal_espacios(self):
        self.assertEqual(funciones.is_decimal("01 . 90"), False)
        self.assertEqual(funciones.is_decimal("   123.00"), False)

    def test_is_decimal_punto_decimal(self):
        self.assertEqual(funciones.is_decimal("00.000"), False)
        self.assertEqual(funciones.is_decimal("00.0"), False)

    def test_is_decimal_sin_punto_decimal(self):
        self.assertEqual(funciones.is_decimal("123"), False)
        self.assertEqual(funciones.is_decimal("1"), False)

    def test_is_fecha(self):
        self.assertEqual(funciones.is_fecha("01012012"), True)
        self.assertEqual(funciones.is_fecha("12122012"), True)

    def test_is_fecha_rellena_cero(self):
        self.assertEqual(funciones.is_fecha("00000000"), False)

    def test_is_fecha_con_guiones_slash(self):
        self.assertEqual(funciones.is_fecha("01-01-2012"), False)
        self.assertEqual(funciones.is_fecha("01/01/2012"), False)

    def test_is_fecha_con_espacios(self):
        self.assertEqual(funciones.is_fecha(" 1 12012"), False)
        
    def test_is_fecha_longitud_menor(self):
        self.assertEqual(funciones.is_fecha("112012"), False)
        self.assertEqual(funciones.is_fecha("1 1 1"), False)

    def test_is_fecha_longitud_mayor(self):
        self.assertEqual(funciones.is_fecha("121222012"), False)

    def test_is_fecha_letra(self):       
        self.assertEqual(funciones.is_fecha("121220gg"), False)
        self.assertEqual(funciones.is_fecha("@#$%^&*+"), False)

    def test_is_fecha_guion_slash(self):
        self.assertEqual(funciones.is_fecha("12/25-85"), False) 

    def test_is_fecha_alterna(self):
        self.assertEqual(funciones.is_fecha_alterna("19871210"), True)

    def test_is_fecha_alterna_rellena_cero(self):
        self.assertEqual(funciones.is_fecha_alterna("00000000"), False)

    def test_is_fecha_alterna_con_guiones_slash(self):
        self.assertEqual(funciones.is_fecha_alterna("01-01-2012"), False)
        self.assertEqual(funciones.is_fecha_alterna("01/01/2012"), False)

    def test_is_fecha_alterna_con_espacios(self):
        self.assertEqual(funciones.is_fecha_alterna(" 1 12012"), False)
        
    def test_is_fecha_alterna_longitud_menor(self):
        self.assertEqual(funciones.is_fecha_alterna("112012"), False)
        self.assertEqual(funciones.is_fecha_alterna("1 1 1"), False)

    def test_is_fecha_alterna_longitud_mayor(self):
        self.assertEqual(funciones.is_fecha_alterna("121222012"), False)

    def test_is_fecha_alterna_letra(self):       
        self.assertEqual(funciones.is_fecha_alterna("121220gg"), False)
        self.assertEqual(funciones.is_fecha_alterna("@#$%^&*+"), False)

    def test_is_fecha_alterna_guion_slash(self):
        self.assertEqual(funciones.is_fecha_alterna("12/25-85"), False) 
        
    def test_is_fecha_vacia(self):   
        self.assertEqual(funciones.is_fecha_vacia("12122012"), True)
        self.assertEqual(funciones.is_fecha_vacia("        "), True)

    def test_is_fecha_vacia_en_blanco(self):      
        self.assertEqual(funciones.is_fecha_vacia("        "), True)
        self.assertEqual(funciones.is_fecha_vacia(""), False)

    def test_is_fecha_vacia_rellena_cero(self):        
        self.assertEqual(funciones.is_fecha_vacia("00000000"), False)

    def test_is_fecha_vacia_con_guion_slash(self):     
        self.assertEqual(funciones.is_fecha_vacia("01-01-2012"), False)
        self.assertEqual(funciones.is_fecha_vacia("01/01/2012"), False)

    def test_is_fecha_vacia_longitud_menor(self):
        self.assertEqual(funciones.is_fecha_vacia("112012"), False)

    def test_is_fecha_vacia_longitud_mayor(self):
        self.assertEqual(funciones.is_fecha_vacia("111512012"), False)

    def test_is_fecha_vacia_con_espacios(self):
        self.assertEqual(funciones.is_fecha_vacia(" 1 12012"), False)

    def test_is_fecha_vacia_letras(self):
        self.assertEqual(funciones.is_fecha_vacia("acbvjhgd"), False)
        self.assertEqual(funciones.is_fecha_vacia("!@#$%^&*"), False)

    def test_is_fecha_alterna_vacia(self):
        self.assertEqual(funciones.is_fecha_alterna_vacia("20121010"), True)

    def test_is_fecha_alterna_vacia_en_blanco(self):      
        self.assertEqual(funciones.is_fecha_alterna_vacia("        "), True)
        self.assertEqual(funciones.is_fecha_alterna_vacia(""), False)

    def test_is_fecha_alterna_vacia_rellena_cero(self):        
        self.assertEqual(funciones.is_fecha_alterna_vacia("00000000"), False)

    def test_is_fecha_alterna_vacia_con_guion_slash(self):     
        self.assertEqual(funciones.is_fecha_alterna_vacia("01-01-2012"), False)
        self.assertEqual(funciones.is_fecha_alterna_vacia("01/01/2012"), False)

    def test_is_fecha_alterna_vacia_longitud_menor(self):
        self.assertEqual(funciones.is_fecha_alterna_vacia("112012"), False)

    def test_is_fecha_alterna_vacia_longitud_mayor(self):
        self.assertEqual(funciones.is_fecha_alterna_vacia("111512012"), False)

    def test_is_fecha_alterna_vacia_con_espacios(self):
        self.assertEqual(funciones.is_fecha_alterna_vacia(" 1 12012"), False)

    def test_is_fecha_alterna_vacia_letras(self):
        self.assertEqual(funciones.is_fecha_alterna_vacia("acbvjhgd"), False)
        self.assertEqual(funciones.is_fecha_alterna_vacia("!@#$%^&*"), False)

    def test_is_fecha_vacaciones(self):  
        self.assertEqual(funciones.is_fecha_vacaciones("A", "01012012", "201201"), True)
        self.assertEqual(funciones.is_fecha_vacaciones("F", "01012012", "201201"), True)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "01012012", "01012012"), True)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "        ", "        "), True)
        self.assertEqual(funciones.is_fecha_vacaciones("R", "01012012", "12012012"), True)

        self.assertEqual(funciones.is_fecha_vacaciones("A", "01012013", "asdcvfgv"), False)
        self.assertEqual(funciones.is_fecha_vacaciones("F", "01012014", "201301"), False)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "00000000", "201201"), False)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "012013", "01012013"), False)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "        ", "201201"), False)
        self.assertEqual(funciones.is_fecha_vacaciones("I", "01012013", "        "), False)
        self.assertEqual(funciones.is_fecha_vacaciones("R", "15012013", "01012013"), False)
             
       
    def test_is_periodo(self):
        self.assertEqual(funciones.is_periodo("123456"), True)
        self.assertEqual(funciones.is_periodo("012012"), True) 

        self.assertEqual(funciones.is_periodo("1201201"), False)           

    def test_is_periodo_letras(self):
        self.assertEqual(funciones.is_periodo("12a456"), False)

        i = 0
        for c in cons.char_especiales_array:
            self.assertEqual(funciones.is_periodo("04201" + cons.char_especiales_array[i]), False)
            i = i + 1

    def test_is_periodo_longitud_mayor(self):
        self.assertEqual(funciones.is_periodo("1234567"), False)

    def test_is_periodo_longitud_menor(self):
        self.assertEqual(funciones.is_periodo("12345"), False)
        self.assertEqual(funciones.is_periodo(""), False)

    def test_is_periodo_en_blanco(self):
        self.assertEqual(funciones.is_periodo("      "), False)

    def test_is_sexo(self):        
        self.assertEqual(funciones.is_sexo("F"), True)
        self.assertEqual(funciones.is_sexo("M"), True)        

    def test_is_sexo_en_blanco(self):
        self.assertEqual(funciones.is_sexo_vacio(" "), True)

    def test_is_sexo_letras(self):
        self.assertEqual(funciones.is_sexo("a"), False)

    def tets_is_sexo_longitud_mayor(self):
        self.assertEqual(funciones.is_sexo("Ma"), False)
        self.assertEqual(funciones.is_sexo("Fe"), False)

    def tets_is_sexo_longitud_menor(self):
        self.assertEqual(funciones.is_sexo(""), False)

    def test_is_salario(self):
        self.assertEqual(funciones.is_salario("1234567891234.00"), True)
        self.assertEqual(funciones.is_salario("0000000052126.96"), True)

    def test_is_salario_negativo(self):
        self.assertEqual(funciones.is_salario("-000000052126.96"), False)
        
    def test_is_salario_letras(self):
        self.assertEqual(funciones.is_salario("12535abhj1231"), False)
        self.assertEqual(funciones.is_salario("!@#$%^0000000.00"), False)

        i = 0
        for c in cons.char_especiales_array:
            self.assertEqual(funciones.is_salario("0000000000000" + re.sub('[.]', '', cons.char_especiales_array[i] + "00")), False)
            i = i + 1

    def test_is_salario_longitud_mayor(self):
        self.assertEqual(funciones.is_salario("12345678912345000"), False)
        self.assertEqual(funciones.is_salario("12345678912345.00"), False)

    def test_is_salario_longitud_menor(self):
        self.assertEqual(funciones.is_salario("123456789234.00"), False)
        self.assertEqual(funciones.is_salario(""), False)

    def test_is_salario_en_blanco(self):        
        self.assertEqual(funciones.is_salario("                "), False)
        self.assertEqual(funciones.is_salario("             .00"), False)

    def test_is_rnc_o_cedula(self):        
        self.assertEqual(funciones.is_rnc_o_cedula("00123456789"), True)
        self.assertEqual(funciones.is_rnc_o_cedula("12345678912"), True)
        self.assertEqual(funciones.is_rnc_o_cedula("  123456789"), True)

    def test_is_rnc_o_cedula_con_espacios(self):        
        self.assertEqual(funciones.is_rnc_o_cedula("12345 456"), False)

    def test_is_rnc_o_cedula_en_blanco(self):
        self.assertEqual(funciones.is_rnc_o_cedula("           "), False)

    def test_is_rnc_o_cedula_longitud_menor(self):
        self.assertEqual(funciones.is_rnc_o_cedula("12345678"), False)
        self.assertEqual(funciones.is_rnc_o_cedula(""), False)        

    def test_is_rnc_o_cedula_longitud_mayor(self):
        self.assertEqual(funciones.is_rnc_o_cedula("123456789123"), False)

    def test_is_rnc_o_cedula_letras(self):
        self.assertEqual(funciones.is_rnc_o_cedula("123456asd54"), False)
        self.assertEqual(funciones.is_rnc_o_cedula("123@#$%^&00"), False)
        
    def test_is_agente_retencion(self):         
        self.assertEqual(funciones.is_agente_retencion("12345678912"), True)
        self.assertEqual(funciones.is_agente_retencion("  123456789"), True)

    def test_is_agente_retencion_en_blanco(self):
        self.assertEqual(funciones.is_agente_retencion("           "), True)

    def test_is_agente_retencion_con_espacios(self):        
        self.assertEqual(funciones.is_agente_retencion("12345 456"), False)    

    def test_is_agente_retencion_longitud_menor(self):
        self.assertEqual(funciones.is_agente_retencion("12345678"), False)
        self.assertEqual(funciones.is_agente_retencion(""), True)        

    def test_is_agente_retencion_longitud_mayor(self):
        self.assertEqual(funciones.is_agente_retencion("123456789123"), False)

    def test_is_agente_retencion_letras(self):        
        self.assertEqual(funciones.is_agente_retencion("123456asd54"), False)
        self.assertEqual(funciones.is_agente_retencion("123!@#$%^&*"), False)    

    def test_is_tipo_ingreso(self):
        self.assertEqual(funciones.is_tipo_ingreso("0001"), True)
        
    def test_is_tipo_ingreso_en_blanco(self):
        self.assertEqual(funciones.is_tipo_ingreso("    "), False)

    def test_is_tipo_ingreso_con_espacios(self):
        self.assertEqual(funciones.is_tipo_ingreso("   1"), False)
        self.assertEqual(funciones.is_tipo_ingreso("12  "), False)

    def test_is_tipo_ingreso_letras(self):
        self.assertEqual(funciones.is_tipo_ingreso("123a"), False)

        i = 0
        for c in cons.char_especiales_array:
            self.assertEqual(funciones.is_tipo_ingreso("000" + cons.char_especiales_array[i]), False)
            i = i + 1

    def test_is_tipo_ingreso_longitud_menor(self):
        self.assertEqual(funciones.is_tipo_ingreso("001"), False)
        self.assertEqual(funciones.is_tipo_ingreso(""), False)

    def test_is_tipo_ingreso_longitud_mayor(self):
        self.assertEqual(funciones.is_tipo_ingreso("00001"), False)

    def test_is_tipo_novedad(self):
        self.assertEqual(funciones.is_tipo_novedad("IN", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("SA", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("VC", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("LV", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("LM", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("LD", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("AD", "NV"), True)
        self.assertEqual(funciones.is_tipo_novedad("A", "PN"), True)
        self.assertEqual(funciones.is_tipo_novedad("B", "PN"), True)
        self.assertEqual(funciones.is_tipo_novedad("NI ", "T3"), True)
        self.assertEqual(funciones.is_tipo_novedad("NI ", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad("NS ", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad("NC ", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad(" NI", "T3"), True)
        self.assertEqual(funciones.is_tipo_novedad(" NI", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad(" NS", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad(" NC", "T4"), True)
        self.assertEqual(funciones.is_tipo_novedad("NI ", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("NI ", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("NS ", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("NC ", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("IN", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("SA", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("VC", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("LV", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("LM", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("LD", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("NS", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("NC", "T3"), False)
        self.assertEqual(funciones.is_tipo_novedad("A", "T4"), False)        


    def test_is_tipo_novedad_longitud_menor(self):
        self.assertEqual(funciones.is_tipo_novedad("", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("a", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("1", "NV"), False)

    def test_is_tipo_novedad_longitud_mayor(self):
        self.assertEqual(funciones.is_tipo_novedad("anknf", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("12315egte", "NV"), False)

    def test_is_tipo_novedad_con_espacios(self):
        self.assertEqual(funciones.is_tipo_novedad("  ", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad(" 1", "NV"), False)
        self.assertEqual(funciones.is_tipo_novedad("a ", "NV"), False)

    def test_is_tipo_novedad_caracteres_especiales(self):
        i = 0
        for c in cons.char_especiales_array:
            self.assertEqual(funciones.is_tipo_novedad("0" + cons.char_especiales_array[i], "NV"), False)
            i = i + 1
    
    def test_is_nacionalidad(self):
        self.assertEqual(funciones.is_nacionalidad_vacia("   "), True)        
        self.assertEqual(funciones.is_nacionalidad("001"), True)

        self.assertEqual(funciones.is_nacionalidad(""), False)
        self.assertEqual(funciones.is_nacionalidad("P01"), False)
        self.assertEqual(funciones.is_nacionalidad("   "), False)
        self.assertEqual(funciones.is_nacionalidad("mnv"), False)
        self.assertEqual(funciones.is_nacionalidad("0-0"), False)
        self.assertEqual(funciones.is_nacionalidad("0000"), False)                
        self.assertEqual(funciones.is_nacionalidad("00011"), False)
        self.assertEqual(funciones.is_nacionalidad("01"), False)
        self.assertEqual(funciones.is_nacionalidad(""), False)  
        self.assertEqual(funciones.is_nacionalidad("  002  "), False)
        self.assertEqual(funciones.is_nacionalidad("  002"), False)
        self.assertEqual(funciones.is_nacionalidad("002  "), False)   

    def test_is_nacionalidad_vacia(self):
        self.assertEqual(funciones.is_nacionalidad_vacia(""), True)        

        self.assertEqual(funciones.is_nacionalidad_vacia("P01"), False)
        self.assertEqual(funciones.is_nacionalidad_vacia("  domi  "), False)       


    def test_is_nacionalidad_con_letras(self):
        i = 0
        for c in cons.char_especiales_array:
            self.assertEqual(funciones.is_nacionalidad("00" + cons.char_especiales_array[i]), False)
            i = i + 1


    def test_is_hora(self):
        self.assertEqual(funciones.is_hora("10:10"), True)

    def test_is_hora_excedente(self):
        self.assertEqual(funciones.is_hora("26:10"), False)

    def test_is_hora_longitud_mayor(self):
        self.assertEqual(funciones.is_hora("10:1000"), False)

    def test_is_hora_espacios_en_blanco(self):
        self.assertEqual(funciones.is_hora("  :10"), False)
        self.assertEqual(funciones.is_hora("10:  "), False)

    def test_is_hora_letras_punto(self):
        self.assertEqual(funciones.is_hora("10:PM"), False)
        self.assertEqual(funciones.is_hora("10:AM"), False)
        self.assertEqual(funciones.is_hora("10;10"), False)

    def test_is_telefono(self):
        self.assertEqual(funciones.is_telefono("809fhk1213"), False)
        self.assertEqual(funciones.is_telefono("809331475l"), False)
        self.assertEqual(funciones.is_telefono("cvbnfgdhsl"), False)
        self.assertEqual(funciones.is_telefono("8095462130"), True)
        self.assertEqual(funciones.is_telefono("1231423745"), True)
        self.assertEqual(funciones.is_telefono("1111111111"), True)
        self.assertEqual(funciones.is_telefono("10;1012130"), False)
        self.assertEqual(funciones.is_telefono("10101010"), False)
        self.assertEqual(funciones.is_telefono("          "), True) 
        self.assertEqual(funciones.is_telefono("809331467 "), False)

    def test_is_ocupacion(self):
        self.assertEqual(funciones.is_ocupacion("mecanico                                                                                                                                              "), True)
        self.assertEqual(funciones.is_ocupacion("                                                                                                                                                      "), False)
        self.assertEqual(funciones.is_ocupacion(""), False)

    def test_is_crear_hash_md5(self):
        md5 = hashlib.md5()

        self.assertEqual(bool(funciones.crear_hash_md5(md5, '55')), True)
        
    def test_is_crear_hash_md5_longitud(self):
        md5 = hashlib.md5()

        self.assertEqual(len(funciones.crear_hash_md5(md5, '12')), 32)
        


if __name__ == '__main__':

	#unittest2.main()

    #if teamcity.underTeamcity():
    #    runner = teamcity.unittestpy.TeamcityTestRunner()
    #    unittest2.main(testRunner=runner)
    #else:
    #    suite = unittest2.TestLoader().loadTestsFromTestCase(Funciones)
    #    unittest2.TextTestRunner(verbosity=2).run(suite)
    pass