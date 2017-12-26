# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import unittest2
import teamcity
import teamcity.unittestpy
import main

class pruebas_main(unittest2.TestCase):
    def test_config_file(self):
        self.assertEqual(len(main.config_file())> 0, True)

    def test_ruta_general(self):
    	self.assertEqual(len(main.ruta_general()) != None, True)

    def tearDown(self):
        pass
		
if __name__ == '__main__':

        pass