Imports System.Data
Imports SuirPlus
Imports System.Net

Partial Class Consultas_consNss
    Inherits BasePage

    Protected dt As DataTable
    Protected dt2 As DataTable
    Protected dt3 As DataTable
    Protected dtCancelada As DataTable
    Private Sub setFormError(ByVal msg As String)
        Me.lblFormError.Text = "<br>" + msg + "<br>"
    End Sub
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
        'Put user code to initialize the page here
        Me.lblFormError.Text = ""
        Me.lblFijo.Text = ""

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

    End Sub
    Private Sub Busqueda()
        Dim causa As String = String.Empty
        Dim NoCausa As String = ""
        If Me.txtnodocumento.Text <> "" Then
            Try
                dtCancelada = SuirPlus.Utilitarios.TSS.CedulaCancelada(CStr(Me.txtnodocumento.Text))
                If dtCancelada.Rows.Count > 0 Then
                    causa = dtCancelada.Rows(0)("tipo_causa").ToString
                    NoCausa = "S"
                Else
                    NoCausa = "N"
                End If

            Catch ex As Exception
                NoCausa = "N"
                Me.lblFormError.Text = ex.Message
                Exepciones.Log.LogToDB(ex.ToString())

            End Try

            If (causa = "C") Or (causa = "I") Then
                If NoCausa = "N" Then
                    lblFormError.Text = "Registro No existe"
                ElseIf NoCausa = "S" Then
                    If dtCancelada.Rows.Count > 0 Then
                        lblFijo.Text = "Cancelada..:"
                        lblFormError.Text = dtCancelada.Rows(0)("cancelacion_des").ToString
                    End If
                    Me.dgDetalle.Visible = True
                    dt = SuirPlus.Utilitarios.TSS.getConsultaNss(Me.txtnodocumento.Text, String.Empty, String.Empty, String.Empty, String.Empty, 1, 9999)
                    If dt.Rows.Count > 0 Then
                        Me.dgDetalle.DataSource = dt
                        Me.dgDetalle.DataBind()
                    End If

                End If
            Else
                Try

                    dt = SuirPlus.Utilitarios.TSS.getConsultaNss(Me.txtnodocumento.Text, String.Empty, String.Empty, String.Empty, String.Empty, 1, 9999)
                    If dt.Rows.Count > 0 Then
                        Me.dgDetalle.DataSource = dt
                        Me.dgDetalle.DataBind()
                    Else
                        Me.dgDetalle.DataSource = Nothing
                        Me.dgDetalle.DataBind()
                        Me.lblFormError.Text = "Datos no encontrados"
                    End If

                Catch ex As Exception
                    Response.Write(ex.ToString())
                    lblFijo.Text = "Cancelada..:"
                    Me.lblFormError.Text = "Datos no encontrados"
                End Try
            End If
        Else
            Try

                dt = SuirPlus.Utilitarios.TSS.getConsultaNss(Me.txtnodocumento.Text, String.Empty, String.Empty, String.Empty, String.Empty, 1, 9999)
                Me.dgDetalle.DataSource = dt
                Me.dgDetalle.DataBind()

            Catch ex As Exception
                Response.Write(ex.ToString())
                lblFijo.Text = "Cancelada, a causa de:"
                Me.lblFormError.Text = "Datos no encontrados"
            End Try
        End If
    End Sub

    Private Sub btBuscarRef_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuscarRef.Click

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

        If (Me.txtnodocumento.Text = "") Then
            Me.lblFormError.Text = "Debe introducir un Número de documento válido."
            Me.dgDetalle.Visible = False
        Else
            Me.dgDetalle.Visible = True
            Me.Busqueda()
        End If
    End Sub

    Private Sub btnLimpiar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.txtnodocumento.Text = ""
        Me.dgDetalle.DataSource = Nothing
        Me.dgDetalle.DataBind()
        Me.dgDetalle.Visible = False

    End Sub

    Protected Sub dgDetalle_RowDataBound1(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalle.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(0).Text = SuirPlus.Utilitarios.Utils.FormatearNSS(e.Row.Cells(0).Text)
        End If
    End Sub


End Class
