Imports System.Net
Imports System.Web.Services.Protocols.SoapHttpClientProtocol
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Imports System.Data
Imports SuirPlus
Imports System.Xml
Imports System.IO
Imports System.Globalization


Partial Class Externos_HistoricodeDescuentoAfp
    Inherits BasePage

    Protected empleado As SuirPlus.Empresas.Trabajador
    Protected idciudadano As String
    Protected empleador As String
    Protected ano As String


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Dim oCertOverride As New CertificateOverride
            ServicePointManager.ServerCertificateValidationCallback = AddressOf oCertOverride.RemoteCertificateValidationCallback

            Me.pnlConsulta.Visible = False
            CargarInfoAFP("00201532900")
        End If

    End Sub

    Private Sub btnConsultar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        idciudadano = txtCedulaNSS.Text

        Try

            If idciudadano.Length = 9 Then
                empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idciudadano))
            ElseIf idciudadano.Length = 11 Then
                empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idciudadano)
            End If

        Catch ex As Exception

            Me.lblMsg.Text = ex.Message
            Me.pnlConsulta.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        If empleado Is Nothing Then
            Me.lblMsg.Text = SuirPlus.Utilitarios.TSS.getErrorDescripcion(24)
            Exit Sub
        End If

        Me.pnlConsulta.Visible = True

        Me.lblEmpleado.Text = empleado.Nombres + " " + empleado.PrimerApellido + " " + empleado.SegundoApellido
        Me.lblNSS.Text = SuirPlus.Utilitarios.Utils.FormatearNSS(empleado.NSS.ToString)
        Me.lblCedula.Text = SuirPlus.Utilitarios.Utils.FormatearCedula(empleado.Documento)
        Me.lblFechaNacimiento.Text = String.Format("{0:d}", empleado.FechaNacimiento.Date.ToShortDateString)

        empleador = Me.txtEmpleador.Text
        ano = Me.txtAno.Text

        'Grabamos las variables en viewstate
        ViewState("empleador") = empleador
        ViewState("ano") = ano
        ViewState("trabajador") = idciudadano

        llenarDatagrid(empleador, ano)

    End Sub

    Private Sub llenarDatagrid(ByVal rncEmpleador As String, ByVal ano As String)

        Dim dt As New Data.DataTable
        dt = empleado.getAportes(rncEmpleador, ano)

        If dt.Rows.Count > 0 Then
            Me.gvHistorico.DataSource = dt
            Me.gvHistorico.DataBind()
            Me.lblMsg.Text = ""
        Else
            Me.pnlConsulta.Visible = False
            Me.lblMsg.Text = "No existen registros para este año"
        End If

    End Sub


    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles Ucexportarexcel.ExportaExcel

        empleador = CType(ViewState("empleador"), String)
        ano = ViewState("ano").ToString
        idciudadano = CType(ViewState("trabajador"), String)

        If idciudadano.Length = 9 Then
            empleado = New SuirPlus.Empresas.Trabajador(Convert.ToInt32(idciudadano))
        ElseIf idciudadano.Length = 11 Then
            empleado = New SuirPlus.Empresas.Trabajador(SuirPlus.Empresas.Trabajador.TrabajadorDocumentoType.Cedula, idciudadano)
        End If

        Ucexportarexcel.FileName = "Descuento_Empleado_" & empleado.Nombres
        Ucexportarexcel.DataSource = empleado.getAportes(empleador, ano)

    End Sub

    Protected Sub gvHistorico_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHistorico.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(1).Text = SuirPlus.Utilitarios.Utils.FormateaPeriodo(e.Row.Cells(1).Text)
            e.Row.Cells(2).Text = SuirPlus.Utilitarios.Utils.FormateaPeriodo(e.Row.Cells(2).Text)
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("HistoricodeDescuentoAfp.aspx")
    End Sub


    'Sub ProcederConsulta()
    '    If SuirPlus.Seguridad.Autorizacion.isInRol(UsrUserName, "318") = True Then
    '        Me.pnlConsulta.Visible = True
    '    Else
    '        Me.pnlConsulta.Visible = False
    '        Deshabilitar()
    '        lblMsg.Text = "Este usuario no tiene permisos para ver esta Consultas,Favor contactar a la TSS"

    '    End If
    'End Sub

    Sub Deshabilitar()
        txtCedulaNSS.Enabled = False
        txtEmpleador.Enabled = False
        txtAno.Enabled = False
        btnConsultar.Enabled = False
        btnLimpiar.Enabled = False

    End Sub

    Sub CargarInfoAFP(Documento As String)
        Dim Res As String = String.Empty
        Dim Nombre As String = String.Empty
        Dim AFP As String = String.Empty
        Dim Status As String = String.Empty
        Dim tipo_afiliacion As String = String.Empty
        Dim Fecha_Afiliacion As String = String.Empty
        Dim Fecha_Solicitud As String = String.Empty

        Dim nucleo As New DataTable

        Dim ws As New wsUnipago.Consulta_Afiliados_SDSS

        Dim prxInternet As New SuirPlus.Config.Configuracion(Config.ModuloEnum.ProxyInternet)
        Dim infoWS As New SuirPlus.Config.Configuracion(Config.ModuloEnum.WS_SDSS)

        '        WebRequest.GetSystemWebProxy().Credentials .

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
        ws.Proxy = ProxyServer


        Dim Usuario As String = infoWS.FTPUser
        Dim Pass As String = infoWS.FTPPass
        Dim data As Byte() = Convert.FromBase64String(Pass)
        Pass = System.Text.ASCIIEncoding.ASCII.GetString(data)

        Dim Resultado As String
        Resultado = ws.ConsultarAfiliacionAFPporCedula(Documento, Usuario, Pass)


        Dim dataUrl As StringReader
        dataUrl = New StringReader(Resultado)
        Dim ds As DataSet = New DataSet
        ds.ReadXml(dataUrl)


        If ds.Tables.Count > 0 Then
            If Not IsNothing(ds.Tables("AfiliacionesAFP")) Then

            End If
        End If


    End Sub

    Public Class CertificateOverride

        Public Function RemoteCertificateValidationCallback(ByVal sender As Object, ByVal certificate As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As SslPolicyErrors) As Boolean
            Return True
        End Function
    End Class

End Class

