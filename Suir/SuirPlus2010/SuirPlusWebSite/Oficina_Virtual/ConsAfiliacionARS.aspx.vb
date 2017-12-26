Imports System.Net
Imports System.Web.Services.Protocols.SoapHttpClientProtocol
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Imports System.Data
Imports SuirPlus
Imports System.Xml
Imports System.IO

Partial Class Oficina_Virtual_ConsAfiliacionARS
    Inherits SeguridadOFV
    Dim Nro_documento As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Nro_documento = UserNoDocument
        If UserNoDocument <> Nothing Then
            Afiliado()
        Else
            Response.Redirect("LoginOficinaVirtual.aspx")
        End If
    End Sub

    Private Sub Afiliado()
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

                If Not IsNothing(ds.Tables("AfiliacionSFS")) Then

                    'Encabezado Afiliacion ARS
                    trSolicitud1.Visible = False
                    trSolicitud2.Visible = False

                    lblARS.Text = ds.Tables("AfiliacionSFS").Rows(0)("ARS").ToString()
                    lblNombre.Text = ds.Tables("AfiliacionSFS").Rows(0)("Nombre").ToString()
                    lblStatus.Text = ds.Tables("AfiliacionSFS").Rows(0)("Estatus").ToString()
                    'Para dar formato a la fecha dd/mm/yyyy
                    Dim strDate As String
                    Dim objdate As Date
                    strDate = ds.Tables("AfiliacionSFS").Rows(0)("FechaAfiliacion")
                    strDate = strDate.Substring(0, 2) & "/" & strDate.Substring(2, 2) & "/" & strDate.Substring(4, 4)
                    objdate = Date.Parse(strDate).ToShortDateString
                    lblFechaAfiliacion.Text = objdate
                    Dim tip As String
                    tip = ds.Tables("AfiliacionSFS").Rows(0)("TipoAfiliacion").ToString()
                    lblTipoAfiliacion.Text = tip.Split("=")(1)

                    'Detalle
                    NucleoFamiliar(ds.Tables("AfiliacionSFS"))
                ElseIf Not IsNothing(ds.Tables("SolicitudSFS")) Then

                    'Encabezado Solicitud ARS
                    trAfiliado1.Visible = False
                    trAfiliado2.Visible = True

                    lblARS.Text = ds.Tables("SolicitudSFS").Rows(0)("ARS").ToString()
                    lblNombre.Text = ds.Tables("SolicitudSFS").Rows(0)("Nombre").ToString()
                    lblStatus.Text = ds.Tables("SolicitudSFS").Rows(0)("Estatus").ToString()
                    'Para dar formato a la fecha dd/mm/yyyy
                    Dim strDate As String
                    Dim objdate As Date
                    strDate = ds.Tables("SolicitudSFS").Rows(0)("FechaSolicitud")
                    strDate = strDate.Substring(0, 2) & "/" & strDate.Substring(2, 2) & "/" & strDate.Substring(4, 4)
                    objdate = Date.Parse(strDate).ToShortDateString
                    lblFechaSolicitud.Text = objdate
                    Dim tip As String
                    tip = ds.Tables("SolicitudSFS").Rows(0)("Motivo").ToString()
                    lblTipoSolicitud.Text = tip.Split("=")(1)

                    'Detalle
                    NucleoFamiliar(ds.Tables("AfiliacionSFS"))
                End If

                If IsNothing(ds.Tables("AfiliacionSFS")) And IsNothing(ds.Tables("SolicitudSFS")) Then
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
    Private Sub NucleoFamiliar(NucloFamiliar As DataTable)
        gvNucleoFamiliar.DataSource = NucloFamiliar
        gvNucleoFamiliar.DataBind()
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class
