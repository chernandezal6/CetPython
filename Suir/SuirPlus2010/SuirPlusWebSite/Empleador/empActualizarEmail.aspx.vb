
Partial Class Empleador_empActualizarEmail
    Inherits BasePage
    Dim email As String = String.Empty
    Dim usuario As String = String.Empty

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load


        If Not Page.IsPostBack Then
            If Request.QueryString("e") <> String.Empty Then
                email = Request.QueryString("e")
            End If
            'llenamos la session 
            Session("CambiarEmail") = "S"
            txtEmail.Text = email
        End If

    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("empActualizarEmail.aspx")
    End Sub

    Protected Sub btnAceptar_Click(sender As Object, e As System.EventArgs) Handles btnAceptar.Click

        If txtEmail.Text <> txtConfirmarEmail.Text Then
            lblMsg.Visible = True
            lblMsg.Text = "El email actual debe ser igual al email de confirmación"
            Exit Sub
        End If

        'actualizamos el email del representante...
        Try
            Dim resultado As String
            Dim valor As String
            resultado = SuirPlus.Empresas.Representante.ActualizarEmailRepresentante(UsrUserName, txtConfirmarEmail.Text, Nothing, "A")

            valor = Split(resultado, "|")(0)
            If valor = "0" Then
                divPantalla.Visible = False
                lblMsg.Visible = True
                lblMsg.Font.Size = FontUnit.Medium
                lblMsg.ForeColor = Drawing.Color.Blue
                lblMsg.Text = "Se le ha enviado un correo electrónico para completar el proceso de activación de su cuenta, favor revisar en su correo."
                lbRegresar.Visible = True
            Else
                lbRegresar.Visible = False
                divPantalla.Visible = True
                Throw New Exception(Split(resultado, "|")(1))
            End If

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try
    End Sub

    Protected Sub lbRegresar_Click(sender As Object, e As System.EventArgs) Handles lbRegresar.Click
        System.Web.Security.FormsAuthentication.SignOut()
        Session.Abandon()
        Response.Redirect("~/Login.aspx?log=r")

    End Sub
End Class
