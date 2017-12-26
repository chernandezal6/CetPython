Imports System
Imports System.Linq
Imports System.IO
Imports System.Configuration
Imports System.Text
Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Types
Imports System.Net
Imports System.Net.Mail
Imports System.Net.Mime

'Imports System.Web.Mail

Imports System.ComponentModel
'Imports FolderZipper
''' <summary>
''' Objecto para el manejo de archivo xml del BCRD
''' </summary>
''' <remarks></remarks>
Public Class BLArchivoXML
#Region "Variables Privadas"
    Private archivo As String
    Private archivos() As String
    Private detalle As New DetalleArchivo
    Private encabezado As New EncabezadoArchivo
    Private DetalleCon As New Detalle
    Private Sumario As New Sumario
    Private Enc As New Encabezado
    Private total_registros As Int32
    Private monto_total As Decimal
    Private fileinfo As FileInfo
    Private cadena As String
    Private fechahora As String
    Private digitocontrol As Int32 = 0
    Private v_sec_log As Int32
    Private resultado As String
    Private counter As Int32 = 0
    Private ERROR_FILE_NOT_FOUND As Integer = 2
    Private ERROR_ACCESS_DENIED As Integer = 5
    Private _result As String
    Private xmldoc As XElement
    Private LineaEncabezado As String
    Private Lineasumario As String
    Private rutaachivoprocesado As String
    Private rutaarchivorecibido As String
    Private rutaarchioenc As String
    Private nombrearchivo As String
    Private ArchivosRecibidos As String = ConfigurationManager.AppSettings("ArchivosrRecibidos")
    Private ArchivosProcesados As String = ConfigurationManager.AppSettings("ArchivosrProcesados")
    Private ArchivosConError As String = ConfigurationManager.AppSettings("ArchivosrConError")
    Private ArchivoDes As String = ConfigurationManager.AppSettings("ArchivosDes")
    Private ArchivoRecibidosEnc As String = ConfigurationManager.AppSettings("ArchivosRecibosEnc")
    Private javadir As String = ConfigurationManager.AppSettings("JavaDir")
    Private XMLZip As String = ConfigurationManager.AppSettings("XMLZip")
#End Region
#Region "Metodos publicos de la clases"

    Public Sub EnviarCorreo()

        Dim mydir As New DirectoryInfo(Me.ArchivosProcesados)

        'Obtengo una lista con todos los archivos que han sido procesados
        Dim myfiles() As FileInfo = mydir.GetFiles()


        'de la lista selecciono solo los archivos del dia
        'Dim query = From fi In myfiles _
        'Order By fi.LastWriteTime Descending _
        'Where fi.LastWriteTime.Date = DateTime.Now.Date.AddDays(-1) And fi.Extension = ".TXT" _
        'Select fi

        Dim query2 = From fi In myfiles _
                   Order By fi.LastWriteTime Descending _
                   Where fi.LastWriteTime.Date = DateTime.Now.Date
                   Select fi

        Dim count = query2.Count




        If query2.Count > 0 Then

            For Each sfile As FileInfo In query2

                If sfile.Extension.Equals(".xml") Then

                    rutaachivoprocesado = sfile.FullName

                    Dim dataXML As New DataSet
                    dataXML.ReadXml(sfile.FullName)

                    nombrearchivo = sfile.Name

                    xmldoc = XElement.Load(sfile.FullName)

                        'Leer el tab <Encabezado> del archivo XML para cargar las propiedades del objecto Encabezado.
                    Dim queryenc = From encabezado In xmldoc.Elements("ENCABEZADO") _
                                   Select encabezado

                    fechahora = queryenc.Elements("FECHAGENERACION").Value & " " & queryenc.Elements("HORAGENERACION").Value
                    encabezado.NombreArchivo = nombrearchivo
                    encabezado.Tipo = queryenc.Elements("TIPO").Value
                    encabezado.FechaGeneracion = queryenc.Elements("FECHAGENERACION").Value
                    encabezado.HoraGeneracion = fechahora
                    encabezado.NombreLote = Convert.ToInt32(queryenc.Elements("NOMBRELOTE").Value)
                    encabezado.ConceptoPago = queryenc.Elements("CONCEPTOPAGO").Value
                    encabezado.CodBicEntidadDB = queryenc.Elements("CODIGOBICENTIDADDB").Value
                    encabezado.CodBicEntidadCR = queryenc.Elements("CODIGOBICENTIDADCR").Value
                    encabezado.TRNopcrlbtr = queryenc.Elements("TRNOPCRLBTR").Value
                    encabezado.FechaValorCRLBTR = queryenc.Elements("FECHAVALORCRLBTR").Value
                    encabezado.TotalRegistroscontrol = Convert.ToInt32(queryenc.Elements("TOTALREGISTROSCONTROL").Value)
                    encabezado.TotalMontoControl = Convert.ToDecimal(queryenc.Elements("TOTALMONTOSCONTROL").Value)
                    encabezado.Moneda = queryenc.Elements("MONEDA").Value
                    encabezado.InformacionAdicional = queryenc.Elements("INFORMADICIONALENC01").Value
                    encabezado.EstadoArchivoPortal = queryenc.Elements("ESTADOARCHIVOENPORTAL").Value
                    encabezado.CantDescargaArchivo = queryenc.Elements("CANTDESCARGASARCHIVO").Value
                    encabezado.UsuarioDescargoArchivo = queryenc.Elements("USUARIODESCARGOARCHIVO").Value
                    encabezado.ArchivoXML = dataXML.GetXml

                    Dim entidadnombre As String = String.Empty

                    getEntidadNombrePorBic(encabezado.CodBicEntidadCR, entidadnombre, resultado)


                    EnviarConfirmacion(Body(), "Archivo de Liquidación de fondos" + " " + "del" + " " + entidadnombre, TipoArchivo.Procesados, rutaachivoprocesado, "L")


                ElseIf sfile.Extension.Equals(".txt") Or sfile.Extension.Equals(".TXT") Then

                    rutaachivoprocesado = sfile.FullName

                        'Obtener los valores del encabezado y cargar las variables correspondientes.
                    getEncabezadoValues(sfile.Name, Enc.NombreArchivo, Enc.Proceso, Enc.SubProceso, Enc.EntidadReceptora, Enc.FechaTransmision, Enc.NroLote, resultado)

                        'Extraer solo la linea del sumario
                    Dim EnumSumario As IEnumerable(Of String) = File.ReadAllLines(sfile.FullName).Where(Function(p As String) _
                                                                                   p.StartsWith("S"))
                        ' Cargar las propiedades de la estructura del sumario.
                    getSumarioValues(EnumSumario.Single, Sumario.Numero_Registros, Sumario.Total_Liquidar_Ajuste, Sumario.Monto_Aclarado, Sumario.Total_Ajuste, Sumario.Total_Liquidar, resultado)


                        'Extraer las lineas del Detalle
                    Dim EnumDetalle As IEnumerable(Of String) = File.ReadAllLines(sfile.FullName).Where(Function(p As String) _
                                                                                                     p.StartsWith("D"))

                    For Each detalle As String In EnumDetalle

                            'Llamar metodo para agregar el Detalle
                        getDetalleValues(detalle, DetalleCon.FechaSolicutud, DetalleCon.Tipo_Instruccion, DetalleCon.Importe_Instruccion, DetalleCon.Cuenta_Origen, _
                                         DetalleCon.Cuenta_Destino, DetalleCon.Tipo_Entidad_Destino, DetalleCon.Entidad_Destino, _
                                         DetalleCon.Tipo_Entidad_Origen, DetalleCon.Entidad_Origen, resultado)

                    Next

                    Dim entidadOrigen As String = String.Empty

                    getNombreEntidad(Convert.ToInt32(DetalleCon.Entidad_Origen), entidadOrigen, resultado, nombrearchivo)

                        'Enviar Confirmacion
                    EnviarConfirmacion(BodyConcentracion(), "Archivo de Concentración" & " " & "del" & " " & entidadOrigen, TipoArchivo.Procesados, rutaachivoprocesado, "C")

                    End If
            Next

            End If
    End Sub

    Public Sub ProcesarArchivos()

        Dim dt As New DataTable


        Console.WriteLine("====================================================================")
        Console.WriteLine("                             Procesando Archivos....")
        Console.WriteLine("====================================================================")
       
        'Producion()
        Dim key As String = Me.get_Llave(107)
        Dim IV As String = Me.get_Llave(108)

        ''Desarollo()
        'Dim key As String = Me.get_Llave(110)
        'Dim IV As String = Me.get_Llave(109)
        
        Dim EnumFiles As IEnumerable(Of String) = Directory.GetFiles(ArchivosRecibidos).Where(Function(p As String) _
                                                                                         p.EndsWith("txt") Or p.EndsWith("TXT") Or p.EndsWith(".xml"))
        'Dim v_reg_liquidacion As Int32

        If EnumFiles.Count > 0 Then

            'Extraer la cantidad de archivos recibidos de liquidacion.
            'v_reg_liquidacion = Directory.GetFiles(Me.ArchivosRecibidos).Where(Function(p As String) _
            '                                                                                    p.EndsWith(".xml")).Count

            For Each sfile As String In EnumFiles

                Me.counter = 0
                fileinfo = New FileInfo(sfile)
                Dim filedes As String = fileinfo.Name

                nombrearchivo = fileinfo.Name

                rutaarchivorecibido = fileinfo.FullName

                ' Archivos de Liquidacion
                If fileinfo.Extension.Equals(".xml") Then

                    rutaarchioenc = Me.ArchivoRecibidosEnc & "\" & fileinfo.Name

                    Me.AddArchivoLog(fileinfo.Name, "LQ", v_sec_log, _result)

                    If _result <> "0" Then

                        Dim dirfiledes As String = Me.ArchivoDes & "\" & filedes
                        Try
                            ''Desencriptar Archivo
                            Me.DecryptFile(fileinfo.FullName, dirfiledes, key, IV, "Archivo XML", Me.resultado)

                            Dim registros As Int32 = Directory.GetFiles(Me.ArchivoDes).Count

                            'Error desencriptando el archivo
                            If registros = 0 Then

                                MoverArchivoError("Ocurrió el siguiente error" & " " & Me.resultado & " " & "descriptando este archivo", fileinfo.FullName, "Error Desencriptando Archivo de Liquidacion o Concentracion")

                                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, Me.resultado)

                                Dim Enumdes As IEnumerable(Of String) = Directory.GetFiles(Me.ArchivosRecibidos).Where(Function(p As String) _
                                                                                                                p.EndsWith(".DESEde"))
                                For Each ardes As String In Enumdes

                                    fileinfo = New FileInfo(ardes)

                                    Dim archivoerror As String = fileinfo.Name
                                    Dim rutaachivoerror As String = Me.ArchivosConError & "\" & archivoerror

                                    MoverArchivoEnc(fileinfo.FullName, rutaachivoerror)
                                Next
                            Else

                                MoverArchivoError("Ocurrió el siguiente error" & " " & _result, fileinfo.FullName, "Archivo Liquidación de fondos")

                                Dim errdes As String = Me.ArchivoDes + "\" + fileinfo.Name

                                If File.Exists(errdes) Then
                                    File.Delete(errdes)
                                End If

                                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, _result)

                            End If
                        Catch faex As FieldAccessException
                            '' Marca como error en el log por 
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, faex.Message)
                            MoverArchivoError(faex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        Catch fex As FileNotFoundException
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fex.Message)
                            MoverArchivoError(fex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        Catch fcex As IOException
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fcex.Message)
                            MoverArchivoError(fcex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        Catch ex As Exception
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
                            MoverArchivoError(ex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        End Try
                    End If

                    If _result = "0" Then

                        Dim dirfiledes As String = Me.ArchivoDes & "\" & filedes
                        Try

                            ''Desencriptar Archivo
                            Me.DecryptFile(fileinfo.FullName, dirfiledes, key, IV, "Archivo XML", Me.resultado)

                            Dim mydirdes As New DirectoryInfo(Me.ArchivoDes)

                            'Obtengo una lista con todos los archivos que han sido procesados
                            Dim myfilesdes() As FileInfo = mydirdes.GetFiles()

                            'de la lista selecciono solo los archivos del dia
                            Dim query = From fi In myfilesdes _
                                        Order By fi.LastWriteTime Descending _
                                        Where fi.LastWriteTime.Date = DateTime.Now.Date _
                                        Select fi
                            
                            If query.Count() > 0 Then

                                ''Validar y Cargar Archivo a la base de datos.
                                Me.CargarArchvio(fileinfo.Name, _result, fileinfo.FullName)

                                Console.WriteLine("")
                                Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "ha sido procesaso")
                                
                            Else
                                'llamar exception de error de desecriptacion...
                                'Mover e Enviar correo de notificacion que ocurrio un error al memento de encriptacion del archvio. 

                                Console.WriteLine("")
                                Console.WriteLine("Ocurrio el siguiente error" & " " & Me.resultado & " " & "desencriptando el archivo" & "" & fileinfo.Name)

                                MoverArchivoError("Ocurrió el siguiente error" & " " & Me.resultado & " " & "descriptando este archivo", fileinfo.FullName, "Error Desencriptando Archivo de Liquidacion o Concentracion")

                                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, Me.resultado)

                                Dim Enumdes As IEnumerable(Of String) = Directory.GetFiles(Me.ArchivosRecibidos).Where(Function(p As String) _
                                                                                                                 p.EndsWith(".DESEde"))

                                For Each ardes As String In Enumdes

                                    fileinfo = New FileInfo(ardes)

                                    Dim archivoerror As String = fileinfo.Name
                                    Dim rutaachivoerror As String = Me.ArchivosConError & "\" & archivoerror

                                    MoverArchivoEnc(fileinfo.FullName, rutaachivoerror)
                                Next
                            End If

                        Catch faex As FieldAccessException
                            '' Marca como error en el log por 
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, faex.Message)
                            MoverArchivoError(faex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        Catch fex As FileNotFoundException
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fex.Message)
                            MoverArchivoError(fex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        Catch fcex As IOException
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fcex.Message)
                            MoverArchivoError(fcex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        End Try
                    End If

                    'Archivos de Concentracion
                ElseIf fileinfo.Extension.Equals(".txt") Or fileinfo.Extension.Equals(".TXT") Then

                    Me.AddArchivoLog(fileinfo.Name, "Con", v_sec_log, _result)

                    If _result <> "0" Then

                        Dim dirfiledes As String = Me.ArchivoDes & "\" & filedes
                        Try
                            ''Desencriptar Archivo
                            Me.DecryptFile(fileinfo.FullName, dirfiledes, key, IV, "Archvio Concentracion", Me.resultado)

                            Dim registros As Int32 = Directory.GetFiles(Me.ArchivoDes).Count

                            If registros = 0 Then

                                Console.WriteLine("")
                                Console.WriteLine("Ocurrio el siguiente error" & " " & Me.resultado & " " & "desencriptando el archivo" & "" & fileinfo.Name)

                                'Mover e Enviar correo de notificacion que ocurrio un error al memento de encriptacion del archvio. 
                                MoverArchivoError("Ocurrió el siguiente error" & " " & Me.resultado & " " & "descriptando este archivo", fileinfo.FullName, "Error Desencriptando Archivo de Liquidacion o Concentracion")
                                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, Me.resultado)

                                Dim EnumDesc As IEnumerable(Of String) = Directory.GetFiles(Me.ArchivosRecibidos).Where(Function(p As String) _
                                                                                                                            p.EndsWith(".DESEde"))
                                For Each ardes As String In EnumDesc

                                    fileinfo = New FileInfo(ardes)

                                    Dim archivoerror As String = fileinfo.Name
                                    Dim rutaachivoerror As String = Me.ArchivosConError & "\" & archivoerror

                                    MoverArchivoEnc(fileinfo.FullName, rutaachivoerror)
                                Next

                            End If

                        Catch ex As Exception
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
                            MoverArchivoError(ex.ToString, fileinfo.FullName, "Archivo Liquidación de fondos")
                        End Try
                    End If

                    If _result = "0" Then

                        Dim dirfiledes As String = Me.ArchivoDes & "\" & filedes
                        Try
                            ''Desencriptar Archivo
                            Me.DecryptFile(fileinfo.FullName, dirfiledes, key, IV, "Archvio Concentracion", Me.resultado)

                            Dim registros As Int32 = Directory.GetFiles(Me.ArchivoDes).Count

                            If registros > 0 Then
                                ''Validar y Cargar Archivo a la base de datos.
                                Me.CargarArchvio(fileinfo.Name, _result, fileinfo.FullName)

                                Console.WriteLine("")
                                Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "ha sido procesaso..")
                            Else

                                Console.WriteLine("")
                                Console.WriteLine("Ocurrio el siguiente error" & " " & Me.resultado & " " & "desencriptando el archivo" & "" & fileinfo.Name)

                                MoverArchivoError("Ocurrió el siguiente error" & " " & Me.resultado & " " & "descriptando este archivo", fileinfo.FullName, "Error Desencriptando Archivo de Concentracion")

                                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, Me.resultado)

                                Dim Enumdes As IEnumerable(Of String) = Directory.GetFiles(Me.ArchivosRecibidos).Where(Function(p As String) _
                                                                                                              p.EndsWith(".DESEde"))
                                For Each ardes As String In Enumdes
                                    fileinfo = New FileInfo(ardes)

                                    fileinfo = New FileInfo(ardes)

                                    Dim archivoerror As String = fileinfo.Name
                                    Dim rutaachivoerror As String = Me.ArchivosConError & "\" & archivoerror

                                    MoverArchivoEnc(fileinfo.FullName, rutaachivoerror)
                                Next
                            End If

                        Catch faex As FieldAccessException
                            '' Marca como error en el log por 
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, faex.Message)
                            EnviarConfirmacion("Ha ocurrido el siguiente error durante el Procesando el Archivo" + " " + fileinfo.Name + " " + faex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
                        Catch fex As FileNotFoundException
                            '' Marca como error en el log por 
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fex.Message)
                            EnviarConfirmacion("Ha ocurrido el siguiente error durante el Procesando el Archivo" + " " + fileinfo.Name + " " + fex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
                        Catch fcex As IOException
                            '' Marca como error en el log por 
                            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fcex.Message)
                            EnviarConfirmacion("Ha ocurrido el siguiente error durante el Procesando el Archivo" + " " + fileinfo.Name + " " + fcex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
                        End Try
                    Else
                        MoverArchivoError(_result, fileinfo.FullName, "Archivo Concentracion")
                    End If

                End If

            Next

        End If

    End Sub

#End Region
#Region "Funciones Internas para la validar el archivo xml"
    ''' <summary>
    ''' Function para validar el digitosControl del del tag de pago
    ''' </summary>
    ''' <param name="cadena">cadena de caracteres que desea validar el digito de control.</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function ValidarDigitosControl(ByVal cadena As String) As Int32
        Dim convert As New StringBuilder
        Dim listcodigoASCII As New List(Of Int32)
        Dim total As Int32 = 0
        Dim digitocontrol As Int32 = 0
        For Each caracter In ASCIIEncoding.ASCII.GetBytes(cadena)
            total = caracter * 13
            listcodigoASCII.Add(total)
        Next

        digitocontrol = listcodigoASCII.Sum()

        Return digitocontrol
    End Function
    ''' <summary>
    ''' funcion para validar el schema del xml
    ''' </summary>
    ''' <param name="xmlschema">Schema que va hacer validado</param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function ValidarXMLSchema(ByVal xmlschema As String) As Boolean

        Dim mySchemaXml As XDocument = <?xml version="1.0" encoding="utf-16"?>
                                       <xs:schema id="ARCHIVO" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata">
                                           <xs:element name="ARCHIVO" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">
                                               <xs:complexType>
                                                   <xs:choice minOccurs="0" maxOccurs="unbounded">
                                                       <xs:element name="ENCABEZADO">
                                                           <xs:complexType>
                                                               <xs:sequence>
                                                                   <xs:element name="TIPO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="FECHAGENERACION" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="HORAGENERACION" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="NOMBRELOTE" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="CONCEPTOPAGO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="CODIGOBICENTIDADDB" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="CODIGOBICENTIDADCR" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="TRNOPCRLBTR" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="FECHAVALORCRLBTR" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="TOTALREGISTROSCONTROL" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="TOTALMONTOSCONTROL" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="MONEDA" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="INFORMADICIONALENC01" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="ESTADOARCHIVOENPORTAL" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="CANTDESCARGASARCHIVO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="USUARIODESCARGOARCHIVO" type="xs:string" minOccurs="0"/>
                                                               </xs:sequence>
                                                           </xs:complexType>
                                                       </xs:element>
                                                       <xs:element name="PAGO">
                                                           <xs:complexType>
                                                               <xs:sequence>
                                                                   <xs:element name="NOMBREBENEFICIARIO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="IDENTIFICACIONBENEFICIARIO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="MONTOADEPOSITAR" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="NUMEROCUENTAESTANDARD" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="TIPOCUENTA" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="CONCEPTODETALLADO" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="INFORMADICIONALPAGO01" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="INFORMADICIONALPAGO02" type="xs:string" minOccurs="0"/>
                                                                   <xs:element name="DIGITOSCONTROL" type="xs:string" minOccurs="0"/>
                                                               </xs:sequence>
                                                           </xs:complexType>
                                                       </xs:element>
                                                   </xs:choice>
                                               </xs:complexType>
                                           </xs:element>
                                       </xs:schema>

        Dim c As String = mySchemaXml.Declaration.ToString + vbCrLf + mySchemaXml.ToString
        If c = xmlschema Then
            Return True
        End If
        Return False
    End Function
    ''' <summary>
    ''' funcion para Agregar el Archivo
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Protected Function ProcesarArcLiquidacion() As String

        Dim p_sec As New OracleParameter With {.ParameterName = "p_secuencia", .OracleDbType = OracleDbType.Int32, _
                                                        .Value = Me.v_sec_log}

        Dim p_nombrearchivo As New OracleParameter With {.ParameterName = "p_nombrearchivo", .OracleDbType = OracleDbType.Varchar2, _
                                                        .Value = encabezado.NombreArchivo}

        Dim p_tipo As New OracleParameter With {.ParameterName = "p_tipo", .OracleDbType = OracleDbType.Varchar2, _
                                                .Value = encabezado.Tipo}

        Dim p_fechageneracion As New OracleParameter With {.ParameterName = "p_fechageneracion", .OracleDbType = OracleDbType.Varchar2, _
                                                           .Value = encabezado.FechaGeneracion}

        Dim p_horageneracion As New OracleParameter With {.ParameterName = "p_horageneracion", .OracleDbType = OracleDbType.Varchar2, _
                                                          .Value = encabezado.HoraGeneracion}

        Dim p_nombrelote As New OracleParameter With {.ParameterName = "p_nombrelote", .OracleDbType = OracleDbType.Int32, _
                                                      .Value = encabezado.NombreLote}

        Dim p_conceptopago As New OracleParameter With {.ParameterName = "p_conceptopago", .OracleDbType = OracleDbType.Varchar2, _
                                                        .Value = encabezado.ConceptoPago}

        Dim p_codigobicentidaddb As New OracleParameter With {.ParameterName = "p_codigobicentidaddb", .OracleDbType = OracleDbType.Varchar2, _
                                                              .Value = encabezado.CodBicEntidadDB}

        Dim p_codigobicentidadcr As New OracleParameter With {.ParameterName = "p_codigobicentidadcr", .OracleDbType = OracleDbType.Varchar2, _
                                                              .Value = encabezado.CodBicEntidadCR}

        Dim p_trnopcrlbtr As New OracleParameter With {.ParameterName = "p_trnopcrlbtr", .OracleDbType = OracleDbType.Varchar2, _
                                                       .Value = encabezado.TRNopcrlbtr}

        Dim p_fechavalorcrlbtr As New OracleParameter With {.ParameterName = "p_fechavalorcrlbtr", .OracleDbType = OracleDbType.Varchar2, _
                                                            .Value = encabezado.FechaValorCRLBTR}

        Dim p_totalregistroscontrol As New OracleParameter With {.ParameterName = "p_totalregistroscontrol", .OracleDbType = OracleDbType.Int32, _
                                                                 .Value = encabezado.TotalRegistroscontrol}

        Dim p_totalmontoscontrol As New OracleParameter With {.ParameterName = "p_totalmontoscontrol", .OracleDbType = OracleDbType.Decimal, _
                                                              .Value = encabezado.TotalMontoControl}

        Dim p_moneda As New OracleParameter With {.ParameterName = "p_moneda", .OracleDbType = OracleDbType.Varchar2, _
                                                  .Value = encabezado.Moneda}
        Dim p_informadicionalenc01 As New OracleParameter With {.ParameterName = "p_informadicionalenc01", .OracleDbType = OracleDbType.Varchar2, _
                                                                .Value = encabezado.InformacionAdicional}

        Dim p_estadoarchivoenportal As New OracleParameter With {.ParameterName = "p_estadoarchivoenportal", .OracleDbType = OracleDbType.Varchar2, _
                                                                 .Value = encabezado.EstadoArchivoPortal}

        Dim p_cantdescargasarchivo As New OracleParameter With {.ParameterName = "p_cantdescargasarchivo", .OracleDbType = OracleDbType.Varchar2, _
                                                                .Value = encabezado.CantDescargaArchivo}

        Dim p_usuariodescargoarchivo As New OracleParameter With {.ParameterName = "p_usuariodescargoarchivo", .OracleDbType = OracleDbType.Varchar2, _
                                                                  .Value = encabezado.UsuarioDescargoArchivo}


        Dim p_totalregistrodetalle As New OracleParameter With {.ParameterName = "p_totalregistrodetalle", .OracleDbType = OracleDbType.Int32, _
                                                                .Value = Me.total_registros}

        Dim p_montototalregistros As New OracleParameter With {.ParameterName = "p_montototalregistros", .OracleDbType = OracleDbType.Decimal, _
                                                               .Value = Me.monto_total}

        Dim p_ArchivoXML As New OracleParameter With {.ParameterName = "p_ArchivoXML", .OracleDbType = OracleDbType.Clob, _
                                                               .Value = encabezado.ArchivoXML}

        Dim p_nombrebeneficiario As New OracleParameter With {.ParameterName = "p_nombrebeneficiario", .OracleDbType = OracleDbType.Varchar2, _
                                                              .Value = detalle.NombreBeneficairio}

        Dim p_identificacionbeneficiario As New OracleParameter With {.ParameterName = "p_identificacionbeneficiario", .OracleDbType = OracleDbType.Varchar2, _
                                                                       .Value = detalle.IdentificacionBeneficiario}

        Dim p_montoadepositar As New OracleParameter With {.ParameterName = "p_montoadepositar", .OracleDbType = OracleDbType.Decimal, _
                                                           .Value = detalle.MontoDepositar}

        Dim p_numerocuentaestandard As New OracleParameter With {.ParameterName = "p_numerocuentaestandard", .OracleDbType = OracleDbType.Varchar2, _
                                                                 .Value = detalle.NumeroCuentaEstandar}

        Dim p_tipocuenta As New OracleParameter With {.ParameterName = "p_tipocuenta", .OracleDbType = OracleDbType.Varchar2, _
                                                      .Value = detalle.TipoCuenta}

        Dim p_conceptodetallado As New OracleParameter With {.ParameterName = "p_conceptodetallado", .OracleDbType = OracleDbType.Varchar2, _
                                                             .Value = detalle.ConceptoDetallado}

        Dim p_informadicionalpago01 As New OracleParameter With {.ParameterName = "p_informadicionalpago01", .OracleDbType = OracleDbType.Varchar2, _
                                                                 .Value = detalle.InformAdicionalPago01}

        Dim p_informadicionalpago02 As New OracleParameter With {.ParameterName = "p_informadicionalpago02", .OracleDbType = OracleDbType.Varchar2, _
                                                                 .Value = detalle.InformAdicionalPago02}

        Dim p_digitoscontrol As New OracleParameter With {.ParameterName = "p_digitoscontrol", .OracleDbType = OracleDbType.Int32, _
                                                          .Value = detalle.DigitosControl}

        Dim p_digitocontrol As New OracleParameter With {.ParameterName = "p_digitocontrol", .OracleDbType = OracleDbType.Int32, _
                                                          .Value = digitocontrol}

        Dim p_counter As New OracleParameter With {.ParameterName = "p_counter", .OracleDbType = OracleDbType.Int32, _
                                                          .Value = Me.counter}


        Dim p_resultnumber As New OracleParameter With {.ParameterName = "p_result_number", .Direction = ParameterDirection.InputOutput, _
                                                        .OracleDbType = OracleDbType.NVarchar2, .Size = 200}

        Dim parameters() As OracleParameter = {p_sec, p_nombrearchivo, p_tipo, p_fechageneracion, p_horageneracion, p_nombrelote, p_conceptopago, _
        p_codigobicentidaddb, p_codigobicentidadcr, p_trnopcrlbtr, p_fechavalorcrlbtr, p_totalregistroscontrol, p_totalmontoscontrol, _
        p_moneda, p_informadicionalenc01, p_estadoarchivoenportal, p_cantdescargasarchivo, p_usuariodescargoarchivo, p_totalregistrodetalle, p_montototalregistros, p_ArchivoXML, _
        p_nombrebeneficiario, p_identificacionbeneficiario, p_montoadepositar, p_numerocuentaestandard, p_tipocuenta, p_conceptodetallado, _
        p_informadicionalpago01, p_informadicionalpago02, p_digitoscontrol, p_digitocontrol, p_counter, p_resultnumber}

        Try
            OracleHelper.IntProcedure("bc_manejoarchivoxml_pkg.ProcesarArcLiquidacion", parameters)
            Me.resultado = p_resultnumber.Value.ToString
        Catch oex As OracleException
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, oex.Message)
            MoverArchivoError("Ha ocurrido el siguiente error Agregando este archvio : " + "" + oex.Message, fileinfo.FullName, "Archivo XML")
        End Try
        Return Me.resultado
    End Function
    Protected Friend Sub EnviarConfirmacion(ByVal body As String, ByVal Asunto As String, ByVal tipoArchivo As TipoArchivo, Optional ByVal file1 As String = Nothing, Optional ByVal Caso As String = "")

        Select Case tipoArchivo

            Case tipoArchivo.Procesados

                Dim Res As Boolean
                Dim MsgError As String = ""
                Dim NombArch As String = ""

                EnviarEmail(CLBCRD.TipoArchivo.Procesados, Asunto, body, Res, MsgError, NombArch, file1)

                If Res = False Then
                    Set_Estatus_Error("ERAP", v_sec_log, NombArch, 59, MsgError)
                End If

                'Errror en la apliacion ya sea por que no existe el archivo, o por que alla ocurrido algun error durante el proceso.
            Case tipoArchivo.Aplicacion

                Dim Res As Boolean
                Dim MsgError As String = ""
                Dim NombArch As String = ""

                EnviarEmail(CLBCRD.TipoArchivo.Procesados, Asunto, body, Res, MsgError, NombArch)

                If Res = False Then
                    Set_Estatus_Error("ERAP", v_sec_log, NombArch, 59, MsgError)
                End If
        End Select

    End Sub
    Private Sub EnviarEmail(ByVal tipo As TipoArchivo, ByVal Asunto As String, ByVal Cuerpo As String, ByRef Resultado As Boolean, ByRef MensajeError As String, ByRef NombreArchivoError As String, Optional ByVal Attachment As String = Nothing)
        'archivo procesado correctamente
        Resultado = False

        Dim dfrom As New MailAddress(Cons.MailFrom)

        Dim message As New MailMessage
        Dim smtp As New SmtpClient
        Dim oks As String = String.Empty
        Dim errores As String = String.Empty
        Dim direcciones As String = String.Empty

        Try

            getMailAddress(oks, errores)
            direcciones = oks & "," & errores

            Console.WriteLine("Los Oks:" & oks)

            message.From = dfrom
            message.To.Add(oks)

            message.Subject = Asunto
            message.IsBodyHtml = True
            message.Body = Cuerpo
            message.Priority = MailPriority.Normal
            message.BodyEncoding = System.Text.Encoding.Default

            If Attachment.Length > 0 Then
                message.Attachments.Add(New Attachment(Attachment))
            End If

            smtp.Host = Cons.SMTPhost

            Console.WriteLine("")
            Console.WriteLine("Enviando Reporte....")
            smtp.Send(message)

            If message.Attachments.Count > 0 Then
                Console.WriteLine("Reporte enviado: " & message.Attachments.Item(0).Name)
            Else
                Console.WriteLine("Reporte enviado sin attach... ")
            End If


            Resultado = True

        Catch ex As Exception

            Resultado = False
            MensajeError = ex.Message
            Dim NombreAr As String = ""


            If message.Attachments.Count > 0 Then

                NombreArchivoError = message.Attachments.Item(0).Name
                NombreAr = message.Attachments.Item(0).Name.Replace(".TXT", ".html")

            End If


            Console.WriteLine("Error enviando por email el archivo: " & NombreAr)
            Console.WriteLine(ex.ToString())
            Console.WriteLine("Se procedio a generar el archivo en el FileSystem")


            If message.Attachments.Count > 0 Then
                Try
                    System.IO.File.WriteAllText(NombreAr, Cuerpo)
                Catch ex2 As Exception
                    Console.WriteLine("")
                    Console.WriteLine("Error grabando el reporte en el FileSystem: ")
                    Console.WriteLine(ex2.ToString())
                End Try
            End If

        End Try

    End Sub
    ''' <summary>
    ''' metodo para obtener el listado de correos aquienes se le va ha enviar el archivo si este es procesado o si da algun error
    ''' </summary>
    ''' <param name="listok">correos si el archivo xml es procesado correctamente</param>
    ''' <param name="listerror">correos si el archivo xml da</param>
    ''' <remarks></remarks>
    Public Shared Sub getMailAddress(ByRef listok As String, ByRef listerror As String)
        Dim plistok As New OracleParameter With {.ParameterName = "p_listok", .Direction = ParameterDirection.Output, .Size = "200"}
        Dim plisterror As New OracleParameter With {.ParameterName = "p_listerror", .Direction = ParameterDirection.Output, .Size = "200"}
        Try
            OracleHelper.IntProcedure("bc_manejoarchivoxml_pkg.getMailAddress", plistok, plisterror)
            listok = plistok.Value.ToString
            listerror = plisterror.Value.ToString
        Catch ex As Exception
            Console.WriteLine(ex.ToString())
            ''Set_Estatus_Error("ERAP", v_sec_log, 59, ex.Message)
            'EnviarConfirmacion("Ha ocurrido el siguiente error Obteniendo el listado de los correos" + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Public Sub CargarArchvio(ByRef nombrearchivo As String, ByRef outdes As String, ByVal rutaorgien As String)

        Dim EnumFiles As IEnumerable(Of String) = Directory.GetFiles(ArchivoDes).Where(Function(p As String) _
                                                                                            p.EndsWith(".TXT") Or p.EndsWith(".xml"))

        If EnumFiles.Count() > 0 Then

            For Each _file As String In EnumFiles

                fileinfo = New FileInfo(_file)
                Me.counter = 0

                nombrearchivo = fileinfo.Name

                'Marcar como desencriptado....
                Set_Estatus_Error("DES", Me.v_sec_log, fileinfo.Name, 46)

                Console.WriteLine("")
                Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "ha sido desencriptado")

                If fileinfo.Extension.Equals(".xml") Then
                    Try


                        'Marcar en el Log que el archivo esta en proceso.
                        Set_Estatus_Error("EPR", v_sec_log, nombrearchivo, 31)

                        Console.WriteLine("")
                        Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "esta en proceso")

            
                        rutaarchioenc = Me.ArchivoRecibidosEnc & "\" & fileinfo.Name

                        Dim dataXML As New DataSet
                        dataXML.ReadXml(fileinfo.FullName)
                        nombrearchivo = fileinfo.Name
                        Dim schema As String = Convert.ToString(dataXML.GetXmlSchema)

                        If ValidarXMLSchema(schema) Then


                            xmldoc = XElement.Load(fileinfo.FullName)

                            'Leer el tab <Encabezado> del archivo XML para cargar las propiedades del objecto Encabezado.
                            Dim queryenc = From encabezado In xmldoc.Elements("ENCABEZADO") _
                                           Select encabezado

                            fechahora = queryenc.Elements("FECHAGENERACION").Value & " " & queryenc.Elements("HORAGENERACION").Value
                            encabezado.NombreArchivo = fileinfo.Name
                            encabezado.Tipo = queryenc.Elements("TIPO").Value
                            encabezado.FechaGeneracion = queryenc.Elements("FECHAGENERACION").Value
                            encabezado.HoraGeneracion = fechahora
                            encabezado.NombreLote = Convert.ToInt32(queryenc.Elements("NOMBRELOTE").Value)
                            encabezado.ConceptoPago = queryenc.Elements("CONCEPTOPAGO").Value
                            encabezado.CodBicEntidadDB = queryenc.Elements("CODIGOBICENTIDADDB").Value
                            encabezado.CodBicEntidadCR = queryenc.Elements("CODIGOBICENTIDADCR").Value
                            encabezado.TRNopcrlbtr = queryenc.Elements("TRNOPCRLBTR").Value
                            encabezado.FechaValorCRLBTR = queryenc.Elements("FECHAVALORCRLBTR").Value
                            encabezado.TotalRegistroscontrol = Convert.ToInt32(queryenc.Elements("TOTALREGISTROSCONTROL").Value)
                            encabezado.TotalMontoControl = Convert.ToDecimal(queryenc.Elements("TOTALMONTOSCONTROL").Value)
                            encabezado.Moneda = queryenc.Elements("MONEDA").Value
                            encabezado.InformacionAdicional = queryenc.Elements("INFORMADICIONALENC01").Value
                            encabezado.EstadoArchivoPortal = queryenc.Elements("ESTADOARCHIVOENPORTAL").Value
                            encabezado.CantDescargaArchivo = queryenc.Elements("CANTDESCARGASARCHIVO").Value
                            encabezado.UsuarioDescargoArchivo = queryenc.Elements("USUARIODESCARGOARCHIVO").Value
                            encabezado.ArchivoXML = dataXML.GetXml

                            '' Leer el tag<pago> del detalle del archivio xml  para cargar las propiedades del objecto Detalle
                            Dim querydetalle = From detalle In xmldoc.Elements("PAGO") _
                                               Select detalle


                            'obtener la total de la cantidad de registros
                            total_registros = querydetalle.Count

                            'obtener la suma del monto Depositar
                            monto_total = querydetalle.Sum(Function(p As XElement) _
                                                               Decimal.Parse(p.Element("MONTOADEPOSITAR").Value))

                            For Each elepago As XElement In querydetalle

                                detalle.NombreBeneficairio = elepago.Element("NOMBREBENEFICIARIO").Value
                                detalle.IdentificacionBeneficiario = elepago.Element("IDENTIFICACIONBENEFICIARIO").Value
                                detalle.MontoDepositar = Convert.ToDecimal(elepago.Element("MONTOADEPOSITAR").Value)
                                detalle.NumeroCuentaEstandar = elepago.Element("NUMEROCUENTAESTANDARD").Value
                                detalle.TipoCuenta = elepago.Element("TIPOCUENTA").Value
                                detalle.ConceptoDetallado = elepago.Element("CONCEPTODETALLADO").Value
                                detalle.InformAdicionalPago01 = elepago.Element("INFORMADICIONALPAGO01").Value
                                detalle.InformAdicionalPago02 = elepago.Element("INFORMADICIONALPAGO02").Value
                                detalle.DigitosControl = Convert.ToInt32(elepago.Element("DIGITOSCONTROL").Value)
                                cadena = detalle.NombreBeneficairio & detalle.IdentificacionBeneficiario & detalle.MontoDepositar & detalle.NumeroCuentaEstandar & _
                                detalle.TipoCuenta & detalle.ConceptoDetallado & detalle.InformAdicionalPago01 & detalle.InformAdicionalPago02
                                digitocontrol = ValidarDigitosControl(cadena)
                                detalle.NombreArchivo = encabezado.NombreArchivo
                                detalle.NombreLote = encabezado.NombreLote
                                Me.counter += 1

                                ProcesarArcLiquidacion()

                                If Me.resultado <> "0" Then
                                    Exit For
                                End If
                            Next
                            ''archvio proceso correctamente
                            If Me.resultado = "0" Then

                                Set_Estatus_Error("PRC", v_sec_log, nombrearchivo, 37)

                                Console.WriteLine("")
                                Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "ha sido procesado")

                                Dim archivorprocesado As String = fileinfo.Name

                                Dim entidadnombre As String = String.Empty

                                Dim rutaachivoprocesado As String = Me.ArchivosProcesados & "\" & archivorprocesado

                               
                                Dim archivocomp As String = rutaachivoprocesado + ".Zip"

                                If File.Exists(fileinfo.FullName) = False Then
                                    Dim fsprocesado As FileStream = File.Create(fileinfo.FullName)
                                    fsprocesado.Close()
                                End If

                                If File.Exists(rutaachivoprocesado) Then
                                    File.Delete(rutaachivoprocesado)
                                End If

                                '' Mover este archivo hacia la carpeta de Archivo procesado.
                                File.Move(fileinfo.FullName, rutaachivoprocesado)

                                getEntidadNombrePorBic(encabezado.CodBicEntidadCR, entidadnombre, resultado)

                                Me.resultado = String.Empty

                                'Enviar Confirmacion

                                EnviarConfirmacion(Body(), "Archivo de Liquidación de fondos" + " " + "del" + " " + entidadnombre, TipoArchivo.Procesados, rutaachivoprocesado, "L")

                                MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                                'Marcar como enviado
                                Set_Estatus_Error("ENV", v_sec_log, nombrearchivo, 48)

                            Else

                                Dim entidadnombre As String = String.Empty
                                Dim out As String = String.Empty
                                getEntidadNombrePorBic(encabezado.CodBicEntidadCR, entidadnombre, out)

                                Console.WriteLine("")
                                Console.WriteLine("Ocurrio el siguiente error" & " " & Me.resultado & " " & "" & "procesando el archvio" & "" & fileinfo.Name)

                                ' Mover al directorio de archivos con errores
                                MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)

                                MoverArchivoError(resultado, fileinfo.FullName, "Archivo de Liquidación de fondos" + " " + "del" + " " + entidadnombre)

                            End If
                        Else
                            'Marcar como error en la tabla de log.
                            Console.WriteLine("")
                            Console.WriteLine("Error validando el schema de este archvio" & " " & fileinfo.Name)

                            Set_Estatus_Error("ERR", v_sec_log, nombrearchivo, 36)

                        End If


                    Catch faex As FieldAccessException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, faex.Message)
                        MoverArchivoError("Ha ocurrido el siguiente error Cargando el archvio" + " " + faex.Message, fileinfo.FullName, "Archivo Liquidacion")
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch fex As FileNotFoundException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fex.Message)
                        MoverArchivoError("Ha ocurrido el siguiente error Cargando el archvio" + " " + fex.Message, fileinfo.FullName, "Archivo Liquidacion")
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch fcex As IOException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, fcex.Message)
                        MoverArchivoError("Ha ocurrido el siguiente error Cargando el archvio" + " " + fcex.Message, fileinfo.FullName, "Archivo Liquidacion")
                    Catch xex As Xml.XmlException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, xex.Message)
                        MoverArchivoError("Ha ocurrido el siguiente error Cargando el archvio" + " " + xex.Message, fileinfo.FullName, "Archivo Liquidacion")
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    End Try

                ElseIf fileinfo.Extension.Equals(".TXT") Then

                    Try
                        'Marcar archivo como que esta en proceso en la tabla de Log.
                        Set_Estatus_Error("EPR", v_sec_log, nombrearchivo, 31)
                       

                        nombrearchivo = fileinfo.Name

                        rutaarchioenc = Me.ArchivoRecibidosEnc & "\" & fileinfo.Name

                        Console.WriteLine("")
                        Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "esta en proceso")


                        'Obtener los valores del encabezado y cargar las variables correspondientes.
                        getEncabezadoValues(fileinfo.Name, Enc.NombreArchivo, Enc.Proceso, Enc.SubProceso, Enc.EntidadReceptora, Enc.FechaTransmision, Enc.NroLote, resultado)

                        If Not resultado.Equals("0") Then
                            Throw New EncabezadoException(resultado)
                        End If

                        'Extraer solo la linea del sumario
                        Dim EnumSumario As IEnumerable(Of String) = File.ReadAllLines(fileinfo.FullName).Where(Function(p As String) _
                                                                                       p.StartsWith("S"))
                        'Lineasumario = EnumSumario.Single

                        ' Cargar las propiedades de la estructura del sumario.
                        getSumarioValues(EnumSumario.Single, Sumario.Numero_Registros, Sumario.Total_Liquidar_Ajuste, Sumario.Monto_Aclarado, Sumario.Total_Ajuste, Sumario.Total_Liquidar, resultado)

                        If Not resultado.Equals("0") Then
                            Throw New SumarioException(resultado)
                        End If

                        'Extraer las lineas del Detalle
                        Dim EnumDetalle As IEnumerable(Of String) = File.ReadAllLines(fileinfo.FullName).Where(Function(p As String) _
                                                                                                         p.StartsWith("D"))

                        Me.total_registros = EnumDetalle.Count

                        For Each detalle As String In EnumDetalle
                            '' Llamar metodo para agregar el Detalle
                            getDetalleValues(detalle, DetalleCon.FechaSolicutud, DetalleCon.Tipo_Instruccion, DetalleCon.Importe_Instruccion, DetalleCon.Cuenta_Origen, _
                                             DetalleCon.Cuenta_Destino, DetalleCon.Tipo_Entidad_Destino, DetalleCon.Entidad_Destino, _
                                             DetalleCon.Tipo_Entidad_Origen, DetalleCon.Entidad_Origen, resultado)

                            If Not resultado.Equals("0") Then
                                Throw New DetalleException(resultado)
                            End If

                            Me.counter += 1

                            Me.ProcesarArcConcentracion(v_sec_log, nombrearchivo, DetalleCon.FechaSolicutud, DetalleCon.Tipo_Instruccion, DetalleCon.Importe_Instruccion, DetalleCon.Cuenta_Origen, _
                                                        DetalleCon.Cuenta_Destino, DetalleCon.Tipo_Entidad_Destino, _
                                                        DetalleCon.Entidad_Destino, DetalleCon.Tipo_Entidad_Origen, DetalleCon.Entidad_Origen, _
                                                        Sumario.Numero_Registros, Sumario.Total_Liquidar_Ajuste, Sumario.Monto_Aclarado, Sumario.Total_Ajuste, Sumario.Total_Liquidar, _
                                                        counter, total_registros, Me.resultado)

                            If Me.resultado <> "0" Then
                                Throw New ExceptionConcentracionFondos(resultado)
                            End If
                        Next

                        ''archvio proceso correctamente
                        If Me.resultado = "0" Then

                            Set_Estatus_Error("PRC", v_sec_log, nombrearchivo, 37)

                            Console.WriteLine("")
                            Console.WriteLine("El siguiente archivo" & " " & fileinfo.Name & " " & "ha sido procesado")

                            Dim archivorprocesado As String = fileinfo.Name

                            Dim entidadOrigen As String = String.Empty

                            rutaachivoprocesado = Me.ArchivosProcesados & "\" & archivorprocesado

                            If File.Exists(fileinfo.FullName) = False Then
                                Dim fsprocesado As FileStream = File.Create(fileinfo.FullName)
                                fsprocesado.Close()
                            End If

                            If File.Exists(rutaachivoprocesado) Then
                                File.Delete(rutaachivoprocesado)
                            End If

                            '' Mover este archivo hacia la carpeta de Archivo procesado.
                            File.Move(fileinfo.FullName, rutaachivoprocesado)

                            getNombreEntidad(Convert.ToInt32(DetalleCon.Entidad_Origen), entidadOrigen, resultado, nombrearchivo)

                            'Enviar Confirmacion

                            EnviarConfirmacion(BodyConcentracion(), "Archivo de Concentración" & " " & "del" & " " & entidadOrigen, TipoArchivo.Procesados, rutaachivoprocesado, "C")

                            MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                            'Marcar como enviado
                            Set_Estatus_Error("ENV", v_sec_log, nombrearchivo, 48)
                        Else
                            Dim entidadOrigen As String = String.Empty

                            'Marcar como error en la tabla de log.
                            Console.WriteLine("")
                            Console.WriteLine("Error validando el schema de este archvio" & " " & fileinfo.Name)

                            getNombreEntidad(Convert.ToInt32(DetalleCon.Entidad_Origen), entidadOrigen, resultado, nombrearchivo)

                            MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                            MoverArchivoError(Me.resultado, fileinfo.FullName, "Archivo de Concentración" & " " & "del" & " " & entidadOrigen)
                        End If
                    Catch sex As SumarioException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, sex.Message)
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch eex As EncabezadoException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, eex.Message)
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch dex As DetalleException
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, dex.Message)
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch cex As ExceptionConcentracionFondos
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, cex.Message)
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                    Catch ex As Exception
                        Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
                        MoverArchivoEnc(rutaarchivorecibido, rutaarchioenc)
                        MoverArchivoError("Ha ocurrido el siguiente error Cargando el archvio" + " " + ex.Message, fileinfo.FullName, "Archivo Concentracion")
                    End Try
                End If
            Next

        Else
            'Mover e Enviar correo de notificacion que ocurrio un error al memento de encriptacion del archvio. 
            MoverArchivoError("Ocurrió el siguiente error" & " " & Me.resultado & "descriptando este archivo", rutaorgien, "Error Desencriptando Archivo de Liquidacion o Concentracion")
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 48, Me.resultado)
        End If

    End Sub
    Protected Sub getDetalleValues(ByVal det As String, ByRef fechasolicitud As String, ByRef tipo_instruccion As String, ByRef importe_instruccion As Decimal, _
                                   ByRef cuenta_origen As String, ByRef cuenta_destino As String, ByRef tipo_entidad_destino As Int32, _
                                   ByRef entidad_destino As Int32, ByRef tipo_entidad_origen As Int32, ByRef entidad_origen As Int32, ByRef result As String)

        Dim fecha As String = String.Empty
        Dim dec As String = String.Empty

        Try

            fecha = det.Substring(1, 8)
            fechasolicitud = fecha.Substring(0, 2) + "/" + fecha.Substring(2, 2) + "/" + fecha.Substring(4, 4)
            tipo_instruccion = det.Substring(9, 2)
            importe_instruccion = Convert.ToDecimal(det.Substring(13, 24))
            cuenta_origen = Trim(det.Substring(37, 25))
            cuenta_destino = Trim(det.Substring(62, 25))
            tipo_entidad_destino = Convert.ToInt32(det.Substring(87, 2))
            entidad_destino = Convert.ToInt32(det.Substring(89, 2))
            tipo_entidad_origen = Convert.ToInt32(det.Substring(91, 2))
            entidad_origen = Convert.ToInt32(det.Substring(93, 2))
            result = "0"
        Catch ex As Exception
            MoverArchivoError("Ha ocurrido el siguiente error Obteniendo los Valores del detalle del archvio" + " " + ex.Message, fileinfo.FullName, "Archivo Concentracion")
            result = ex.Message
        End Try

    End Sub
    Protected Sub getSumarioValues(ByVal sumario As String, ByRef Numero_registros As Int32, ByRef total_liquidar_ajuste As Decimal, ByRef monto_aclarado As Decimal, _
                                   ByRef total_ajuste As Decimal, ByRef total_liquidar As Decimal, ByRef result As String)


        Try
            Numero_registros = Convert.ToInt32(sumario.Substring(1, 5))
            total_liquidar_ajuste = Convert.ToDecimal(sumario.Substring(6, 25))
            monto_aclarado = Convert.ToDecimal(sumario.Substring(31, 25))
            total_ajuste = Convert.ToDecimal(sumario.Substring(56, 25))
            total_liquidar = Convert.ToDecimal(sumario.Substring(81, 25))
            result = "0"
        Catch ex As Exception
            MoverArchivoError("Ha ocurrido el siguiente error Obteniendo los Valores del sumario del archivo :" + " " + ex.Message, fileinfo.FullName, "Archivo Concentracion")
            result = ex.Message
        End Try
    End Sub
    Protected Sub getEncabezadoValues(ByVal Archivo As String, ByRef NombreArchivo As String, ByRef Proceso As String, ByRef Sub_Proceso As String, ByRef EntidadFondos As String, ByRef FechaTransmision As String, ByRef NroLote As String, ByRef result As String)
        Dim fecha As String = String.Empty
        Try
            NombreArchivo = Archivo
            Proceso = Archivo.Substring(0, 2)
            Sub_Proceso = Archivo.Substring(2, 2)
            EntidadFondos = Archivo.Substring(6, 2)
            fecha = Archivo.Substring(8, 8)
            FechaTransmision = fecha.Substring(0, 2) + "/" + fecha.Substring(2, 2) + "/" + fecha.Substring(4, 4)
            NroLote = Archivo.Substring(16, 6)
            result = "0"
        Catch ex As Exception
            MoverArchivoError("Ha ocurrido el siguiente error Obteniendo los Valores del encabezado del archivo :" + " " + ex.Message, fileinfo.FullName, "Archivo Concentracion")
            result = ex.Message
        End Try
    End Sub
    Protected Function ProcesarArcConcentracion(ByVal secuencia As Int32, ByVal nombrearchivo As String, ByVal fecha_solicitud As String, ByVal tipo_instruccion As String, ByVal importe_instruccion As Decimal, _
                                           ByVal cuenta_origen As String, ByVal cuenta_destino As String, ByVal tipo_entidad_depositen_fondo As Int32, _
                                           ByVal entidad_depositen_fondo As Int32, ByVal tipo_entidad_depositar_fondo As Int32, ByVal entidad_depositar_fondo As Int32, _
                                           ByVal Numero_registros As Int32, ByVal total_liquidar_ajuste As Decimal, ByVal monto_aclarado As Decimal, ByVal total_ajuste As Decimal, _
                                           ByVal total_liquidar As Decimal, ByVal counter As Int32, ByVal cantidad_detalle As Int32, ByVal result As String) As String


        Dim p_secuencia As New OracleParameter With {.ParameterName = "p_secuencia", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = secuencia}

        Dim p_nombrearchivo As New OracleParameter With {.ParameterName = "p_nombrearchivo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = nombrearchivo}

        Dim p_fecha_solicitud As New OracleParameter With {.ParameterName = "p_fecha_solicitud", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = fecha_solicitud}

        Dim p_tipo_instruccion As New OracleParameter With {.ParameterName = "p_tipo_instruccion", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = tipo_instruccion}

        Dim p_importe_instruccion As New OracleParameter With {.ParameterName = "p_importe_instruccion", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Decimal, .Value = importe_instruccion}

        Dim p_cuenta_origen As New OracleParameter With {.ParameterName = "p_cuenta_origen", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = cuenta_origen}

        Dim p_cuenta_destino As New OracleParameter With {.ParameterName = "p_cuenta_destino", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = cuenta_destino}

        Dim p_tipo_entidad_depositen_fondo As New OracleParameter With {.ParameterName = "p_tipo_entidad_depositen_fondo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = tipo_entidad_depositen_fondo}

        Dim p_entidad_depositen_fondo As New OracleParameter With {.ParameterName = "p_entidad_depositen_fondo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = entidad_depositen_fondo}

        Dim p_tipo_entidad_depositar_fondo As New OracleParameter With {.ParameterName = "p_tipo_entidad_depositar_fondo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = tipo_entidad_depositar_fondo}

        Dim p_entidad_depositar_fondo As New OracleParameter With {.ParameterName = "p_entidad_depositar_fondo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = entidad_depositar_fondo}

        Dim p_Numero_registros As New OracleParameter With {.ParameterName = "p_Numero_registros", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = Numero_registros}

        Dim p_total_liquidar_ajuste As New OracleParameter With {.ParameterName = "p_total_liquidar_ajuste", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Decimal, .Value = total_liquidar_ajuste}

        Dim p_monto_aclarado As New OracleParameter With {.ParameterName = "p_monto_aclarado", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Decimal, .Value = monto_aclarado}

        Dim p_total_ajuste As New OracleParameter With {.ParameterName = "p_total_ajuste", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Decimal, .Value = total_ajuste}

        Dim p_total_liquidar As New OracleParameter With {.ParameterName = "p_total_liquidar", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Decimal, .Value = total_liquidar}

        Dim p_counter As New OracleParameter With {.ParameterName = "p_counter", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = counter}

        Dim p_cantidad_detalle As New OracleParameter With {.ParameterName = "p_cantidad_detalle", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = cantidad_detalle}

        Dim p_result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Value = result, .Size = 200}


        Dim parametes() As OracleParameter = {p_secuencia, p_nombrearchivo, p_fecha_solicitud, p_tipo_instruccion, p_importe_instruccion, p_cuenta_origen, _
                                              p_cuenta_destino, p_tipo_entidad_depositen_fondo, p_entidad_depositen_fondo, p_tipo_entidad_depositar_fondo, p_entidad_depositar_fondo, _
                                              p_Numero_registros, p_total_liquidar_ajuste, p_monto_aclarado, p_total_ajuste, p_total_liquidar, p_counter, p_cantidad_detalle, p_result}

        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.ProcesarArcConcentracion", parametes)
            Me.resultado = p_result.Value.ToString


        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
            MoverArchivoError("Ha ocurrido el siguiente error:" + " " + ex.Message, +" " + "Agregando este archivo" + fileinfo.FullName, "Archivo Concentracion")
        End Try
        Return Me.resultado
    End Function
    Protected Function RunCmd(ByVal p_cmd As String, ByVal p_result As Int32) As Int32
        Dim myresul As Int32 = 0
        Dim pcmd As New OracleParameter With {.ParameterName = "p_cmd", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = p_cmd}
        Dim result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Int32, .Size = 200}
        OracleHelper.IntProcedure("bc_manejoarchivoxml_pkg.RunCmd", pcmd, result)
        myresul = Convert.ToInt32(result.Value)
        Return myresul
    End Function
    Protected Friend Sub DecryptFile(ByVal FileIn As String, ByVal Fileout As String, ByVal key As String, ByVal IV As String, ByVal asunto As String, ByRef resultado As String)

        Dim processstar As New ProcessStartInfo()
        ''processstar.FileName = Me.javadir + "java.exe"
        processstar.FileName = "java.exe"
        processstar.Arguments = "-cp  c:\java\ cifrado -v -d" & " " & FileIn & " " & Fileout & " " & key & " " & IV
        processstar.RedirectStandardInput = True
        processstar.RedirectStandardOutput = True
        processstar.UseShellExecute = False
        Dim javaproceso As New Process
        javaproceso.StartInfo = processstar

        Try
            javaproceso.Start()

            Dim outStr As String = javaproceso.StandardOutput.ReadToEnd().Trim

            resultado = outStr

            javaproceso.WaitForExit()

            If String.IsNullOrEmpty(outStr) Then
                Set_Estatus_Error("ERR", Me.v_sec_log, fileinfo.Name, 45)
            End If

        Catch pex As Win32Exception
            If pex.NativeErrorCode = ERROR_FILE_NOT_FOUND Then
                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, pex.Message)
                EnviarConfirmacion("Ha ocurrido el siguiente error procesando archivo de concentracion archvio" + " " + pex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
            ElseIf pex.NativeErrorCode = ERROR_ACCESS_DENIED Then
                Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, pex.Message)
                EnviarConfirmacion("Ha ocurrido el siguiente error procesando archivo de concentracion archvio" + " " + pex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
            End If

        End Try
    End Sub
    Protected Friend Sub AddArchivoLog(ByVal nombrearchivo As String, ByVal tipo As String, ByVal sec_ As Int32, ByVal result As String)
        Dim p_archivo As New OracleParameter With {.ParameterName = "p_nombrearchivo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = nombrearchivo}
        Dim p_tipo As New OracleParameter With {.ParameterName = "p_tipo_archivo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = tipo}
        Dim p_sec As New OracleParameter With {.ParameterName = "p_sec", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Int32, .Size = 200}
        Dim p_result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}

        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.addarchivolog", p_archivo, p_tipo, p_sec, p_result)
            v_sec_log = Convert.ToInt32(p_sec.Value.ToString)
            _result = Convert.ToString(p_result.Value)
        Catch ex As Exception
            EnviarConfirmacion("Ha ocurrido el siguiente error procesando archivo de concentracion archvio" + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Protected Friend Sub Set_Estatus_Error(ByVal operacion As String, ByVal sec As Int32, ByVal nombrearchivo As String, ByVal p_errorid As Int32, Optional ByVal ErrorApp As String = Nothing)

        Dim p_operacion As New OracleParameter With {.ParameterName = "p_operacion", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = operacion}
        Dim p_error_id As New OracleParameter With {.ParameterName = "p_error_id", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = p_errorid}
        Dim p_sec As New OracleParameter With {.ParameterName = "p_sec", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = sec}
        Dim p_nombrearchivo As New OracleParameter With {.ParameterName = "p_nombre_archivo", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = nombrearchivo}
        Dim p_ErrorApp As New OracleParameter With {.ParameterName = "p_error_ap", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = ErrorApp}

        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.set_archive_status", p_operacion, p_error_id, p_sec, p_nombrearchivo, p_ErrorApp)
        Catch ex As OracleException
            EnviarConfirmacion("Ha ocurrido el siguiente error procesando archivo de concentracion archvio" + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try

    End Sub
    Protected Friend Function get_Llave(ByVal parametro As Int32) As String
        Dim p_parametroid As New OracleParameter With {.ParameterName = "p_id_parametro", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = parametro}
        Dim p_llave As New OracleParameter With {.ParameterName = "p_llave", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}

        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.get_llaves_XML", p_parametroid, p_llave)
        Catch ex As OracleException
            EnviarConfirmacion("Ha ocurrido el siguiente error procesando archivo de concentracion o de liquidacion archvio" + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
        Return p_llave.Value.ToString
    End Function
    Protected Function Body() As String

        Dim _body As String = String.Empty
        Dim proceso As String = String.Empty
        '' Leer el tag<pago> del detalle del archvio xml  para cargar las propiedades del objecto Detalle

        Dim querydetalle = From detalle In xmldoc.Elements("PAGO") _
                           Select detalle


        getDesProceso(encabezado.TRNopcrlbtr, proceso, resultado)

        If Not resultado.Equals("0") Then
            Set_Estatus_Error("ERAP", v_sec_log, encabezado.NombreArchivo, 59, resultado)
        End If

        _body = "<!DOCTYPE html PUBLIC " & "-//W3C//DTD XHTML 1.0 Transitional//EN" & "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" & ">" _
        & "<html xmlns=" & """" & "http://www.w3.org/1999/xhtml" & """>" _
          & "<head> " _
           & "<title>Untitled Page</title>" _
              & "<style type=" & """" & "text/css" & """" & ">" _
        & ".style1" _
        & "{" _
            & "width: 190px;" _
            & "font-weight: bold;" _
        & "}" _
        & ".style2" _
        & "{" _
            & "text-align: center;" _
            & "font-weight: bold; " _
        & "}" _
        & ".style3" _
        & "{" _
            & "width: 326px;" _
        & "}" _
        & ".style4" _
        & "{" _
            & "width: 681px;" _
            & "text-align: center;" _
            & "font-weight: bold;" _
            & "font-size:22px;" _
            & "font-family: Calibri;" _
        & "}" _
        & ".style5" _
        & "{" _
            & "width: 681px;" _
            & "text-align: center;" _
            & "font-weight: bold;" _
             & "font-size:18px;" _
             & "font-family: Calibri;" _
        & "}" _
        & "</style>" _
           & "</head>" _
           & "<body>" _
            & "<table style=" & """" & "width:100%;" & """>" _
               & "<tr>" _
                     & "<td class=" & """" & "style3" & """>" _
                           & "<img src= " & """" & "http://www.tss2.gov.do/images/logoTSShorizontal.gif" & """ />" _
                      & "<td class=" & """" & "style4" & """>" _
                   & "Tesorería de la Seguridad Social " & " <br /> Departamento de Operaciones & Tecnología" _
                 & "</td>" _
                     & "<td>" _
                     & "&nbsp;</td>" _
                 & "</tr>" _
           & "</table>" _
           & "<table style=" & """" & "width:100%;" & """>" _
             & "<tr>" _
                 & "<td class=" & """" & "style3" & """>" _
                     & "&nbsp;</td>" _
                 & "<td class=" & """" & "style5" & """ >" _
                        & "Reporte de Liquidación de Fondos del " & encabezado.NombreEntidadRecaudadora & "</td>" _
                 & "<td>" _
                     & "&nbsp;</td>" _
             & "</tr>" _
             & "</table>" _
             & "<br />" _
            & "<table style=" & """" & "font-family:Calibri; border-collapse: collapse;width: 100%;font-size:smaller;" & """>" _
                   & "<tr>" _
                         & "<td class=" & """" & "style1" & """" & " > " _
                & "Nombre del Archivo:</td>" _
                         & "<td>" _
                               & encabezado.NombreArchivo _
                      & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                          & "Proceso:" _
                       & "</td>" _
                       & "<td>" _
                         & proceso _
                 & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                        & "<td class=" & """" & "style1" & """" & " > " _
                & "TRN:</td>" _
                         & "<td>" _
                           & encabezado.TRNopcrlbtr _
                & "&nbsp;</td>" _
                     & "</tr>" _
                   & "<tr>" _
                    & "<td class=" & """" & "style1" & """" & " > " _
                    & "Tipo:</td>" _
                     & "<td>" _
                     & encabezado.Tipo _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Fecha Generación:</td>" _
                       & "<td>" _
                            & encabezado.FechaGeneracion _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Hora Generación:</td>" _
                       & "<td>" _
                            & encabezado.HoraGeneracion _
                & "&nbsp;</td> " _
                   & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Nombre Lote:</td>" _
                       & "<td>" _
                           & encabezado.NombreLote _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                   & "<td class=" & """" & "style1" & """" & " > " _
                & "Concepto Pago:</td>" _
                       & "<td>" _
                       & encabezado.ConceptoPago _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                         & "<td class=" & """" & "style1" & """" & " > " _
                & "Codigo BIC Entidad Debitada:</td>" _
                         & "<td>" _
                         & encabezado.CodBicEntidadDB _
                & "&nbsp;</td>" _
                     & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Codigo BIC Entidad Acreditada:</td>" _
                       & "<td>" _
                            & encabezado.CodBicEntidadCR _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Fecha Operación del Credito:</td>" _
                       & "<td>" _
                            & encabezado.FechaValorCRLBTR _
                & "&nbsp;</td>" _
                   & "</tr>" _
                   & "<tr>" _
                         & "<td class=" & """" & "style1" & """" & " > " _
                & "Registros (Control):</td>" _
                         & "<td>" _
                            & encabezado.TotalRegistroscontrol _
                & "&nbsp;</td>" _
                     & "</tr>" _
                   & "<tr>" _
                         & "<td class=" & """" & "style1" & """" & " > " _
                & "Total (Control):</td>" _
                         & "<td>" _
                            & String.Format("{0:N}", encabezado.TotalMontoControl) _
                & "&nbsp;</td>" _
                     & "</tr>" _
                   & "<tr>" _
                       & "<td class=" & """" & "style1" & """" & " > " _
                & "Moneda:</td> " _
                  & "<td>" _
                        & encabezado.Moneda _
                & "&nbsp;</td>" _
                   & "</tr>" _
               & "</table>" _
          & "<p>" _
        & "&nbsp;</p> " _
               & " <table style=" & """" & "font-family: Calibri; text-align :center; border-collapse: collapse;width: 100%;font-size:smaller;" & """> " _
                   & "<tr>" _
                      & "<td class=" & """" & "style2" & """" & ">" _
                & "Nombre Beneficiario</td>" _
                      & "<td class=" & """" & "style2" & """" & ">" _
                & "ID Beneficiario</td>" _
                      & "<td class=" & """" & "style2" & """" & ">" _
                & "Monto</td>" _
                      & "<td class=" & """" & "style2" & """" & ">" _
                & "Numero Cuenta Estandarizado</td>" _
                    & "<td class=" & """" & "style2" & """" & ">" _
                & "Tipo Cuenta</td>" _
                    & "<td class=" & """" & "style2" & """" & ">" _
                & "Concepto</td>" _
                    & "<td class=" & """" & "style2" & """" & ">" _
                & "Info. Adicional 1</td> " _
                    & "<td class=" & """" & "style2" & """" & ">" _
                & "Info. Adicional 2</td>" _
                    & "<td class=" & """" & "style2" & """" & ">" _
                & "Digitos Control</td>" _
                 & "</tr>"
        For Each elepago As XElement In querydetalle

            Dim Montodepositar As String = Convert.ToDecimal(elepago.Element("MONTOADEPOSITAR").Value)

            _body = _body & "<tr>" _
                       & "<td>" _
                             & elepago.Element("NOMBREBENEFICIARIO").Value _
                        & "&nbsp;</td>" _
                        & "<td>" _
                              & elepago.Element("IDENTIFICACIONBENEFICIARIO").Value _
                        & "&nbsp;</td>" _
                        & "<td>" _
                           & String.Format("{0:N}", Montodepositar) _
                        & "&nbsp;</td>" _
                        & "<td>" _
                            & elepago.Element("NUMEROCUENTAESTANDARD").Value _
                        & "&nbsp;</td>" _
                          & "<td>" _
                            & elepago.Element("TIPOCUENTA").Value _
                        & "&nbsp;</td>" _
                        & "<td>" _
                          & elepago.Element("CONCEPTODETALLADO").Value _
                        & "&nbsp;</td>" _
                          & "<td>" _
                           & elepago.Element("INFORMADICIONALPAGO01").Value _
                        & "&nbsp;</td>" _
                          & "<td>" _
                            & elepago.Element("INFORMADICIONALPAGO02").Value _
                            & "&nbsp;</td>" _
                          & "<td>" _
                             & Convert.ToInt32(elepago.Element("DIGITOSCONTROL").Value) _
                        & "&nbsp;</td>" _
                        & "</tr>"
        Next
        _body = _body & "</table>" _
           & "</body>" _
           & "</html>"

        Return _body

    End Function
    Protected Function BodyConcentracion() As String

        Dim _body As String = String.Empty

        Dim EntidadNombre As String = String.Empty
        Dim EnumDetalle As IEnumerable(Of String) = File.ReadAllLines(rutaachivoprocesado).Where(Function(p As String) _
                                                                                                        p.StartsWith("D"))

        getNombreEntidad(Convert.ToInt32(Enc.EntidadReceptora), EntidadNombre, resultado, Enc.NombreArchivo)

        If Not resultado.Equals("0") Then
            Set_Estatus_Error("ERAP", v_sec_log, Enc.NombreArchivo, 59, resultado)
            Throw New EncabezadoException(resultado)
        End If

        _body = "<!DOCTYPE html PUBLIC " & "-//W3C//DTD XHTML 1.0 Transitional//EN" & "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" & "> " _
         & "<html xmlns=" & """" & "http://www.w3.org/1999/xhtml" & """>" _
         & "<head> " _
         & "<title></title> " _
         & "<style type=" & """" & "text/css" & """" & ">" _
        & ".style1" _
        & "{" _
            & "width: 190px;" _
            & "font-weight: bold;" _
        & "}" _
        & ".style2" _
        & "{" _
            & "text-align: center;" _
            & "font-weight: bold;" _
        & "}" _
        & ".style3" _
        & "{" _
            & "width: 326px;" _
        & "}" _
        & ".style4" _
        & "{" _
             & "width: 681px;" _
            & "text-align: center;" _
            & "font-weight: bold;" _
            & "font-size:22px;" _
            & "font-family: Calibri;" _
        & "}" _
        & ".style5" _
        & "{" _
             & "width: 681px;" _
            & "text-align: center;" _
            & "font-weight: bold;" _
             & "font-size:18px;" _
             & "font-family: Calibri;" _
        & "}" _
      & "</style>" _
   & "</head>" _
  & "<body>" _
         & "<table style=" & """" & "width:100%;" & """>" _
               & "<tr>" _
                     & "<td class=" & """" & "style3" & """>" _
                           & "<img src= " & """" & "http://www.tss2.gov.do/images/logoTSShorizontal.gif" & """ />" _
                      & "<td class=" & """" & "style4" & """>" _
                   & "Tesorería de la Seguridad Social " & " <br /> Departamento de Operaciones & Tecnología" _
                 & "</td>" _
                     & "<td>" _
                     & "&nbsp;</td>" _
                 & "</tr>" _
           & "</table>" _
           & "<table style=" & """" & "width:100%;" & """>" _
             & "<tr>" _
                 & "<td class=" & """" & "style3" & """>" _
                     & "&nbsp;</td>" _
                 & "<td class=" & """" & "style5" & """>" _
                        & "Reporte Concentración de Aportes</td>" _
                 & "<td>" _
                     & "&nbsp;</td>" _
             & "</tr>" _
             & "</table>" _
             & "<br />" _
    & "<table style=" & """" & "font-family:Calibri; border-collapse: collapse;width: 100%;font-size:smaller;" & """>" _
        & "<tr>" _
            & "<td class=" & """" & "style1" & """" & " > " _
                & "Nombre del Archivo:</td>" _
            & "<td>" _
                & Enc.NombreArchivo _
        & "</tr>" _
        & "<tr>" _
            & "<td class=" & """" & "style1" & """" & " > " _
               & " Proceso:</td>" _
            & "<td>" _
            & Enc.Proceso _
            & "</td>" _
            & "</tr>" _
            & "<tr>" _
            & "<td class=" & """" & "style1" & """" & " > " _
                & "Sub_Proceso:</td>" _
            & "<td>" _
                & Enc.SubProceso & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Fecha Transación:</td>" _
                & "<td>" _
                & Enc.FechaTransmision & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Entidad Receptora:</td>" _
                & "<td>" _
                & EntidadNombre & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Nro. Lote:</td>" _
                & "<td>" _
                & Enc.NroLote & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "TotalRegistros :</td>" _
                & " <td>" _
                & Sumario.Numero_Registros & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Total a Liquidar Sin Ajuste:</td>" _
                & "<td>" _
                & String.Format("{0:N}", Sumario.Total_Liquidar_Ajuste) & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Monto Aclarado:</td>" _
                & "<td>" _
                & String.Format("{0:N}", Sumario.Monto_Aclarado) & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Total Ajuste:</td>" _
                & "<td>" _
                & String.Format("{0:N}", Sumario.Total_Ajuste) & "</td>" _
                & "</tr>" _
                & "<tr>" _
                & "<td class=" & """" & "style1" & """" & " > " _
                & "Total a Liquidar:</td>" _
                & "<td>" _
                & String.Format("{0:N}", Sumario.Total_Liquidar) & "</td>" _
                & "</tr>" _
                & "</table>" _
                & "<br />" _
                & " <table style=" & """" & "font-family: Calibri; text-align :center; border-collapse: collapse;width: 100%;font-size:smaller;" & """> " _
        & "<tr>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Fecha Solicitud</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Tipo Instrucción</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Importe Instrucción</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Cuenta Origen</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Cuenta Destino</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Entidad Origen</td>" _
            & "<td class=" & """" & "style2" & """" & ">" _
                & "Entidad Destino</td>"

        For Each detalle As String In EnumDetalle

            getDetalleValues(detalle, DetalleCon.FechaSolicutud, DetalleCon.Tipo_Instruccion, DetalleCon.Importe_Instruccion, DetalleCon.Cuenta_Origen, _
                                             DetalleCon.Cuenta_Destino, DetalleCon.Tipo_Entidad_Destino, DetalleCon.Entidad_Destino, _
                                             DetalleCon.Tipo_Entidad_Origen, DetalleCon.Entidad_Origen, resultado)

            Dim entidadOrigen As String = String.Empty
            Dim entidadDestino As String = String.Empty
            resultado = String.Empty
            Dim Instruccion As String = String.Empty
            Dim Monto_Instruccion As Decimal = DetalleCon.Importe_Instruccion '+ "." + DetalleCon.Importe_Instruccion.ToString.Substring(

            getNombreEntidad(Convert.ToInt32(DetalleCon.Entidad_Destino), entidadDestino, resultado, Enc.NombreArchivo)

            If Not resultado.Equals("0") Then
                Set_Estatus_Error("ERAP", v_sec_log, 59, resultado)
                Throw New DetalleException(resultado)
            End If

            getNombreEntidad(Convert.ToInt32(DetalleCon.Entidad_Origen), entidadOrigen, resultado, Enc.NombreArchivo)

            If Not resultado.Equals("0") Then
                Set_Estatus_Error("ERAP", v_sec_log, 59, resultado)
                Throw New DetalleException(resultado)
            End If

            Select Case DetalleCon.Tipo_Instruccion.Trim
                Case "1"
                    Instruccion = "Concentración Referencias Válidas"
                Case "2"
                    Instruccion = "Concentración Referencias Aclaradas"
                Case "5"
                    Instruccion = "Ajustes"
            End Select


            _body = _body & "<tr>" _
                       & "<td>" _
                             & DetalleCon.FechaSolicutud _
                        & "&nbsp;</td>" _
                        & "<td>" _
                              & Instruccion _
                        & "&nbsp;</td>" _
                        & "<td>" _
                           & String.Format("{0:N}", DetalleCon.Importe_Instruccion) _
                        & "&nbsp;</td>" _
                        & "<td>" _
                            & DetalleCon.Cuenta_Origen _
                        & "&nbsp;</td>" _
                          & "<td>" _
                            & DetalleCon.Cuenta_Destino _
                        & "&nbsp;</td>" _
                        & "<td>" _
                          & entidadOrigen _
                        & "&nbsp;</td>" _
                          & "<td>" _
                           & entidadDestino _
                         & "</tr>"
        Next
        _body = _body & "</table>" _
           & "</body>" _
           & "</html>"

        Return _body
    End Function
    Protected Friend Sub MoverArchivoError(ByVal result As String, ByVal Origen As String, ByVal Asunto As String)
        Try
            Dim archivoerror As String = fileinfo.Name
            Dim rutaachivoerror As String = Me.ArchivosConError & "\" & archivoerror

            If File.Exists(Origen) = False Then
                Dim fserror As FileStream = File.Create(Origen)
                fserror.Close()
            End If

            If File.Exists(rutaachivoerror) Then
                File.Delete(rutaachivoerror)
            End If

            '' Mover este archivo hacia la carpeta de Archivo con Error.
            File.Move(Origen, rutaachivoerror)

            EnviarConfirmacion(result, Asunto, TipoArchivo.ConError, rutaachivoerror)
        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, fileinfo.Name, 59, ex.Message)
            EnviarConfirmacion("Ha ocurrido el siguiente error Moviendo a la carpeta de error." + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Protected Sub getNombreEntidad(ByVal id_entidad As Int32, ByRef entidadnombre As String, ByRef result As String, ByVal nombrearchivo As String)
        Dim p_id_entidad As New OracleParameter With {.ParameterName = "p_id_entidad", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Int32, .Value = id_entidad}
        Dim p_entidadnombre As New OracleParameter With {.ParameterName = "p_entidadnombre", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}
        Dim p_result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}
        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.getNombreEntidad", p_id_entidad, p_entidadnombre, p_result)
            entidadnombre = Convert.ToString(p_entidadnombre.Value)
            result = Convert.ToString(p_result.Value)
        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
            EnviarConfirmacion("Ha ocurrido el siguiente error Obteniendo el Nombre de la entidad : " + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Protected Sub getDesProceso(ByVal TRN As String, ByRef proceso As String, ByRef result As String)

        Dim p_TRN As New OracleParameter With {.ParameterName = "p_trn", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = TRN}
        Dim p_Proceso As New OracleParameter With {.ParameterName = "p_desproceso", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}
        Dim p_result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}
        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.getDesProceso", p_TRN, p_Proceso, p_result)
            proceso = Convert.ToString(p_Proceso.Value)
            result = Convert.ToString(p_result.Value)
        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
            EnviarConfirmacion("Ha ocurrido el siguiente error Obteniendo la descripcion del proceso : " + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Public Sub getEntidadNombrePorBic(ByVal bic As String, ByRef entidadnombre As String, ByRef result As String)

        Dim p_Bic As New OracleParameter With {.ParameterName = "p_bic", .Direction = ParameterDirection.Input, .OracleDbType = OracleDbType.Varchar2, .Value = bic}
        Dim p_entidadnombre As New OracleParameter With {.ParameterName = "p_entidadnombre", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}
        Dim p_result As New OracleParameter With {.ParameterName = "p_result", .Direction = ParameterDirection.Output, .OracleDbType = OracleDbType.Varchar2, .Size = 200}

        Try
            OracleHelper.IntProcedure("BC_ManejoArchivoXML_PKG.getEntidadNombrePorBic", p_Bic, p_entidadnombre, p_result)
            entidadnombre = Convert.ToString(p_entidadnombre.Value)
            result = Convert.ToString(p_result.Value)
        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
            EnviarConfirmacion("Ha ocurrido el siguiente error Obteniendo el nombre de la entidad por el Bic: " + " " + ex.Message, "Archivo BCRD", TipoArchivo.Aplicacion, nombrearchivo)
        End Try
    End Sub
    Protected Sub MoverArchivoEnc(ByVal rutaorigen As String, ByVal rutadestino As String)
        Try
            If File.Exists(rutaorigen) = False Then
                Dim fsprocesado As FileStream = File.Create(rutaorigen)
                fsprocesado.Close()
            End If

            If File.Exists(rutadestino) Then
                File.Delete(rutadestino)
            End If

            '' Mover este archivo hacia la carpeta de Archivo procesado.
            File.Move(rutaorigen, rutadestino)

        Catch ex As Exception
            Set_Estatus_Error("ERAP", v_sec_log, nombrearchivo, 59, ex.Message)
            EnviarConfirmacion("Ocurrio el siguiente error" & "" & ex.Message & "" & "moviendo al directorio de ArchivosRecibodosEnc", "Error Moviendo Archivo", TipoArchivo.ConError, rutaorigen)
        End Try
    End Sub
#End Region
    
End Class
Public Enum TipoArchivo
    Procesados
    ConError
    NoExiste
    Aplicacion
    Zip
End Enum


