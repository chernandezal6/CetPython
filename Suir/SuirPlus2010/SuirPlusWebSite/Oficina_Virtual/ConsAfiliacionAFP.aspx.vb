Imports System.Net
Imports System.Web.Services.Protocols.SoapHttpClientProtocol
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Imports System.Data
Imports SuirPlus
Imports System.Xml
Imports System.IO
Imports System.Globalization
Partial Class Oficina_Virtual_ConsAfiliacionAFP
    Inherits SeguridadOFV

    Dim Valor As String = String.Empty
    Dim Nro_documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
            Consultar()
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub

    Private Sub Consultar()

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

            Dim Usuario As String = infoWS.FTPUser
            Dim Pass As String = infoWS.FTPPass
            Dim data As Byte() = Convert.FromBase64String(Pass)
            Pass = System.Text.ASCIIEncoding.ASCII.GetString(data)

            Dim Resultado As String
            Resultado = ws.ConsultarAfiliacionSDSSporCedula(Nro_documento, Usuario, Pass)

            Dim dataUrl As StringReader
            dataUrl = New StringReader(Resultado)
            Dim ds As DataSet = New DataSet
            ds.ReadXml(dataUrl)

            If ds.Tables.Count > 0 Then

                If Not IsNothing(ds.Tables("AfiliacionesAFP")) Then

                    'Encabezado Afiliacion AFP
                    trSolicitud1.Visible = False
                    trAfiliado1.Visible = True
                    trSolicitud2.Visible = False
                    trAfiliado2.Visible = True

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

                Else
                    If Not IsNothing(ds.Tables("SolicitudesAFP")) Then
                        'Encabezado Solicitudes AFP
                        trSolicitud1.Visible = True
                        trAfiliado1.Visible = False
                        trSolicitud2.Visible = True
                        trAfiliado2.Visible = False

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
                    End If
                End If

                If IsNothing(ds.Tables("AfiliacionAFP")) And IsNothing(ds.Tables("SolicitudAFP")) Then
                    dvError.Visible = True
                    txtError.InnerText = "Usted no tiene nucleo familiar."
                    Exit Sub
                Else
                    dvError.Visible = False
                    txtError.InnerText = ""
                End If

            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString)
            dvError.Visible = True
            txtError.InnerText = ex.Message
        End Try
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class
