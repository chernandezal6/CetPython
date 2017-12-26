Imports seg = SuirPlus.Seguridad
Imports SuirPlusEF.Repositories
Partial Class Login
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            Session.Abandon()
        End If

        Dim req As String = Request("log")

        If req = "r" Then
            Me.tblRep.Visible = True
            Me.tblLoginUsuario.Visible = False
            Me.txtrncCedula.Focus()
        Else
            Me.tblRep.Visible = False
            Me.tblLoginUsuario.Visible = True
            Me.txtUserName.Focus()
        End If

        Dim MensajeError As String = Request.QueryString("mensajeerror")
        If Not String.IsNullOrEmpty(MensajeError) Then
            Me.lblError.Text = MensajeError
            Me.lblError.Visible = True
            Exit Sub
        End If

        If Not String.IsNullOrEmpty(Session("LoginErrMsg")) Then
            Me.lblError.Text = Session("LoginErrMsg")
            Me.lblError.Visible = True
        End If

    End Sub

    Protected Sub lbtnCambioClass_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbtnCambioClass.Click
        Response.Redirect(Application("servidor") & "sys/segCambioClass.aspx")
    End Sub

    Protected Sub lbtnCambioClass2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbtnCambioClass2.Click
        Response.Redirect(Application("servidor") & "sys/segCambioClass.aspx?log=r")
    End Sub

    Private Function IsAuthenticated(ByVal UserName As String, ByVal Password As String, ByVal TipoUsuario As String) As Boolean

        Try

            Dim _RepUsr As UsuarioRepository = New UsuarioRepository()

            Dim CambiarPassword As Boolean = False
            Dim UrlRetorno As String = ""
            Dim EstatusUsuario As Boolean = False
            Dim StatusUR As String = ""
            Dim intentos As Integer
            Dim TipoUser As String = ""
            Dim user = _RepUsr.GetByUsername(UserName.ToUpper())

            If user Is Nothing Then
                Me.lblError.Visible = True
                Me.lblError.Text = "Error en el usuario o class."
                Return False
            End If


            Dim ip As String = ipvalue.Value

            If user.TipoUsuario <> TipoUsuario Then
                Me.lblError.Visible = True
                Me.lblError.Text = "Error en el usuario o class."
                Return False
            End If

            If _RepUsr.Login(UserName, Password, ip, TipoUsuario, Request.ServerVariables("LOCAL_ADDR"), Request.ServerVariables("HTTP_USER_AGENT"), CambiarPassword, UrlRetorno, EstatusUsuario, StatusUR, intentos) Then

                If CambiarPassword Then
                    Response.Redirect(UrlRetorno)
                End If

                If EstatusUsuario = False Then
                    Me.lblError.Visible = True
                    Me.lblError.Text = "Este representante esta temporalmente deshabilitado."

                End If

                Return True
            Else
                If StatusUR = "B" Then
                    Me.lblError.Visible = True
                    Me.lblError.Text = "Usted ha excedido la cantidad de intentos para iniciar sesión, su usuario ha sido bloqueado. </br> <a href='/sys/segDesbloquearUR.aspx?TipoUser=" + TipoUsuario + "'>Desbloquear</a>"
                    Exit Function
                End If
                Me.lblError.Visible = True
                Me.lblError.Text = "Error con el Usuario o el Class"

            End If

        Catch ex As Exception

            Throw New Exception(ex.ToString())
            Session("Exception") = ex.ToString()

        End Try
        Return False

    End Function

    Private Sub btLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLogin.Click

        Me.Autenticar(Me.txtUserName.Text, Me.txtClass.Text, 1)

    End Sub

    Private Sub btLoginRep_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLoginRep.Click

        Me.Autenticar(Me.txtrncCedula.Text & Me.txtrepresentante.Text, Me.txtClassRep.Text, 2)

    End Sub

    Private Sub Autenticar(ByVal UserName As String, ByVal Password As String, ByVal TipoUsuario As String)
        Try

            If Me.IsAuthenticated(UserName, Password, TipoUsuario) Then

                Dim Usuario As New SuirPlus.Seguridad.Usuario(UserName)
                Dim _RepUsr As New SuirPlusEF.Repositories.UsuarioRepository()
                Dim UsuarioEF As SuirPlusEF.Models.Usuario = _RepUsr.GetByUsername(Usuario.UserName)

                HttpContext.Current.Session("UsrUserName") = Usuario.UserName
                HttpContext.Current.Session("UsrNombreCompleto") = UsuarioEF.Nombres + " " + UsuarioEF.Apellidos
                HttpContext.Current.Session("TipoUsuario") = "Usuario"
                HttpContext.Current.Session("IDTipoUsuario") = TipoUsuario
                HttpContext.Current.Session("FechaLogin") = Usuario.FechaLogin
                HttpContext.Current.Session("ImpersonandoUnRepresentante") = "N"
                HttpContext.Current.Session("ImpRNC") = ""
                HttpContext.Current.Session("ImpCedula") = ""
                HttpContext.Current.Session("IDEntidadRecaudadora") = Usuario.IDEntidadRecaudadora
                'HttpContext.Current.Session("StatusMantenimiento") = ""

                Dim parametro = SuirPlus.Mantenimientos.Parametro.getParametrosDetalleForName("Operaciones SuirPlus")
                Dim Valor = parametro.Rows(0).Item("VALOR_TEXTO")
                HttpContext.Current.Session("SuirPlus-Status") = Valor

                If Valor <> "NORMAL" Then

                    If Valor = "REDUCIDO" Then
                        HttpContext.Current.Session("SuirPlus-REDUCIDO") = SuirPlus.Mantenimientos.Parametro.getParametrosDetalleForName("SuirPlus-REDUCIDO").Rows(0).Item("VALOR_TEXTO")
                        Me.lblError.Visible = True
                        Me.lblError.Text = HttpContext.Current.Session("SuirPlus-REDUCIDO")
                        Return
                    End If
                    If Valor = "MANTENIMIENTO" Then
                        HttpContext.Current.Session("SuirPlus-MANTENIMIENTO") = SuirPlus.Mantenimientos.Parametro.getParametrosDetalleForName("SuirPlus-MANTENIMIENTO").Rows(0).Item("VALOR_TEXTO")
                        If IsInRole("800") Then
                        Else
                            Me.lblError.Visible = True
                            Me.lblError.Text = HttpContext.Current.Session("SuirPlus-MANTENIMIENTO")
                            Return
                        End If
                    End If
                End If

                If TipoUsuario = 2 Then
                    Dim repCiu As New CiudadanoRepository()
                    Dim repUsu As New UsuarioRepository()
                    Dim nss = repUsu.GetByUsername(UserName)
                    Dim ciu = repCiu.GetByNSS(nss.NumeroSeguridadSocial)

                    HttpContext.Current.Session("TipoUsuario") = "Representante"
                    HttpContext.Current.Session("UsrRNC") = Me.txtrncCedula.Text
                    HttpContext.Current.Session("UsrNombreCompleto") = ciu.Nombres + " " + ciu.PrimerApellido + " " + ciu.SegundoApellido
                    HttpContext.Current.Session("UsrCedula") = Me.txtrepresentante.Text

                    Dim rep As New SuirPlus.Empresas.Representante(Me.txtrncCedula.Text, Me.txtrepresentante.Text)
                    Dim emp = New SuirPlus.Empresas.Empleador(rep.RegistroPatronal)
                    If emp.Estatus = "B" Then
                        System.Web.Security.FormsAuthentication.SignOut()
                        Session.Abandon()
                        Response.Redirect(FormsAuthentication.LoginUrl & "?mensajeerror=Este empleador esta de baja o inactivo.")
                    End If


                    HttpContext.Current.Session("UsrNSS") = rep.IdNSS
                    HttpContext.Current.Session("UsrRegistroPatronal") = rep.RegistroPatronal

                    'si es un representante y en la columna actualizar email tiene el valor "S" lo redireccionamos a actualizar su email.
                    If rep.ActualizarEmail = "S" Then
                        'enviamos a la nueva pagina el email del representante, si lo tiene
                        FormsAuthentication.SetAuthCookie(Usuario.UserName, False)
                        Response.Redirect("Empleador/empActualizarEmail.aspx?e=" + rep.Email)
                    End If
                    'forzamos al representante a completar los datos del empleador requeridos por el sistema

                    'validamos el sector salarial, si no lo tiene, lo debe ingresar
                    If Not emp.CodSector > 0 Then
                        FormsAuthentication.SetAuthCookie(Usuario.UserName, False)
                        Response.Redirect("Empleador/CompletarDatosEmpleador.aspx")
                    End If
                    rep = Nothing
                End If

                If Request.QueryString("ReturnUrl") <> "" Then
                    FormsAuthentication.RedirectFromLoginPage(Usuario.UserName, False)
                Else
                    FormsAuthentication.SetAuthCookie(Usuario.UserName, False)
                    If TipoUsuario = 1 Then
                        Response.Redirect("Default.aspx")
                    Else
                        Response.Redirect("Empleador/consNotificaciones.aspx")
                    End If
                End If
            End If
        Catch ex As Exception
            lblError.Text = ex.Message
            lblError.Visible = True
        End Try
    End Sub

    Protected Sub lbtnRecuperarClassUsuario_Click(sender As Object, e As System.EventArgs) Handles lbtnRecuperarClassUsuario.Click
        Response.Redirect(Application("servidor") & "sys/segRecuperarClass.aspx")
    End Sub

    Protected Sub lbtnRecuperarClassRep_Click(sender As Object, e As System.EventArgs) Handles lbtnRecuperarClassRep.Click
        Response.Redirect(Application("servidor") & "sys/segRecuperarClass.aspx?log=r")
    End Sub
End Class
