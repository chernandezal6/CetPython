Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports SuirPlus
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.tool.xml
Imports iTextSharp.text.pdf
Imports SuirPlus.Empresas
Imports System.Data
Imports System.Net

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")>
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Public Class certificaciones
    Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    <WebMethod(Description:="Metodo para crear las certificaciones que provee la TSS. <br><br>" &
     "Esta función devuelve un String con el Numero de Certificacion." &
     "<br><br> Tipos de Certificaciones: <br> " &
    "1:  EstatusPagoDetalle <br>" &
    "2:  AporteEmpleadoPorEmpleador <br>" &
    "3:  AportePersonal <br>" &
    "4:  NoOperaciones <br>" &
    "5:  BalanceAlDia <br>" &
    "6:  BalanceAlDiaCon3FacturasOMenosPagadas <br>" &
    "7:  RegistroPersonaFisicaSinNomina <br>" &
    "8:  RegistroEmpleadorSinNomina <br>" &
    "9:  IngresoTardio <br>" &
    "10: Discapidad <br>" &
    "A:  CiudadanoSinAporte <br>" &
    "B:  UltimoAporteCiudadano <br>" &
    "C:  ReporteNoPagosEmpleadoAlEmpleador <br>" &
    "12: AcuerdoPagoCuotasRequeridas <br>" &
    "13: Deuda  <br>" &
    "14: BalanceAlDiaConNPDeAuditoriaVE <br>" &
    "15: RegistroIndustriaComercio <br>" &
    "<br><br> En caso de que haya un error se devuelve el código más la descripción.<br>" &
    "a) <b>10</b>|Error en el Usuario o Password <br>" &
    "b) <b>66</b>|RNC inválido <br>" &
    "b) <b>30</b>|Usuario no autorizado. <br>" &
     "")>
    Public Function CrearCertificacion(ByVal UserName As String, ByVal Password As String,
                                       ByVal RNC As String, ByVal Cedula As String, ByVal FechaDesde As String,
                                       ByVal FechaHasta As String, ByVal TipoCertificacion As String) As String
        Dim ds As New Data.DataSet
        Try
            Dim myCert As Empresas.Certificaciones
            Dim msg As String = String.Empty

            If Seg.CheckUserPass(UserName, Password, IP) = False Then
                Return Err.UsuarioPass

            Else
                If Not Seg.isInRole(UserName, "619") Then
                    Return Err.UsuarionAutorizado
                End If
            End If

            ' Verificar si el RNC existe
            Try
                Dim emp = Utilitarios.TSS.getRegistroPatronalActivo(RNC)
                If emp = String.Empty Or Not IsNumeric(emp) Then
                    Return Err.RNCoCedulaInvalida
                End If
            Catch ex As Exception
                Return ex.ToString()
            End Try

            'validamos el tipo de certificación

            Dim tipoCertActivo = Empresas.Certificaciones.getTipoCertificacionActiva(TipoCertificacion)

            If tipoCertActivo <> 1 Then
                Return "Tipo de certificación inválida."
            End If
            'If String.IsNullOrEmpty(TipoCertificacion) Then
            '    Return "Tipo de certificación es requerido."
            'Else
            '    If IsNumeric(TipoCertificacion) Then
            '        If (CInt(TipoCertificacion) > 0 And CInt(TipoCertificacion) <= 15) Then
            '            If (CInt(TipoCertificacion) = 11) Then
            '                Return "Tipo de certificación inválida."
            '            End If
            '        Else
            '            Return "Tipo de certificación inválida."
            '        End If
            '    Else
            '        If TipoCertificacion <> "A" And TipoCertificacion <> "B" And TipoCertificacion <> "C" Then
            '            Return "Tipo de certificación inválida."
            '        End If
            '    End If
            'End If

            Dim tipoCert As SuirPlus.Empresas.Certificaciones.CertificacionType = SuirPlus.Empresas.Certificaciones.setTipoCertificacion(TipoCertificacion)

            'If Not Seg.isInPermiso(UserName, GetPermiso(tipoCert)) Then
            '    Return Err.UsuarionAutorizado
            'End If

            myCert = New SuirPlus.Empresas.Certificaciones(tipoCert)

            'Para el unico caso que pasamos la cedula como un RNC
            If tipoCert = SuirPlus.Empresas.Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina Then
                myCert.RNC = Trim(Cedula).PadLeft(11)
            Else
                myCert.Cedula = Trim(Cedula).PadLeft(11)
                myCert.RNC = Trim(RNC).PadLeft(11)
            End If

            'Asignando las fechas
            If Not String.IsNullOrEmpty(FechaDesde) Then myCert.FechaDesde = FechaDesde
            If Not String.IsNullOrEmpty(FechaHasta) Then myCert.FechaHasta = FechaHasta

            'Validaciones de campos requeridos
            Select Case tipoCert
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.AporteEmpleadoPorEmpleador
                    If Cedula = "" Or RNC = "" Then
                        Return "El RNC y la cédula del empleado son requerido."
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.AportePersonal
                    If Cedula.Trim() = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        'Veriricamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.BalanceAlDia
                    If RNC = "" Then
                        Return "El rnc del empleador es requerido para realizar esta certificación."
                    Else
                        'Si el rnc es una cedula verificamos que sea valido.
                        If RNC.Length = 11 Then
                            If Not myCert.esEmpleador(msg) Then
                                Return msg
                            End If
                        End If
                    End If

                    Dim emp As New Empleador(RNC)

                    If emp.StatusCobro <> StatusCobrosType.Normal Then
                        'Validando si tiene acuerdo de pago
                        If myCert.tieneEmpleadorAcuerdodePago = True Then
                            'Validamos si el acuerdo de pago no esta vencido.
                            If myCert.IsAcuerdoVencido = True Then
                                Return "El acuerdo de pago de este empleador está en estatus vencido, no puede realizarle esta certificación."
                            End If
                        Else
                            Return "Este empleador no cumple con los requisitos para realizarle esta certificación."

                        End If
                    Else
                        Dim FactVencidas = myCert.getFactVencidas()
                        If FactVencidas.Rows.Count > 0 Then
                            Return "Este empleador no cumple con los requisitos para realizarle esta certificación."
                        End If


                    End If

                        Case SuirPlus.Empresas.Certificaciones.CertificacionType.NoOperaciones
                    Try

                        If RNC = "" Then
                            Return "El rnc del empleador es requerido para realizar esta certificación."
                        ElseIf String.IsNullOrEmpty(FechaDesde) Then
                            Return "La fecha desde, debe ser especificada."
                        ElseIf String.IsNullOrEmpty(FechaHasta) Then
                            Return "La fecha hasta, debe ser especificada."
                        ElseIf CDate(FechaHasta) < CDate(FechaDesde) Then
                            Return "La fecha hasta, debe ser mayor que la fecha desde."
                        ElseIf CDate(FechaDesde) > CDate(FechaHasta) Then
                            Return "La fecha desde, debe ser menor que la fecha hasta."
                        Else
                            If Not myCert.esEmpleador(msg) Then
                                Return msg
                            End If
                        End If
                    Catch ex As Exception
                        Return ex.ToString
                    End Try
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas
                    If RNC = "" Then
                        Return "El rnc del empleador es requerido para realizar esta certificación."
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina
                    If Cedula = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.RegistroEmpleadorSinNomina
                    If RNC = "" Then
                        Return "El rnc del empleador es requerido para realizar esta certificación."
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.CiudadanoSinAporte
                    If Cedula = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.UltimoAporteCiudadano
                    If Cedula = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.ReporteNoPagosEmpleadoAlEmpleador
                    If Cedula = "" Or RNC = "" Then
                        Return "El RNC y la cédula del empleado son requerido."
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If

                        'Validamos que el empleador no haya hecho aporte.
                        If myCert.tieneAporteEmpleador Then
                            myCert.CargarDatos()
                            Return "** El empleador: " & myCert.RazonSocial & " ha realizado aportes al trabajador: " & myCert.Nombre
                        End If
                    End If

                    'Validamos que sea un ciudadano valido
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.IngresoTardio
                    If Cedula = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                    End If

                    'Validamos que sea un ciudadano valido
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.Discapidad
                    If Cedula = "" Then
                        Return "La cédula es requerida para realizar esta certificación"
                    Else
                        If Not myCert.esCiudadano(msg) Then
                            Return msg
                        End If
                    End If
                    'Validando el AcuerdoPagoCuotasRequeridas
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.AcuerdoPagoCuotasRequeridas
                    If RNC = "" Then
                        Return "El rnc del empleador es requerido para realizar esta certificación."
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If

                    'Validando si tiene acuerdo de pago
                    If myCert.tieneEmpleadorAcuerdodePago = False Then
                        Return "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                    End If

                    'Validando si tiene cuotas vencidas
                    If myCert.IsAcuerdoVencido = True Then
                        Return "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                    End If
                Case SuirPlus.Empresas.Certificaciones.CertificacionType.RegistroIndustriaComercio
                    If RNC = "" Then
                        Return "El rnc del empleador es requerido para realizar esta certificación."
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Return msg
                        End If
                    End If
            End Select

            myCert.CargarDatos()
            myCert.Crear(UserName.ToUpper())

            myCert = New SuirPlus.Empresas.Certificaciones(myCert.Numero)
            Return myCert.NoCertificacion
        Catch ex As Exception
            Return ex.Message.ToString()
        End Try

        Return String.Empty

    End Function

    Private Function GetPermiso(ByVal tipo As SuirPlus.Empresas.Certificaciones.CertificacionType) As Integer
        If tipo = Empresas.Certificaciones.CertificacionType.EstatusPagoDetalle Then
            Return 388
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.AporteEmpleadoPorEmpleador Then
            Return 389
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.AportePersonal Then
            Return 390
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.NoOperaciones Then
            Return 391
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.BalanceAlDia Then
            Return 392
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas Then
            Return 393
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina Then
            Return 394
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.RegistroEmpleadorSinNomina Then
            Return 395
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.IngresoTardio Then
            Return 396
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.Discapidad Then
            Return 397
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.CiudadanoSinAporte Then
            Return 403
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.UltimoAporteCiudadano Then
            Return 407
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.ReporteNoPagosEmpleadoAlEmpleador Then
            Return 408
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.AcuerdoPagoCuotasRequeridas Then
            Return 399
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.Deuda Then
            Return 400
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.BalanceAlDiaConNPDeAuditoriaVE Then
            Return 0
        ElseIf tipo = Empresas.Certificaciones.CertificacionType.RegistroIndustriaComercio Then
            Return 402
        End If

        Return 0
    End Function


    <WebMethod(Description:="Metodo que retorna un dataset con el detalle de una certificacion. <br><br>" &
   "Esta función devuelve un dataset, en caso de que haya un error se devuelve el codigo mas la descripción." &
   "<br><br> Los Errores que devuelve son: <br> " &
   "a) <b>10</b>|Error en el Usuario o Password <br>" &
   "")>
    Public Function ConsultaCertificacion(ByVal UserName As String, ByVal Password As String, ByVal NoCertificacion As String) As DataSet
        Dim ds As New Data.DataSet
        Try
            Dim myCert As Empresas.Certificaciones
            If Seg.CheckUserPass(UserName, Password, IP) = False Then
                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds
            Else
                If Not Seg.isInRole(UserName, "619") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If

            If String.IsNullOrEmpty(NoCertificacion) Then
                Seg.AgregarMensajeDeError(ds, "No Certificacion es requerido.")

                Return ds
            End If


            myCert = New Empresas.Certificaciones(NoCertificacion)

            Dim dt As New Data.DataTable("Encabezado")

            Dim Codigo As New Data.DataColumn("Codigo")
            Dim RNCColumn As New Data.DataColumn("RNC")
            Dim RazonSocial As New Data.DataColumn("RazonSocial")
            Dim FechaEmision As New Data.DataColumn("FechaEmision")
            Dim Vigencia As New Data.DataColumn("Vigencia")

            dt.Columns.Add(Codigo)
            dt.Columns.Add(RNCColumn)
            dt.Columns.Add(RazonSocial)
            dt.Columns.Add(FechaEmision)
            dt.Columns.Add(Vigencia)

            Dim row As Data.DataRow = dt.NewRow()

            row("Codigo") = myCert.NoCertificacion
            row("RNC") = myCert.RNC
            row("RazonSocial") = myCert.RazonSocial
            row("FechaEmision") = myCert.FechaCreacion
            row("Vigencia") = "90"

            dt.Rows.Add(row)

            ds.Tables.Add(dt)


            If Not IsNothing(myCert.Detalle) Then
                ds.Tables.Add(myCert.Detalle.Tables(0).Copy())
            End If

            Return ds


        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)

            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo que retorna un pdf de acuerdo a no de certificacion. <br><br>" &
     "Esta función devuelve un stream pdf, en caso de que haya un error se devuelve el codigo mas la descripción." &
     "<br><br> Los Errores que devuelve son: <br> " &
     "a) <b>10</b>|Error en el Usuario o Password <br>" &
     "")>
    Public Function ConsultaPDF(ByVal UserName As String, ByVal Password As String, ByVal NoCertificacion As String) As String

        Try

            Dim myCert As Empresas.Certificaciones
            If Seg.CheckUserPass(UserName, Password, IP) = False Then
                Return Err.UsuarioPass

            Else
                If Not Seg.isInRole(UserName, "619") Then
                    Return Err.UsuarionAutorizado

                End If
            End If

            If String.IsNullOrEmpty(NoCertificacion) Then
                Return "No Certificacion es requerido."

            End If

            myCert = New Empresas.Certificaciones(NoCertificacion)

            Dim codigo = Convert.ToBase64String(Encoding.ASCII.GetBytes(myCert.Numero))

            Dim prxInternet As New SuirPlus.Config.Configuracion(Config.ModuloEnum.ProxyInternet)
            Dim infoWS As New SuirPlus.Config.Configuracion(Config.ModuloEnum.WS_SDSS)

            Dim ProxyUser As String = prxInternet.FTPUser
            Dim ProxyIP As String = prxInternet.FTPHost
            Dim ProxyDomain As String = prxInternet.FTPDir
            Dim ProxyPort As String = prxInternet.FTPPort
            Dim ProxyPass As String = prxInternet.FTPPass
            Dim dataPass As Byte() = Convert.FromBase64String(ProxyPass)
            ProxyPass = System.Text.ASCIIEncoding.ASCII.GetString(dataPass)

            Dim Autenticacion As New NetworkCredential(ProxyUser, ProxyPass, ProxyDomain) 'poner usuario y password de la red

            Dim ProxyServer As New WebProxy(ProxyIP, Convert.ToInt32(ProxyPort))
            ProxyServer.Credentials = Autenticacion

            Dim webRequest As WebRequest
            Dim webresponse As WebResponse

            Dim certconfig As New SuirPlus.Config.Configuracion(Config.ModuloEnum.Certificaciones)
            Dim urlCertificacion = certconfig.Other1_DIR.ToString()
            'desde srp_config_t
            webRequest = WebRequest.Create(urlCertificacion & "/sys/ImpCertificacion.aspx?B=GtIFyg&A=" & codigo)
            'para produccion
            'webRequest = webRequest.Create("http://172.16.5.79/sys/ImpCertificacion.aspx?B=GtIFyg&A=" & codigo)

            'para desarrollo
            'webRequest = webRequest.Create("http://localhost:30991/sys/ImpCertificacion.aspx?B=GtIFyg&A=" & codigo)

            webRequest.Proxy = ProxyServer
            webresponse = webRequest.GetResponse()
            Dim b(1024) As Byte
            Using stream = webresponse.GetResponseStream()
                Using ms As New MemoryStream
                    Dim count As Integer = 0

                    Do
                        Dim buf(1024) As Byte

                        count = stream.Read(buf, 0, 1024)
                        ms.Write(buf, 0, count)

                    Loop While stream.CanRead And count > 0
                    b = ms.ToArray()

                End Using

            End Using

            HttpContext.Current.Response.BinaryWrite(b)

            HttpContext.Current.Response.[End]()

            Return String.Empty

        Catch ex As Exception
            Return ex.Message
        End Try

        Return String.Empty

    End Function

End Class