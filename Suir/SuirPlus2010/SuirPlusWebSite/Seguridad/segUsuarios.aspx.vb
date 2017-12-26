Imports SuirPlus
Imports SuirPlus.Bancos


Partial Class Seguridad_segUsuarios
    Inherits BasePage

    Private Estatus As Modo
    Private Rep As New SuirPlusEF.Repositories.UsuarioRepository
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.CargaInicial()
            infoUsuario.Visible = True

            ''llenamos las entidades by cp
            LlenarEntidad(0)

        Else
            Me.Estatus = ViewState().Item("Modo")
        End If

    End Sub

    Private Sub CargaInicial()
        'Me.llenarDataGridUsuarios()
    End Sub


    Private Sub llenarDataGridUsuarios()

        Dim roleUsr As String = String.Empty
        Try

            If Me.IsInRole(BasePage.constIDRoleBanco) Then roleUsr = BasePage.constIDRoleBanco
            If Me.IsInRole(BasePage.constIDRoleDGII) Then roleUsr = BasePage.constIDRoleDGII
            If Me.IsInRole(BasePage.constIDRoleCGG) Then roleUsr = BasePage.constIDRoleCGG
            If Me.IsInRole(BasePage.constIDRoleAFP) Then roleUsr = BasePage.constIDRoleAFP
            If Me.IsInRole(BasePage.constIDRoleDIDA) Then roleUsr = BasePage.constIDRoleDIDA

            If ((Me.txtSrchUserName.Text = "") And (Me.txtSrchNombres.Text = "") And (Me.txtSrchApellidos.Text = "")) Then

                Me.dgUsuarios.SelectedIndex = -1
                Me.dgUsuarios.DataSource = Nothing
                Me.dgUsuarios.DataBind()
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "Debe digitar un (Usuario un Nombre o un Apellido)"

            ElseIf (Me.IsInRole(BasePage.constIDRoleBanco) Or Me.IsInRole(BasePage.constIDRoleDGII) Or Me.IsInRole(BasePage.constIDRoleCGG) Or Me.IsInRole(BasePage.constIDRoleAFP) Or Me.IsInRole(BasePage.constIDRoleDIDA)) Then

                Me.dgUsuarios.SelectedIndex = -1
                Dim usr As New Seguridad.Usuario(Me.UsrUserName)
                Me.dgUsuarios.DataSource = Seguridad.Usuario.getUsuarios(Me.txtSrchUserName.Text, Me.txtSrchNombres.Text, Me.txtSrchApellidos.Text, roleUsr, usr.IDEntidadRecaudadora)
                Me.dgUsuarios.DataBind()

                'Llenar entidad recaudadora correspondiente
                LlenarEntidad(UsrIDEntidadRecaudadora)

            Else

                Dim dt As New Data.DataTable
                dt = Seguridad.Usuario.getUsuarios(Me.txtSrchUserName.Text, Me.txtSrchNombres.Text, Me.txtSrchApellidos.Text)

                If dt.Rows.Count > 0 Then

                    Me.dgUsuarios.SelectedIndex = -1
                    Me.dgUsuarios.DataSource = dt
                    Me.dgUsuarios.DataBind()

                Else

                    Me.dgUsuarios.DataSource = dt
                    Me.dgUsuarios.DataBind()

                    Throw New Exception("No existen registros.")

                End If


            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Private Sub LlenarEntidad(ByVal ent As Int32)

        Dim dt As New Data.DataTable
        dt = EntidadRecaudadora.getBancos(ent)

        Dim dr As Data.DataRow
        For Each dr In dt.Rows
            If dr.Item("id_entidad_recaudadora").ToString() = 0 Then
                dr.Delete()
                Exit For
            End If
        Next
        Me.ddlEntidad.DataSource = dt
        Me.ddlEntidad.DataTextField = "entidad_recaudadora_des"
        Me.ddlEntidad.DataValueField = "id_entidad_recaudadora"
        Me.ddlEntidad.DataBind()

        If ent Then
            ddlEntidad.SelectedValue = ent
        Else
            Dim item As New ListItem
            item.Value = -1
            item.Text = "Seleccione una Entidad Recaudadora"
            ddlEntidad.DataBind()
            ddlEntidad.Items.Add(item)
            ddlEntidad.SelectedValue = -1
        End If



    End Sub

    Private Sub llenarDataGridPermisos()
        Dim UserName As String = ViewState().Item("UserName")
        Dim Usuario As New Seguridad.Usuario(UserName)

        Me.dgPermisos.DataSource = Usuario.getPermisos
        Me.dgPermisos.DataBind()
        Me.dgPermisos.Visible = True
        Me.lblPermisosHeader.Text = "Permisos del Usuario: " & Usuario.NombreCompleto
        Me.btnAgregarPermiso.Attributes.Clear()
        Me.btnAgregarPermiso.Attributes.Add("onclick", "mWindow = window.open('popPermisos.aspx?UserName=" & Usuario.UserName & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=500,height=450,scrollbars=yes,toolbar=no,status=no');")

    End Sub
    Private Sub llenarDataGridRoles()
        Dim UserName As String = ViewState().Item("UserName")
        Dim Usuario As New Seguridad.Usuario(UserName)

        Me.dgRoles.DataSource = Usuario.getRoles
        Me.dgRoles.DataBind()
        Me.dgRoles.Visible = True
        Me.lblRolesHeader.Text = "Roles del Usuario: " & Usuario.NombreCompleto
        Me.btnAgregarRole.Attributes.Clear()
        Me.btnAgregarRole.Attributes.Add("onclick", "mWindow = window.open('popRoles.aspx?UserName=" & Usuario.UserName & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=300,height=300,scrollbars=yes,toolbar=no,resizable=no,status=no');")

    End Sub
    Private Sub limpiarCampos()

        Me.txtEmail.Text = ""
        Me.txtNombres.Text = ""
        Me.txtUserName.Text = ""
        Me.txtApellidos.Text = ""
        Me.txtPassword.Text = ""
        Me.txtComen.Text = String.Empty
        Me.txtDepartamento.Text = String.Empty
        ' Me.ddlEntidad.SelectedValue = "0"


    End Sub
    Private Sub MostrarArriba()
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlPermisosAsociados.Visible = False
        Me.pnlRolesAsociados.Visible = False
        Me.updPermisos.Update()
        Me.updRoles.Update()
        Me.updDetalle.Update()
        Me.updListado.Update()
    End Sub

    Private Sub MostrarAbajo()
        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False
        Me.pnlPermisosAsociados.Visible = False
        Me.pnlRolesAsociados.Visible = False
        Me.updListado.Update()
        Me.updRoles.Update()
        Me.updPermisos.Update()
        Me.valSum.Visible = True
        Me.reqFieldApellidos.Visible = True
        Me.reqFieldClass.Visible = True
        Me.reqFieldClass.Enabled = True
        Me.reqFieldEmail.Visible = True
        Me.reqFieldNombres.Visible = True
        Me.reqFieldUsuario.Visible = True

    End Sub

    Private Sub MostrarPermisosAsociados()

        Me.pnlListado.Visible = True
        Me.pnlDetalle.Visible = False
        Me.pnlRolesAsociados.Visible = False
        Me.pnlPermisosAsociados.Visible = True
        Me.updRoles.Update()
        Me.updPermisos.Update()

    End Sub

    Private Sub MostrarRolesAsociados()

        Me.pnlListado.Visible = True
        Me.pnlDetalle.Visible = False
        Me.pnlRolesAsociados.Visible = True
        Me.pnlPermisosAsociados.Visible = False
        Me.updPermisos.Update()
        Me.updRoles.Update()

    End Sub

    Protected Sub dgUsuarios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgUsuarios.RowCommand

        ViewState().Add("UserName", e.CommandArgument)
        Try
            Select Case e.CommandName
                Case "Editar"
                    Me.preparaEditarUsuario()
                Case "Borrar"
                    Me.inactivarUsuario(e.CommandArgument)
                    ImgBuscar_Click(Nothing, Nothing)
                Case "Permisos"
                    Me.verPermisosAsociados()
                Case "Roles"
                    Me.verRolesAsociados()
                Case "Reseteo"
                    Me.ResetearClass(e.CommandArgument)
            End Select
        Catch ex As Exception
            Me.lblMensajeError.Text = ex.Message
            Me.lblMensajeError.Visible = True
        End Try


    End Sub

    Private Sub preparaEditarUsuario()
        Try

            Me.Estatus = Modo.Edicion

            infoUsuario.Visible = True

            ViewState().Add("Modo", Me.Estatus)

            Me.lblCrearModificar.Text = "Modificación de Usuario"

            Me.MostrarAbajo()

            Dim Usuario As New Seguridad.Usuario(ViewState().Item("UserName"))

            Me.txtApellidos.Text = Usuario.Apellidos
            Me.txtEmail.Text = Usuario.Email
            Me.txtNombres.Text = Usuario.Nombres
            Me.txtUserName.Text = Usuario.UserName
            Me.txtDepartamento.Text = Usuario.Departamento
            Me.lblCambiarClass.Text = Usuario.Cambiar_Class
            Me.lblUltLo.Text = Usuario.FechaLogin
            Me.lblIp.Text = Usuario.IP
            Me.lblUltFechaAc.Text = Usuario.UltimaFechaActualizacion.ToString()
            Me.lblUltUserAc.Text = Usuario.UltimoUsuarioActualizo.ToString()


            Try
                If Usuario.IDEntidadRecaudadora.ToString() <> "" And Usuario.IDEntidadRecaudadora.ToString() > "0" Then
                    ddlEntidad.SelectedValue = Usuario.IDEntidadRecaudadora.ToString()
                End If
            Catch ex As Exception
                Throw New Exception("La entidad recaudadora registrada para este usuario es inválida.")
            End Try

            Me.ddlEstatus.SelectedValue = Usuario.Status
            Me.txtComen.Text = Usuario.Comentario
            Me.txtUserName.Enabled = False
            Me.txtPassword.Enabled = False

            Me.reqFieldClass.Enabled = False
            Me.reqFieldClass.Visible = False

            Me.updDetalle.Update()

        Catch ex As Exception
            pnlListado.Visible = True
            Me.lblMensajeError.Text = ex.Message
            Me.lblMensajeError.Visible = True
        End Try
    End Sub

    Private Function EditarUsuario(ByVal UserName As String) As String

        Dim Usuario As New Seguridad.Usuario(UserName)

        Usuario.Nombres = Me.txtNombres.Text
        Usuario.Apellidos = Me.txtApellidos.Text

        If Me.txtPassword.Text <> "AdivinaEstePassword123" Then
            Usuario.Password = Me.txtPassword.Text
        End If

        Usuario.Email = Me.txtEmail.Text
        Usuario.Status = Me.ddlEstatus.SelectedValue
        'add fausto
        Usuario.Departamento = Me.txtDepartamento.Text
        If Me.ddlEntidad.SelectedValue = 0 Then
            Me.ddlEntidad.SelectedValue = "0"
        End If
        Usuario.IDEntidadRecaudadora = Me.ddlEntidad.SelectedValue
        Usuario.Comentario = Me.txtComen.Text

        Return Usuario.GuardarCambios(Me.UsrUserName)

    End Function

    Private Sub inactivarUsuario(ByVal IdUsuario As String)

        Dim resultado As String = Seguridad.Usuario.inactivarUsuario(IdUsuario, UsrUserName)
        If resultado <> "0" Then
            Me.lblMensajeError.Text = resultado
            Me.lblMensajeError.Visible = True
        Else
            Me.dgUsuarios.SelectedIndex = -1
        End If
        Me.MostrarArriba()
        Me.llenarDataGridUsuarios()

    End Sub

    Private Sub verRolesAsociados()
        Me.MostrarRolesAsociados()
        Me.llenarDataGridRoles()
    End Sub

    Private Sub verPermisosAsociados()
        Me.MostrarPermisosAsociados()
        Me.llenarDataGridPermisos()
    End Sub

    Private Sub ResetearClass(ByVal UserName As String)

        Me.lblMensajeError.Text = "El Nuevo Class es: " & Seguridad.Usuario.ResetearClass(UserName).Split("|")(1)
        Me.lblMensajeError.Visible = True

    End Sub

    Private Sub btnNuevoUsuario_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevoUsuario.Click

        Dim Usuario As New Seguridad.Usuario(UsrUserName)
        txtSrchNombres.Text = String.Empty
        txtSrchApellidos.Text = String.Empty
        txtSrchUserName.Text = String.Empty

        infoUsuario.Visible = False

        Me.Estatus = Modo.Nuevo
        ViewState().Add("Modo", Me.Estatus)

        Me.lblCrearModificar.Text = "Creación de Usuarios"
        Me.limpiarCampos()

        LlenarEntidad(0)

        Dim IdEnt As String = UsrIDEntidadRecaudadora
        If IdEnt <> String.Empty Then
            Me.ddlEntidad.SelectedValue = IdEnt
            ddlEntidad.Enabled = False
        Else
            Me.ddlEntidad.SelectedValue = -1
            ddlEntidad.Enabled = True
        End If

        Me.MostrarAbajo()

        Me.txtUserName.Enabled = True
        Me.txtPassword.Enabled = True

        Me.updDetalle.Update()
    End Sub

    Protected Sub ImgBuscar_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Try
            MostrarArriba()
            Me.llenarDataGridUsuarios()
            Me.updListado.Update()
        Catch ex As Exception
            lblMensaje.Visible = True
            lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        MostrarArriba()
        Me.llenarDataGridUsuarios()
        Me.updListado.Update()
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Dim Resultado As String = String.Empty
        If Me.Estatus = Modo.Nuevo Then

            Resultado = Seguridad.Usuario.nuevoUsuario(Me.txtUserName.Text, Me.txtPassword.Text, Me.txtNombres.Text, Me.txtApellidos.Text, Me.txtEmail.Text, Me.ddlEstatus.SelectedValue, Me.UsrUserName, Me.txtDepartamento.Text, Convert.ToInt32(Me.ddlEntidad.SelectedValue), Me.txtComen.Text)
            If Resultado = "0" Then
                Me.MostrarArriba()
            Else
                Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
                Me.lblMensajeDeError.Visible = True
            End If

        ElseIf Me.Estatus = Modo.Edicion Then

            Resultado = Me.EditarUsuario(ViewState().Item("UserName"))

        End If

        If Resultado = "0" Then
            Me.txtSrchUserName.Text = Me.txtUserName.Text
            MostrarArriba()
            Me.llenarDataGridUsuarios()
            Me.updListado.Update()

        Else
            Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
            Me.lblMensajeDeError.Visible = True
        End If

    End Sub

    Protected Sub btnCancelarRole_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.pnlRolesAsociados.Visible = False
        Me.updRoles.Update()
    End Sub

    Protected Sub btnCancelarPermiso_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.pnlPermisosAsociados.Visible = False
        Me.updPermisos.Update()
    End Sub

    Protected Sub dgRoles_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Dim Role As String = CType(e.CommandArgument, String)

        Dim Usuario As New Seguridad.Usuario(ViewState().Item("UserName"))
        Dim resultado As String = Usuario.RemoverRole(Role, Me.UsrUserName)

        If resultado <> "0" Then
            Me.lblErroAsocRoles.Text = resultado & " Error"
            Me.lblErroAsocRoles.Visible = True
        End If

        Me.llenarDataGridRoles()
    End Sub

    Protected Sub dgPermisos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Dim Permiso As String = CType(e.CommandArgument, String)

        Dim Usuario As New Seguridad.Usuario(ViewState().Item("UserName"))
        Dim resultado As String = Usuario.RemoverPermiso(Permiso, Me.UsrUserName)

        If resultado <> "0" Then
            Me.lblErrorPermAsoc.Text = resultado & " Error"
            Me.lblErrorPermAsoc.Visible = True
        End If

        Me.llenarDataGridPermisos()
    End Sub

End Class
