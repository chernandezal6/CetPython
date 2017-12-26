Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class info
    Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    <WebMethod(Description:="Metodo para consultar ciudadanos. <br><br>" & _
 "Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
 "<br><br> Los Errores que devuelve son: <br> " & _
 "a) <b>10</b>|Error en el Usuario o Password <br>" & _
 "b) <b>28</b>|Cédula Inhabilitada, Razón:  MOTIVO<br>" & _
 "c) <b>29</b>|Cédula Cancelada, Razón: MOTIVO<br>" & _
 "d) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function ConsultaCiudadanos(ByVal UserName As String, ByVal Password As String, ByVal nodocumento As String, ByVal idnss As String,
            ByVal nombres As String, ByVal primerapellido As String, ByVal segundoapellido As String) As DataSet
        Dim ds As New DataSet("ConsultaCiudadanos")
        Try

            Dim msgABC As String = ""

            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)


                Return ds

            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If


            If String.IsNullOrEmpty(nodocumento) AndAlso String.IsNullOrEmpty(idnss) AndAlso String.IsNullOrEmpty(nombres) _
           AndAlso String.IsNullOrEmpty(primerapellido) AndAlso String.IsNullOrEmpty(segundoapellido) Then

                Seg.AgregarMensajeDeError(ds, Err.Criterio)

                Return ds

            End If


            'si la busqueda se está realizando por Nro. de Documento verificamos si está cancelada.
            If Not String.IsNullOrEmpty(nodocumento) Then
                Dim tmpDt As DataTable = Utilitarios.TSS.CedulaCancelada(nodocumento)
                If tmpDt.Rows.Count > 0 Then
                    If tmpDt.Rows(0)("tipo_causa").ToString() <> "H" Then
                        Select Case tmpDt.Rows(0)("tipo_causa").ToString()
                            Case "I"
                                Seg.AgregarMensajeDeError(ds, Err.CedulaInhabilitada & tmpDt.Rows(0)("cancelacion_des").ToString())

                            Case "C"
                                Seg.AgregarMensajeDeError(ds, Err.CedulaCancelada & tmpDt.Rows(0)("cancelacion_des").ToString())

                        End Select

                        Return ds

                    End If
                End If
            End If

            If Trim(idnss.Length) <> 9 Then
                idnss.Trim.PadLeft(9, "0")
            End If


            ds.Tables.Add(Utilitarios.Info.ConsultaCiudadanos(nodocumento, idnss, nombres, primerapellido, segundoapellido).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar el historico de descuento. <br><br>" & _
"Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
"<br><br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password <br>" & _
"b) <b>26</b>|NSS Inválido<br>" & _
 "c) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function HistoricoDescuento(ByVal UserName As String, ByVal Password As String, ByVal nodocumento As String, ByVal rncEmpleador As String,
            ByVal ano As String) As DataSet
        Dim ds As New DataSet("HistoricoDescuento")
        Try

            Dim msgABC As String = ""
            Dim empleado As Empresas.Trabajador = Nothing


            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds
            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If

            If nodocumento.Length = 9 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(nodocumento))
            ElseIf nodocumento.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, nodocumento)
            End If

            If IsNothing(empleado) Then
                Seg.AgregarMensajeDeError(ds, Err.NSSinvalido)

                Return ds
            End If

            ds.Tables.Add(Utilitarios.Info.HistoricoDescuento(empleado.NSS, rncEmpleador, ano).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar la afiliacion al ARL de un ciudadano. <br><br>" & _
"Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
"<br><br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password <br>" & _
"b) <b>26</b>|NSS Inválido<br>" & _
 "c) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function AfiliadoARL(ByVal UserName As String, ByVal Password As String, ByVal nodocumento As String) As DataSet
        Dim ds As New DataSet("AfiliadoARL")
        Try

            Dim msgABC As String = ""
            Dim empleado As Empresas.Trabajador = Nothing


            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds
            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If

            If nodocumento.Length = 9 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(nodocumento))
            ElseIf nodocumento.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, nodocumento)
            End If

            If IsNothing(empleado) Then
                Seg.AgregarMensajeDeError(ds, Err.NSSinvalido)

                Return ds
            End If

            ds.Tables.Add(Utilitarios.Info.AfiliadoARL(empleado.NSS).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar las ARS por periodo de un ciudadano. <br><br>" & _
"Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
"<br><br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password <br>" & _
"b) <b>26</b>|NSS Inválido<br>" & _
 "c) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function ARSPorPeriodo(ByVal UserName As String, ByVal Password As String, ByVal nodocumento As String, ByVal nss As String) As DataSet
        Dim ds As New DataSet("ARSPorPeriodo")
        Try

            Dim msgABC As String = ""
            Dim empleado As Empresas.Trabajador = Nothing


            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds
            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If


            ds.Tables.Add(Utilitarios.Info.ARSPorPeriodo(nodocumento, nss).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar subsidios del SFS. <br><br>" & _
    "Esta función devuelve un DataSet con los resultados de la busqueda<br>" & _
    "Listado de Estatus : <br>" & _
    "1	Pendiente de aprobación<br>" & _
    "2	Aprobado<br>" & _
    "3	Rechazado<br>" & _
    "4	Completado<br>" & _
    "5	Cancelado<br>" & _
    "6	Pendiente de envío<br>" & _
    "7	En proceso de evaluación visual<br>" & _
    "8	En unidad de verificación médica<br>" & _
    "9	Incompleto<br>" & _
    "10	En proceso<br>" & _
    "11	Activo<br>" & _
    "12	Inactivo<br>" & _
    "13	Fallecida<br><br>" & _
    "Listado de Tipo : <br>" & _
    "M Maternidad<br>" & _
    "E Enfermedad Común<br>" & _
    "L Lactancia<br><br>" & _
   "En caso de que haya un error se devuelve el codigo mas la descripción." & _
"<br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password <br>" & _
"b) <b>28</b>|Cédula Inhabilitada, Razón:  MOTIVO<br>" & _
"c) <b>29</b>|Cédula Cancelada, Razón: MOTIVO<br>" & _
 "d) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function ConsultaSFS(ByVal UserName As String, ByVal Password As String, ByVal rnccedula As String, ByVal cedula As String,
            ByVal estatus As String, ByVal tipo As String, ByVal fechainicial As String, ByVal fechafinal As String) As DataSet
        Dim ds As New DataSet("ConsultaSFS")
        Try

            Dim msgABC As String = ""

            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds

            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If


            If String.IsNullOrEmpty(rnccedula) AndAlso String.IsNullOrEmpty(cedula) AndAlso String.IsNullOrEmpty(estatus) _
           AndAlso String.IsNullOrEmpty(tipo) AndAlso String.IsNullOrEmpty(fechainicial) AndAlso String.IsNullOrEmpty(fechafinal) Then

                Seg.AgregarMensajeDeError(ds, Err.Criterio)

                Return ds

            End If

            ds.Tables.Add(Utilitarios.Info.ConsultaSFS(rnccedula, cedula, estatus, tipo, fechainicial, fechafinal).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar el detalle de subsidios del SFS. <br><br>" & _
    "Esta función devuelve un DataSet con los resultados de la busqueda<br>" & _
    "En caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>28</b>|Cédula Inhabilitada, Razón:  MOTIVO<br>" & _
    "c) <b>29</b>|Cédula Cancelada, Razón: MOTIVO<br>" & _
     "d) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function DetalleSFS(ByVal UserName As String, ByVal Password As String, ByVal registropatronal As Integer, ByVal nrosolicitud As Integer,
            ByVal tipo As String) As DataSet
        Dim ds As New DataSet("DetalleSFS")
        Try

            Dim msgABC As String = ""

            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds

            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If


            ds.Tables.Add(Utilitarios.Info.DetalleSFS(registropatronal, nrosolicitud, tipo).Copy())


            Dim dtCuotas As Data.DataTable
            Dim regPat As String = String.Empty



            If tipo <> "L" Then
                regPat = registropatronal
            End If

            dtCuotas = Empresas.SubsidiosSFS.Consultas.getCuotasSubsidios(nrosolicitud, regPat, tipo)
            dtCuotas.TableName = "DetalleCuota"

            ds.Tables.Add(dtCuotas.Copy())


        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para consultar los empleadores. <br><br>" & _
"Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
"<br><br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password <br>" & _
"b) <b>26</b>|NSS Inválido<br>" & _
 "c) <b>30</b>|Usuario no autorizado<br>")> _
    Public Function ConsultaEmpleador(ByVal UserName As String, ByVal Password As String, ByVal registroPatronal As String,
                                      ByVal rncCedula As String, ByVal nombreComercial As String, ByVal razonSocial As String,
                                      ByVal telefono As String) As DataSet
        Dim ds As New DataSet("ConsultaEmpleador")
        Try

            Dim msgABC As String = ""


            'Verificar Usuario & Password
            If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

                Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

                Return ds
            Else
                If Not Seg.isInRole(UserName, "599") Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)

                    Return ds
                End If
            End If


            If String.IsNullOrEmpty(rncCedula) AndAlso String.IsNullOrEmpty(nombreComercial) AndAlso String.IsNullOrEmpty(nombreComercial) _
         AndAlso String.IsNullOrEmpty(razonSocial) AndAlso String.IsNullOrEmpty(telefono) AndAlso String.IsNullOrEmpty(registroPatronal) Then

                Seg.AgregarMensajeDeError(ds, Err.Criterio)

                Return ds

            End If


            If String.IsNullOrEmpty(registroPatronal) Then
                registroPatronal = 0
            End If


            ds.Tables.Add(Utilitarios.Info.ConsultaEmpleador(registroPatronal, rncCedula, nombreComercial, razonSocial, telefono).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.Message)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Metodo para la DIDA consultar a la Junta Central Electoral(JCE). <br><br>" & _
    "Esta función devuelve un DataSet con los resultados de la busqueda, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password. <br>" & _
    "b) <b>30</b>|Usuario no autorizado. <br>" & _
    "c) <b>61</b>|Cedula Invalida. <br>" & _
    "d) <b>63</b>|Error consultando servicio JCE. <br>" & _
    "e) <b>64</b>|Registro consultado existe, eviado a evaluación visual. <br>" & _
    "f) <b>65</b>|Registro en proceso de evaluación visual. <br>")> _
    Public Function ConsultaJCE(ByVal UserName As String, ByVal Password As String, ByVal nodocumento As String) As DataSet
        Dim ds As New DataSet("ConsultaJCE")
        Try

            Dim msgABC As String = ""
            If String.IsNullOrEmpty(nodocumento) Then
                Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                Return ds
            End If
            If nodocumento.Length <> 11 Then
                Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                Return ds
            Else
                'Verificar Usuario & Password
                If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then
                    Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
                    Return ds
                Else
                    If Not Seg.isInRole(UserName, "599") Then
                        Seg.AgregarMensajeDeError(ds, Err.UsuarionAutorizado)
                        Return ds
                    End If
                End If

                'Como la busqueda se está realizando por Nro. de Documento verificamos en la JCE.
                If Not String.IsNullOrEmpty(nodocumento) Then
                    ds.Tables.Add(Utilitarios.TSS.getCiudadanosTSS_JCE(nodocumento, UserName).Copy())
                End If
            End If



        Catch ex As Exception
            If ex.Message = "J04" Then
                Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
            ElseIf ex.Message = "J05" Then
                Seg.AgregarMensajeDeError(ds, Err.ServicioJCEErr)
            ElseIf ex.Message = "J06" Then
                Seg.AgregarMensajeDeError(ds, Err.CedulaEnviadaEV)
            ElseIf ex.Message = "J07" Then
                Seg.AgregarMensajeDeError(ds, Err.CedulaEnProcesoEV)
            Else
                Seg.AgregarMensajeDeError(ds, ex.Message)
            End If

        End Try

        Return ds

    End Function

End Class