Imports System.Data
Imports System.DateTime

Partial Class SuirPlusMasterPage
    Inherits System.Web.UI.MasterPage
    Dim bPage As New BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If bPage.UsrIDTipoUsuario = 2 Then
            Me.UCSubEncabezadoEmp1.Visible = False

            'Cargando los mensajes
            CargarInbox()
        Else

            If bPage.UsrImpersonandoUnRepresentante = True Then
                Me.UCSubEncabezadoEmp1.Visible = True
            Else
                Me.UCSubEncabezadoEmp1.Visible = False
            End If

        End If

        'En este segmento se genera el mensaje de los derechos Reservados.
        idDerechosReservados.InnerText = "© 2002-" + Date.Today.Year.ToString() + " Tesorería de la Seguridad Social. Derechos Reservados."
        'Fin del segmento

        Dim quien As String

        'Variable de Session Utilizada para llenar el WebServices TSS
        Session("IPWebServicesTSS") = Request.ServerVariables("LOCAL_ADDR")

        Select Case Request.ServerVariables("LOCAL_ADDR")
            'SATURN
            Case "172.16.5.59"
                quien = "N|SuirPlus"
            Case "172.16.5.70"
                quien = "N|SuirPlus02"
            Case "172.16.5.71"
                quien = "N|SuirPlus03"
            Case "172.16.5.72"
                quien = "N|SuirPlus04"
            Case "172.16.5.73"
                quien = "N|SuirPlus05"
            Case "172.16.5.74"
                quien = "N|SuirPlus06"
            Case "172.16.5.75"
                quien = "N|SuirPlus07"
            Case "172.16.5.76"
                quien = "N|SuirPlus08"
            Case "172.16.5.77"
                quien = "N|SuirPlus09"
            Case "172.16.5.78"
                quien = "N|SuirPlus10"

                'SAAB
            Case "172.16.5.62"
                quien = "B|SuirPlus"
            Case "172.16.5.79"
                quien = "B|SuirPlus02"
            Case "172.16.5.83"
                quien = "B|SuirPlus03"
            Case "172.16.5.84"
                quien = "B|SuirPlus04"
            Case "172.16.5.85"
                quien = "B|SuirPlus05"
            Case "172.16.5.86"
                quien = "B|SuirPlus06"
            Case "172.16.5.87"
                quien = "B|SuirPlus07"
            Case "172.16.5.88"
                quien = "B|SuirPlus08"
            Case "172.16.5.89"
                quien = "B|SuirPlus09"
            Case "172.16.5.91"
                quien = "B|SuirPlus10"

            Case Else
                quien = "N/A"
        End Select

        Me.lblUsuarios.Text = "Usuarios en linea: " & Application("ActiveUsers")
        Me.lblServer.Text = Application("servidor") & " | " & Request.ServerVariables("HTTP_HOST") & " | " & quien

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        bPage.highLigthTextbox(Me.MainContent)

    End Sub

    Protected Sub lbMensajes_Click(sender As Object, e As EventArgs) Handles lbMensajes.Click
        Response.Redirect("..\Empleador\empManejoMensajes.aspx")
    End Sub

    Public Sub CargarInbox()
        Dim mensajes As String = SuirPlus.Empresas.Empleador.getmensajes_sin_leer(bPage.UsrRegistroPatronal)
        If mensajes <> "" Then
            If Convert.ToInt16(mensajes) = 1 Then
                lbMensajes.Text = "(" + mensajes + ")" + " " + "Mensaje"
                lbMensajes.Visible = True
                divMensaje.Visible = True
            Else
                lbMensajes.Text = "(" + mensajes + ")" + " " + "Mensajes"
                lbMensajes.Visible = True
                divMensaje.Visible = True
            End If

        End If
    End Sub
End Class

