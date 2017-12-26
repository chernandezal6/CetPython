Imports SuirPlusEF.Repositories
Imports SuirPlusEF.Models

Partial Class sys_segRecuperarClass
    Inherits BasePage

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim req As String
        req = Request("log")

        If req = "r" Then

            Me.tblRep.Visible = True
            Me.tblLoginUsuario.Visible = False
        Else
            Me.tblRep.Visible = False
            Me.tblLoginUsuario.Visible = True
        End If
    End Sub

    Protected Sub btLogin_Click(sender As Object, e As System.EventArgs) Handles btLogin.Click

        'recuperacion de class del representante...
        Try
            If (txtUsuario.Text = String.Empty) Or (txtEmailUsuario.Text = String.Empty) Then
                Throw New Exception("El usuario y el email son requeridos")
            End If

            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()

            usuario = _RepUsr.GetByUsername(txtUsuario.Text.ToUpper())

            If usuario IsNot Nothing Then
                If usuario.Estatus = "B" Then
                    lblMensaje.Text = "Su usuario se encuentra bloqueado. Para desbloquearlo hacer click en <a href='/sys/segDesbloquearUR.aspx?TipoUser=" + usuario.TipoUsuario + "'>Desbloquear</a>"
                    lblMensaje.Visible = True
                    Return
                End If
                If usuario.Email.ToUpper() <> txtEmailUsuario.Text.ToUpper() Then
                    lblMensaje.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar nuestra área de mesa de ayuda."
                    lblMensaje.Visible = True
                    Return
                End If
            Else
                lblMensaje.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar nuestra área de mesa de ayuda."
                lblMensaje.Visible = True
                Return
            End If

            RecuperarClass(txtUsuario.Text, txtEmailUsuario.Text, "R", "Usr")

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try
    End Sub

    Protected Sub btLoginRep_Click(sender As Object, e As System.EventArgs) Handles btLoginRep.Click

        'recuperacion de class del representante...
        Try

            If (txtRncCedula.Text = String.Empty) Or (txtCedulaRep.Text = String.Empty) Or (txtEmailRep.Text = String.Empty) Then
                Throw New Exception("El rnc, la cedula y el email son requeridos")
            End If

            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()

            usuario = _RepUsr.GetByUsername(txtRncCedula.Text + txtCedulaRep.Text)

            If usuario IsNot Nothing Then
                If usuario.Estatus = "B" Then
                    lblMensaje0.Text = "Su usuario se encuentra bloqueado. Para desbloquearlo hacer click en <a href='/sys/segDesbloquearUR.aspx?TipoUser=" + usuario.TipoUsuario + "'>Desbloquear</a>"
                    lblMensaje0.Visible = True
                    Return
                End If
                If usuario.Email.ToUpper() <> txtEmailRep.Text.ToUpper() Then
                    lblMensaje0.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE <br>al 809-472-6363."
                    lblMensaje0.Visible = True
                    Return
                End If
            Else
                lblMensaje0.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE <br>al 809-472-6363."
                lblMensaje0.Visible = True
                Return
            End If
            Dim usuarioRepresentante = txtRncCedula.Text & txtCedulaRep.Text
            RecuperarClass(usuarioRepresentante, txtEmailRep.Text, "R", "Rep")

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message

        End Try
    End Sub

    Protected Sub RecuperarClass(usuario As String, email As String, accion As String, tipoClass As String)

        Try
            Dim resultado As String
            Dim valor As String

            resultado = SuirPlus.Seguridad.Usuario.RecuperarClass(usuario, email, Nothing, accion)
                valor = Split(resultado, "|")(0)
            If valor = "0" Then
                lblMsg.Visible = True
                lblMsg.Font.Size = FontUnit.Medium
                lblMsg.ForeColor = Drawing.Color.Blue
                lblMsg.Text = "Se le ha enviado un correo electrónico para completar el proceso de recuperación de su class, favor revisar su correo."
                'limpiamos los campos
                txtRncCedula.Text = String.Empty
                txtCedulaRep.Text = String.Empty
                txtEmailRep.Text = String.Empty
                txtUsuario.Text = String.Empty
                txtEmailUsuario.Text = String.Empty
            Else
                lblMsg.Visible = False
                Throw New Exception(Split(resultado, "|")(1))
            End If
        Catch ex As Exception
            Me.ValidationSummary.Visible = False
            Me.ValidationSummary0.Visible = False
            Throw ex
        End Try
    End Sub

    Protected Sub btnCancelarUsr_Click(sender As Object, e As System.EventArgs) Handles btnCancelarUsr.Click
        Response.Redirect("segRecuperarClass.aspx")
    End Sub

    Protected Sub btnCancelarRep_Click(sender As Object, e As System.EventArgs) Handles btnCancelarRep.Click
        Response.Redirect("segRecuperarClass.aspx")
    End Sub
End Class
