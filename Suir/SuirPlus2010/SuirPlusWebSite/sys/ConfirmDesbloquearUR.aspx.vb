
Partial Class sys_ConfirmDesbloquearUR
    Inherits System.Web.UI.Page

    Dim usuario As String = String.Empty
    Dim email As String = String.Empty
    Dim params_link As String = String.Empty
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Request.QueryString("params") <> String.Empty Then
                params_link = Request.QueryString("params")
            Else
                lblMsgErr.Visible = True
                lblMsgErr.Text = "Los datos suministrados son incorrectos, favor iniciar el proceso de desbloqueo de usuario nuevamente."
                Exit Sub
            End If
            'confirmamos los datos del usuario nuevamente y reseteamos su class...
            Try
                Dim resultado As String
                'Dim valor As String
                'resultado = SuirPlus.Seguridad.Usuario.DesbloquearUsuario(usuario, "A", "B")
                params_link = Request.QueryString("params")
                params_link = Request.QueryString("params")
                resultado = SuirPlus.Seguridad.Usuario.ActualizarUsuario(usuario, "A", params_link)

                'valor = Split(resultado, "|")(0)
                If Split(resultado, "|")(0) = "OK" Then
                    lblMsgOk.Visible = True
                    'lblMsgOk.Text = "Este es un class temporal(" & Split(resultado, "|")(1) & "), favor ingresar al SuirPlus y cambiarlo por uno de su preferencia."
                    lblMsgOk.Text = "Su usuario fue desbloqueado satisfactoriamente, favor ingresar al Suirplus para su confirmación."
                    hdTipoUsuario.Value = Split(resultado, "|")(1)
                Else
                    lblMsgErr.Visible = True
                    lblMsgErr.Text = Split(resultado, "|")(1)
                    lbContinuar.Visible = False
                End If
            Catch ex As Exception
                lblMsgErr.Visible = True
                lblMsgErr.Text = "Ha ocurrido un error en el proceso de confirmación de desbloqueo de su usuario. " & ex.Message
            End Try
        End If
    End Sub
    Protected Sub lbContinuar_Click(sender As Object, e As EventArgs) Handles lbContinuar.Click
        If hdTipoUsuario.Value = "1" Then
            Response.Redirect("~/Login.aspx")
        Else
            Response.Redirect("~/Login.aspx?log=r")
        End If
    End Sub

End Class
