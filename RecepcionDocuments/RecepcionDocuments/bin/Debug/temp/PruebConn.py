# -*- coding: utf-8 -*-
import cx_Oracle
import base64
import os
import sys
import string
import pyodbc
import pymssql
import base64
import codecs

# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port
'''server = 'APSCLSQL02\APSDYN01' 
database = 'GPINTEGRATION' 
username = 'ERP' 
password = 'INP@$$w0rd13' 
cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=APSCLSQL02\APSDYN01;DATABASE=GPINTEGRATION;UID=ERP;PWD=INP@$$w0rd13')
cnxn.timeout = 60
cursor = cnxn.cursor()
try:
    cursor.execute("select * from dbo.Detalles;") 
    row = cursor.fetchall() 
    while row:
        print row[2] 
        row = cursor.fetchall()

except Exception as e:
    print(e)


def insert(sql):
    connString = 'VVNSUlBUU1ZSH3NVd0RTb1J6VHdwMXVqRDM3eUAxNzIuMjAuMi4zMToxNTIx\n'
    oConn = cx_Oracle.connect(connString().decode("base64"))
    global oCurs
    oCurs = oConn.cursor()
    oCurs.execute(sql)
    oConn.commit()
    oCurs.close()
    oConn.close()'''

#funciones para encriptar y desencriptar
def encriptar(campo):
    texto = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=APSCLSQL02\APSDYN01;DATABASE=GPINTEGRATION;UID=ERP;PWD=INP@$$w0rd13'
    textoencriptado = base64.encodestring(texto)
    return textoencriptado

#funcion para desencriptacion string
def desencriptar(campo):
    texto = campo
    textodesencriptado = base64.decodestring(texto)
    return textodesencriptado
