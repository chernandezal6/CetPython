Imports System.Data

Partial Class Reg_LoginPage


    Inherits RegistroEmpresaSeguridad

    Public Sub btLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Me.lblMensaje.Visible = True
        lblMensaje.Text = String.Empty
        lblError.Visible = False

        Dim resultado As String
        Dim resultado2 As String

        If Me.Usuario.Visible = True And Me.Pass.Visible = False Then
            If Me.Usuario.Text = String.Empty Then
                lblError.Text = "Usuario es requerido."
                lblError.Visible = True
                Return
            End If
            resultado2 = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuarioReg(Me.Usuario.Text)

            If resultado2 = 1 Then
                lblError.Text = "Usuario no existe en nuestra base de datos."
                lblError.Visible = True
                Return
            End If


            resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.CambiarClave(Me.Usuario.Text)
            If resultado = 0 Then
                Usuario.Text = String.Empty
                licontraseña.Visible = True
                lblMensajeRecuperar.Visible = False

                lblMensaje.Text = "Se ha enviado un correo electrónico con la nueva contraseña, con esta podrá acceder al Registro de Empresa SuirPlus."
                Return
            Else
                lblError.Text = "No se encontró representante con este Correo"
                lblError.Visible = True
                Return
            End If

        Else
            If Me.Usuario.Text = String.Empty Then
                lblError.Text = "Usuario es requerido."
                lblError.Visible = True
                Return
            End If
            If Me.Pass.Text = String.Empty Then
                lblError.Text = "Contraseña es requerida."
                lblError.Visible = True
                Return
            End If
            resultado = SuirPlus.SolicitudesEnLinea.Solicitudes.isValidarUsuario(Me.Usuario.Text, Me.Pass.Text)

            If resultado = "0" Then

                Me.lblSucess.Text = "Ha sido identificado correctamente!"
                Me.lblSucess.Visible = True

                HttpContext.Current.Session("UserName") = Me.Usuario.Text
                HttpContext.Current.Session("NombreCompleto") = Me.Usuario.Text
                HttpContext.Current.Session("Estatus") = 1

                AutenticarUsuario()

            ElseIf resultado = "1" Then
                Me.lblError.Text = "Usuario o Contraseña incorrecto"
                lblError.Visible = True
                Exit Sub
            Else

                Me.lblMensaje.Text = resultado
                Exit Sub

            End If
        End If
    End Sub

    Private Sub MostrarMensajeError(ByVal Mensaje As String)
        Me.lblError.Visible = True
        Me.lblError.Text = Mensaje
    End Sub

    Private Sub lbtnRecuperarClave_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbtnRecuperarClave.Click
        Me.licontraseña.Visible = False
        Me.lbtnRecuperarClave.Visible = False
        Me.lblMensajeRecuperar.Visible = True

    End Sub


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.lblMensaje.Text = Request.QueryString("mensajeerror")
        End If
        If Session("UserName") <> String.Empty Then
            Response.Redirect("SolicitudEmpresa.aspx")
        End If
    End Sub

End Class

