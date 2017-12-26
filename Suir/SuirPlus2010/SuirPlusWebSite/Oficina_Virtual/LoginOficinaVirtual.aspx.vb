
Partial Class Oficina_Virtual_LoginOficinaVirtual
    Inherits SeguridadOFV
    Public Sub btLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLogin.Click

        Me.lblMensaje.Visible = True
        lblMensaje.Text = String.Empty
        lblError.Visible = False

        Dim resultado_clave As String
        Dim resultado_verificacion_correo As String
        Dim resultado_verif_user_pass As String

        'Pendiente de arreglo!
        If Me.liusuario_correo.Visible = True And Me.Pass.Visible = False Then
            If Me.txtusuario_correo.Text = String.Empty Then
                MostrarMensajeError("Correo electrónico es requerido.")
                Return
            End If
            Try
                resultado_verificacion_correo = SuirPlus.OficinaVirtual.OficinaVirtual.isValidarUsuarioEmailOFV(txtusuario_correo.Text)
                If resultado_verificacion_correo <> 1 Then
                    MostrarMensajeError("Usuario no existe en nuestra base de datos.")
                    Return
                Else
                    resultado_clave = SuirPlus.OficinaVirtual.OficinaVirtual.CambiarClaveOFV(Me.txtusuario_correo.Text)
                    If resultado_clave = "0" Then
                        lblMensajeRecuperar.Visible = False
                        lblMensaje.Text = "Se ha enviado un correo electrónico con la nueva contraseña, con esta podrá acceder a la Oficina Virtual de la Tesorería de la Seguridad Social (TSS)."
                        Return
                    Else
                        lblMensajeRecuperar.Visible = False
                        lblMensaje.Text = "No se encuentra registrado ningun usuario con este correo electrónico"
                    End If
                End If
            Catch ex As Exception
                MostrarMensajeError(ex.Message.ToString)
            End Try
        Else
            If Me.Usuario.Text = String.Empty Then
                MostrarMensajeError("Usuario es requerido.")
                Return
            End If
            If Me.Pass.Text = String.Empty Then
                MostrarMensajeError("Contraseña es requerida.")
                Return
            End If
            resultado_verif_user_pass = SuirPlus.OficinaVirtual.OficinaVirtual.isValidarUsuarioOFC(Usuario.Text, Pass.Text)

            If resultado_verif_user_pass.Split("|")(0) = "0" Then
                'verificamos si es nss o cedula para utilizar cedula como parametro unico en consultas

                If Usuario.Text.Trim.Length = 11 Then
                    HttpContext.Current.Session("UserNameOFV") = Usuario.Text
                    HttpContext.Current.Session("UserNoDocument") = Usuario.Text
                    AutenticarUsuario()
                Else
                    Dim NSS = Convert.ToDecimal(Usuario.Text.Trim)
                    HttpContext.Current.Session("UserNoDocument") = SuirPlus.Utilitarios.TSS.getCiudadanoNSS(NSS).Rows(0)(6)
                    HttpContext.Current.Session("UserNameOFV") = Usuario.Text
                    AutenticarUsuario()
                End If

                'aqui buscamos la cedula para este nss

                'si trae cedula 
                'HttpContext.Current.Session("UserNameOFV") = Usuario.Text
                'AutenticarUsuario()
                'de lo contrario, vuelve al loggin con un mensaje
                'End If
            ElseIf resultado_verif_user_pass.Split("|")(0) = "1" Then
                MostrarMensajeError("Usuario o Contraseña incorrecto")
                Exit Sub
            Else
                MostrarMensajeError(resultado_verif_user_pass.Split("|")(1))
                Exit Sub
            End If
            End If
    End Sub
    Private Sub MostrarMensajeError(ByVal Mensaje As String)
        Me.lblError.Visible = True
        Me.lblError.Text = Mensaje
    End Sub

    Private Sub OcultarMensajeError()
        Me.lblError.Visible = False
    End Sub

    Private Sub OcultaryRecuperar()
        OcultarMensajeError()
        Me.licontraseña.Visible = False
        Me.lbtnRecuperarClave.Visible = False
        Me.lblMensajeRecuperar.Visible = True
        Me.liusuario_cedula.Visible = False
        Me.liusuario_correo.Visible = True
        Me.divTituloWelcome.Visible = False
        Me.divTituloRec.Visible = True
        Me.RegularExpressionValidator1.Visible = False
        Me.lblMensaje.Text = ""
        Me.lblMensaje.Visible = False
        btnRegresar.Visible = True
        btLogin.Text = "Enviar"
        lbtnRegistrarUsuario.Visible = False
    End Sub

    Private Sub lbtnRecuperarClave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbtnRecuperarClave.Click
        OcultaryRecuperar()
    End Sub

    Protected Sub lbtnRegistrarUsuario_Click(sender As Object, e As EventArgs) Handles lbtnRegistrarUsuario.Click
        Response.Redirect("RegistroSolicitudUsuario.aspx")
    End Sub
    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs) Handles btnRegresar.Click
        Response.Redirect("OficinaVirtual.aspx", True)
    End Sub
End Class
