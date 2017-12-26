Imports SuirPlus
Imports SuirPlusEF.Repositories
Imports SuirPlusEF.Models
Partial Class sys_segCambioClass
    Inherits System.Web.UI.Page
    Dim Convertidor As New UsuarioRepository
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
        'Put user code to initialize the page here
        If Not Page.IsPostBack Then
            System.Web.Security.FormsAuthentication.SignOut()
            Session.Abandon()
        End If
        Dim req As String
        req = Request("log")
        If req = "r" Then
            Me.tblRep.Visible = True
            Me.tblLoginUsuario.Visible = False
            'Obtenemos los valores del RNC y la Cedula del empleador y representante.
            If Not Request("RNC") Is Nothing Then
                txtRncCedula.Text = Request("RNC").ToString
            End If
            If Not Request("Cedula") Is Nothing Then
                txtRepresentante.Text = Request("Cedula").ToString
            End If
        Else
            Me.tblRep.Visible = False
            Me.tblLoginUsuario.Visible = True
            If Request("user") IsNot Nothing Then
                Me.txtUserName.Text = Request("user").ToString
            End If
        End If
        'Determinando si estan redireccionando por primera vez login
        If Not IsPostBack Then
            If Session("MSG") <> "" Then
                Me.lblCambioMsg.Text = Session("msg")
            Else
                Me.lblCambioMsg.Text = ""
            End If
        End If
        Me.lblMsg.Text = ""
        Me.lblError.Text = ""
    End Sub
    Private Sub btLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLogin.Click
        Try
            If ((Me.txtClassNuevo.Text = "") Or (Me.txtClassNuevo.Text <> Me.txtClassRepetir.Text)) Then
                Me.MostrarMensajeError("Error en el CLASS nuevo")
                Exit Sub
            End If
            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()
            usuario = _RepUsr.GetByUsername(txtUserName.Text.ToUpper())
            If usuario IsNot Nothing Then
                If usuario.Estatus = "B" Then
                    lblMensaje.Text = "Su usuario se encuentra bloqueado. Para desbloquearlo hacer click en <a href='/sys/segDesbloquearUR.aspx?TipoUser=" + usuario.TipoUsuario + "'>Desbloquear</a>"
                    lblMensaje.Visible = True
                    Return
                End If
                If usuario.Estatus = "I" Then
                    lblMensaje.Text = "Su usuario se encuentra inactivo, favor verificar o contactar nuestra área de mesa de ayuda"
                    lblMensaje.Visible = True
                    Return
                End If
                If (usuario.IdUsuario <> txtUserName.Text.ToUpper()) Or (usuario.Class <> Convertidor.HashPassword(txtClassAnterior.Text)) Then
                    lblMensaje.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar nuestra área de mesa de ayuda."
                    lblMensaje.Visible = True
                    Return
                End If
            Else
                lblMensaje.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar nuestra área de mesa de ayuda."
                lblMensaje.Visible = True
                Return
            End If
            Dim resultado As String
            resultado = Seguridad.Usuario.CambiarClass(Me.txtUserName.Text, Me.txtClassNuevo.Text, Me.txtClassAnterior.Text)
            If resultado = "0" Then
                Me.txtUserName.Text = ""
                Session("msg") = "Su CLASS fue actualizado satisfactoriamente."
                Response.Redirect("~/Login.aspx")
            Else
                Me.lblMensaje.Text = resultado
                Me.lblMensaje.Visible = True
                Exit Sub
            End If
        Catch ex As Exception
            Me.ValidationSummary0.Visible = False
            lblMensaje.Text = ex.Message
        End Try
    End Sub
    Private Sub MostrarMensajeError(ByVal Mensaje As String)
        Me.lblError.Visible = True
        Me.lblError.Text = Mensaje
    End Sub
    Private Sub btLoginRep_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLoginRep.Click
        Try
            If ((Me.txtRepresentante.Text = "") Or (Me.txtClassRepNuevo.Text <> Me.txtClassRepRepetir.Text)) Then
                Me.MostrarMensajeError("Error en el CLASS nuevo")
                Exit Sub
            End If
            Dim usuario As Usuario = New Usuario()
            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()
            usuario = _RepUsr.GetByUsername(txtRncCedula.Text + txtRepresentante.Text)
            If usuario IsNot Nothing Then
                If usuario.Estatus = "B" Then
                    lblMensaje0.Text = "Su usuario se encuentra bloqueado. Para desbloquearlo hacer click en <a href='/sys/segDesbloquearUR.aspx?TipoUser=" + usuario.TipoUsuario + "'>Desbloquear</a>"
                    lblMensaje0.Visible = True
                    Return
                End If
                If usuario.Estatus = "I" Then
                    lblMensaje0.Text = "Su usuario se encuentra inactivo, favor verificar o contactar nuestra área de mesa de ayuda"
                    lblMensaje0.Visible = True
                    Return
                End If
                If (usuario.IdUsuario <> (txtRncCedula.Text + txtRepresentante.Text)) Or (usuario.Class <> Convertidor.HashPassword(txtClassRepAnterior.Text)) Then
                    lblMensaje0.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE <br>al 809-472-6363"
                    lblMensaje0.Visible = True
                    Return
                End If
            Else
                lblMensaje.Text = "Los datos suministrados son incorrectos, <br>favor verificar o contactar a la Dirección de atención al empleador DAE <br>al 809-472-6363"
                lblMensaje.Visible = True
                Return
            End If
            Dim resultado As String
            resultado = Seguridad.Usuario.CambiarClass(Me.txtRncCedula.Text & Me.txtRepresentante.Text, Me.txtClassRepNuevo.Text, Me.txtClassRepAnterior.Text)
            If resultado = "0" Then
                Me.txtRncCedula.Text = ""
                Me.txtRepresentante.Text = ""
                Session("msg") = "Su CLASS fue actualizado satisfactoriamente."
                Response.Redirect("~/Login.aspx?log=r")
            Else
                Me.lblMensaje0.Text = resultado
                Me.lblMensaje0.Visible = True
                Exit Sub
            End If
        Catch ex As Exception
            Me.ValidationSummary.Visible = False
            lblMensaje0.Text = ex.Message
        End Try
    End Sub
    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        limpiar()
    End Sub
    Protected Sub limpiar()
        Me.lblError.Text = String.Empty
        Me.lblMensaje0.Text = String.Empty
        Me.lblMensaje.Text = String.Empty
    End Sub
    Protected Sub Button2_Click(sender As Object, e As System.EventArgs) Handles Button2.Click
        limpiar()
    End Sub
End Class