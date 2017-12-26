# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import unittest2
import teamcity
import teamcity.unittestpy
import db

class pruebas_db(unittest2.TestCase):
    def test_connString(self):
        self.assertEqual(len(db.connString())> 0, True)

    def tearDown(self):
        pass
		
if __name__ == '__main__':

        pass