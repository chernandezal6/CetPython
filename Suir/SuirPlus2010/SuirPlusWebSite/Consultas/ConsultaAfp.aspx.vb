Imports System.Net
Imports System.Web.Services.Protocols.SoapHttpClientProtocol
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Imports System.Data
Imports SuirPlus
Imports System.Xml
Imports System.IO
Imports System.Globalization

Partial Class Consultas_ConsultaAfp
    Inherits BasePage

    Public Class CertificateOverride

        Public Function RemoteCertificateValidationCallback(ByVal sender As Object, ByVal certificate As X509Certificate, ByVal chain As X509Chain, ByVal sslPolicyErrors As SslPolicyErrors) As Boolean
            Return True
        End Function
    End Class

    Protected Sub sys_ConsultaAfiliado_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim oCertOverride As New CertificateOverride
        ServicePointManager.ServerCertificateValidationCallback = AddressOf oCertOverride.RemoteCertificateValidationCallback

    End Sub

    Protected Sub btBuscarRef_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

        Dim Res As String = String.Empty
        Dim Nombre As String = String.Empty
        Dim AFP As String = String.Empty
        Dim Status As String = String.Empty
        Dim tipo_afiliacion As String = String.Empty
        Dim Fecha_Afiliacion As String = String.Empty
        Dim Fecha_Solicitud As String = String.Empty

        Dim nucleo As New DataTable

        If Me.txtnodocumento.Text = String.Empty Then
                Me.lblError.Visible = True
                Me.lblError.Text = "La cédula es requerida"
                Exit Sub
            Else
                Me.lblError.Visible = False
                Me.lblError.Text = String.Empty
            End If

        Try

            Dim ws As New wsUnipago.Consulta_Afiliados_SDSS

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
            ws.Proxy = ProxyServer
            ws.UserAgent = "RobotTSS"

            Dim Usuario As String = infoWS.FTPUser
            Dim Pass As String = infoWS.FTPPass
            Dim data As Byte() = Convert.FromBase64String(Pass)
            Pass = System.Text.ASCIIEncoding.ASCII.GetString(data)

            Dim Resultado As String
            Resultado = ws.ConsultarAfiliacionSDSSporCedula(Me.txtnodocumento.Text, Usuario, Pass)

            Dim dataUrl As StringReader
            dataUrl = New StringReader(Resultado)
            Dim ds As DataSet = New DataSet
            ds.ReadXml(dataUrl)


            If ds.Tables.Count > 0 Then

                If Not IsNothing(ds.Tables("AfiliacionesAFP")) Then

                    'Encabezado Afiliacion AFP
                    Label4.Visible = False
                    lblFechaSolicitud.Visible = False
                    Label3.Visible = True
                    lblFechaAfiliacion.Visible = True
                    Label9.Visible = False
                    lblTipoSolicitud.Visible = False
                    Label2.Visible = True
                    lblTipoAfiliacion.Visible = True

                    lblAFP.Text = ds.Tables("AfiliacionAFP").Rows(0)("AFP").ToString()
                    lblNSS.Text = ds.Tables("AfiliacionAFP").Rows(0)("NSS").ToString()
                    lblNombre.Text = ds.Tables("AfiliacionAFP").Rows(0)("Nombre").ToString()
                    lblStatus.Text = ds.Tables("AfiliacionAFP").Rows(0)("Estatus").ToString()
                    'Para dar formato a la fecha dd/mm/yyyy
                    Dim strDate As String
                    Dim objdate As Date
                    strDate = ds.Tables("AfiliacionAFP").Rows(0)("FechaAfiliacion")
                    strDate = strDate.Substring(0, 2) & "/" & strDate.Substring(2, 2) & "/" & strDate.Substring(4, 4)
                    objdate = Date.Parse(strDate).ToShortDateString
                    lblFechaAfiliacion.Text = objdate
                    Dim tip As String
                    tip = ds.Tables("AfiliacionAFP").Rows(0)("TipoAfiliacion").ToString()
                    lblTipoAfiliacion.Text = tip.Split("=")(1)

                    pnlInfo.Visible = True
                    Me.lblError.Visible = False

                Else
                    If Not IsNothing(ds.Tables("SolicitudesAFP")) Then
                        'Encabezado Solicitudes AFP
                        Label3.Visible = False
                        lblFechaAfiliacion.Visible = False
                        Label4.Visible = True
                        lblFechaSolicitud.Visible = True
                        Label2.Visible = False
                        lblTipoAfiliacion.Visible = False
                        Label9.Visible = True
                        lblTipoSolicitud.Visible = True
                        lblAFP.Text = ds.Tables("SolicitudAFP").Rows(0)("AFP").ToString()
                        lblNSS.Text = ds.Tables("SolicitudAFP").Rows(0)("NSS").ToString()
                        lblNombre.Text = ds.Tables("SolicitudAFP").Rows(0)("Nombre").ToString()
                        lblStatus.Text = ds.Tables("SolicitudAFP").Rows(0)("Estatus").ToString()
                        'Para dar formato a la fecha dd/mm/yyyy
                        Dim strDate As String
                        Dim objdate As Date
                        strDate = ds.Tables("SolicitudAFP").Rows(0)("FechaSolicitud")
                        strDate = strDate.Substring(0, 2) & "/" & strDate.Substring(2, 2) & "/" & strDate.Substring(4, 4)
                        objdate = Date.Parse(strDate).ToShortDateString
                        lblFechaSolicitud.Text = objdate
                        Dim tip As String
                        tip = ds.Tables("SolicitudAFP").Rows(0)("Motivo").ToString()
                        lblTipoSolicitud.Text = tip.Split("=")(1)

                        pnlInfo.Visible = True
                        Me.lblError.Visible = False
                    End If
                End If

                If IsNothing(ds.Tables("AfiliacionAFP")) And IsNothing(ds.Tables("SolicitudAFP")) Then
                    Me.lblError.Visible = True
                    Me.lblError.Text = "No existe datos para este No.Documento"
                    pnlInfo.Visible = False
                    Exit Sub
                Else

                    Me.lblError.Visible = False
                    Me.lblError.Text = String.Empty
                    pnlInfo.Visible = True

                End If
            End If


        Catch ex As Exception

            SuirPlus.Exepciones.Log.LogToDB(ex.ToString)

            Me.lblError.Visible = True
            Me.lblError.Text = ex.ToString()
            Me.pnlInfo.Visible = False

        End Try

    End Sub

    Private Sub limpiar()

        Response.Redirect("ConsultaAfp.aspx")
    End Sub

    'Protected Function formateaNSS(ByVal NSS As String) As String
    '    Return Utilitarios.Utils.FormatearNSS(NSS.ToString)
    'End Function

    Protected Function formateaCedula(ByVal Cedula As String) As String

        If Cedula = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormatearCedula(Cedula)
        End If

    End Function

    Protected Function ValidarNull(ByVal texto As Object) As String

        If IsDBNull(texto) Then
            Return String.Empty
        Else
            Return CStr(texto)
        End If
        Return String.Empty
    End Function

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        limpiar()
    End Sub

    Protected Function formateaNSS(ByVal NSS As String) As String
        If NSS = "" Then
            NSS = String.Empty
        Else
            NSS = NSS.PadLeft(9, "0"c)

            If NSS.Length.Equals(9) Then
                NSS = NSS.Substring(0, 8) + "-" + NSS.Substring(8, 1)

            End If
        End If
        Return NSS
    End Function

End Class
