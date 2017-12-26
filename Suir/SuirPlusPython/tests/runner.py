# -*- coding: utf-8 -*-
import sys

sys.path.insert(0, '../archivos')
sys.path.insert(0, 'archivos')

import unittest2
import teamcity
import teamcity.unittestpy

tests = unittest2.defaultTestLoader.discover('.')
testRunner = teamcity.unittestpy.TeamcityTestRunner()
#testRunner = unittest2.runner.TextTestRunner()
testRunner.run(tests)