Imports SuirPlus
Imports SuirPlusEF.Repositories
Imports SuirPlusEF.Models

Partial Class sys_segDesbloquearUR
    Inherits System.Web.UI.Page

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        Dim req As String

        req = Request("TipoUser")

        If req = "2" Then
            Me.tblRep.Visible = True
            Me.tblLoginUsuario.Visible = False
        ElseIf req = "1" Then
            Me.tblRep.Visible = False
            Me.tblLoginUsuario.Visible = True
        End If
    End Sub
    Protected Sub btLogin_Click(sender As Object, e As System.EventArgs) Handles btLogin.Click
        'desbloqueo del representante...
        Try
            If (txtUsuario.Text = String.Empty) Or (txtEmailUsuario.Text = String.Empty) Then
                Throw New Exception("El usuario y el email son requeridos")
            End If
            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()

            usuario = _RepUsr.GetByUsername(txtUsuario.Text.ToUpper())

            If usuario IsNot Nothing Then
                If usuario.IdUsuario <> txtUsuario.Text.ToUpper() Then
                    lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactarse con el área de mesa de ayuda."
                    lblMsg.Visible = True
                    Return
                End If

                If usuario.Email.ToUpper() <> txtEmailUsuario.Text.ToUpper() Then
                    lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactarse con el área de mesa de ayuda."
                    lblMsg.Visible = True
                    Return
                End If
            Else
                lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactarse con el área de mesa de ayuda."
                lblMsg.Visible = True
                Return

            End If

            DesbloquearUsuario(txtUsuario.Text.ToUpper(), "A", "B")


        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try
    End Sub
    Protected Sub btLoginRep_Click(sender As Object, e As System.EventArgs) Handles btLoginRep.Click
        'desbloqueo del representante...
        Try
            If (txtRncCedula.Text = String.Empty) Or (txtCedulaRep.Text = String.Empty) Or (txtEmailRep.Text = String.Empty) Then
                Throw New Exception("El rnc, la cedula y el email son requeridos")
            End If

            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()

            usuario = _RepUsr.GetByUsername(txtRncCedula.Text + txtCedulaRep.Text)

            If usuario IsNot Nothing Then
                If usuario.IdUsuario <> (txtRncCedula.Text + txtCedulaRep.Text) Then
                    lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE al 809-472-6363"
                    lblMsg.Visible = True
                    Return
                End If

                If usuario.Email.ToUpper() <> txtEmailRep.Text.ToUpper() Then
                    lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE al 809-472-6363"
                    lblMsg.Visible = True
                    Return
                End If
            Else
                lblMsg.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE al 809-472-6363"
                lblMsg.Visible = True
                Return
            End If

            Dim usuarioRepresentante = txtRncCedula.Text + txtCedulaRep.Text
            DesbloquearUsuario(usuarioRepresentante, "A", "B")

        Catch ex As Exception
            lblMsg.Visible = True
            lblMsg.Text = ex.Message
        End Try
    End Sub
    Protected Sub DesbloquearUsuario(usuario As String, status As String, accion As String)
        Try
            Dim resultado As String
            Dim valor As String

            resultado = SuirPlus.Seguridad.Usuario.DesbloquearUsuario(usuario, status, accion)
            valor = Split(resultado, "|")(0)

            If valor = "0" Then
                lblMsg.Visible = True
                lblMsg.Font.Size = FontUnit.Medium
                lblMsg.ForeColor = Drawing.Color.Blue

                lblMsg.Text = "Se le ha enviado un correo electrónico para completar el proceso de desbloqueo de su usuario, favor revisar su correo."
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
        txtUsuario.Text = String.Empty
        txtEmailUsuario.Text = String.Empty
        lblMensaje.Text = String.Empty
        lblMsg.Visible = False
    End Sub
    Protected Sub btnCancelarRep_Click(sender As Object, e As System.EventArgs) Handles btnCancelarRep.Click
        txtRncCedula.Text = String.Empty
        txtCedulaRep.Text = String.Empty
        txtEmailRep.Text = String.Empty
        lblMensaje0.Text = String.Empty
        lblMsg.Visible = False

    End Sub

End Class
