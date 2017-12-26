Imports Suirplus
Partial Class Seguridad_segRoles
    Inherits BasePage

    Private Estatus As Modo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.CargaInicial()
        Else
            Me.Estatus = viewstate().Item("Modo")
        End If

    End Sub

    Private Sub CargaInicial()
        Me.llenarDataGridRoles()
    End Sub

    Private Sub llenarDataGridRoles()

        Me.dgRoles.DataSource = SuirPlus.Seguridad.Role.getRoles(-1)
        Me.dgRoles.DataBind()

    End Sub
    Private Sub llenarDataGridUsuarios()

        Dim IDRole As Int32 = viewstate().Item("IDRole")
        Dim Role As New Seguridad.Role(IDRole)
        Me.dgUsuarios.DataSource = Role.getUsuariosTienenRole
        Me.dgUsuarios.DataBind()
        Me.dgUsuarios.Visible = True

        Me.lblUsuariosHeader.Text = "Usuarios asociados al Role: " & Role.Descripcion

        Me.btnAgregarUsuario.Attributes.Clear()
        Me.btnAgregarUsuario.Attributes.Add("onclick", "mWindow = window.open('popUsuarios.aspx?IDRole=" & Role.ID_Role & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=450,height=450,scrollbars=yes');")

    End Sub
    Private Sub llenarDataGridPermisos()

        Dim IDRole As Int32 = viewstate().Item("IDRole")
        Dim Role As New Seguridad.Role(IDRole)
        Me.dgPermisos.DataSource = Role.getPermisosTienenRole
        Me.dgPermisos.DataBind()
        Me.dgPermisos.Visible = True

        Me.lblRolesHeader.Text = "Permisos asociados al Role: " & Role.Descripcion

        Me.btnAgregarPermiso.Attributes.Clear()
        Me.btnAgregarPermiso.Attributes.Add("onclick", "mWindow = window.open('popPermisos.aspx?IDRole=" & Role.ID_Role & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=600,height=450,scrollbars=yes');")

    End Sub

    Private Sub limpiarCampos()
        Me.txtDescripcion.Text = ""
    End Sub

    Private Sub MostrarArriba()

        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlUsuariosAsociados.Visible = False
        Me.pnlPermisosAsociados.Visible = False
        Me.llenarDataGridRoles()

        Me.updListado.Update()
        Me.updDetalle.Update()
        Me.updUsuario.Update()
        Me.updPermisos.Update()

    End Sub
    Private Sub MostrarAbajo()

        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False
        Me.pnlUsuariosAsociados.Visible = False
        Me.pnlPermisosAsociados.Visible = False

        If Me.Estatus = Modo.Nuevo Then
            Me.ddlEstatus.Enabled = False
        Else
            Me.ddlEstatus.Enabled = True
        End If

        Me.valSum.Visible = True
        Me.reqFieldDescripcion.Visible = True

        Me.limpiarCampos()

        Me.updListado.Update()
        Me.updDetalle.Update()
        Me.updUsuario.Update()
        Me.updPermisos.Update()

    End Sub
    Private Sub MostrarUsuariosAsociados()

        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlUsuariosAsociados.Visible = True
        Me.pnlPermisosAsociados.Visible = False

        Me.updListado.Update()
        Me.updDetalle.Update()
        Me.updUsuario.Update()
        Me.updPermisos.Update()

    End Sub

    Private Sub MostrarPermisosAsociados()

        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlUsuariosAsociados.Visible = False
        Me.pnlPermisosAsociados.Visible = True

        Me.updListado.Update()
        Me.updDetalle.Update()
        Me.updUsuario.Update()
        Me.updPermisos.Update()

    End Sub

    Private Sub btnNuevoRole_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevoRole.Click

        Me.Estatus = Modo.Nuevo
        Me.lblCrearModificar.Text = "Creación de Role"

        viewstate().Add("Modo", Me.Estatus)
        Me.MostrarAbajo()

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.MostrarArriba()
    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Dim Resultado As String = String.Empty
        If Me.Estatus = Modo.Nuevo Then

            Resultado = SuirPlus.Seguridad.Role.nuevoRole(Me.txtDescripcion.Text, Me.UsrUserName)
            If Resultado = "0" Then
                Me.MostrarArriba()
            Else
                Me.lblMensajeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
                Me.lblMensajeError.Visible = True
            End If

        ElseIf Me.Estatus = Modo.Edicion Then

            Resultado = Me.EditarRole(ViewState().Item("IDRole"))

        End If

        If Resultado = "0" Then
            Me.MostrarArriba()
        Else
            Me.lblMensajeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
            Me.lblMensajeError.Visible = True
        End If

    End Sub

    Private Sub prepararEditarRole()

        Me.Estatus = Modo.Edicion
        Me.lblCrearModificar.Text = "Modificación de Role"

        viewstate().Add("Modo", Me.Estatus)

        Me.MostrarAbajo()

        Dim Role As New Seguridad.Role(viewstate().Item("IDRole"))

        Me.txtDescripcion.Text = Role.Descripcion
        Me.ddlEstatus.SelectedValue = Role.Status

    End Sub
    Private Function EditarRole(ByVal IDRole As Int32) As String

        Dim Role As New Seguridad.Role(IDRole)

        Role.Descripcion = Me.txtDescripcion.Text
        Role.Status = Me.ddlEstatus.SelectedValue

        Return Role.GuardarCambios(Me.UsrUserName)

    End Function

    Private Sub BorrarRole(ByVal IDRole As Int32)

        Dim resultado As String = Seguridad.Role.borrarRole(IDRole)
        Me.MostrarArriba()

        If resultado <> "0" Then
            Me.lblMensajeError.Text = resultado
            Me.lblMensajeError.Visible = True
        End If

    End Sub
    Private Sub verUsuarios()

        Me.MostrarUsuariosAsociados()
        Me.llenarDataGridUsuarios()

    End Sub
    Private Sub verPermisos()
        Me.MostrarPermisosAsociados()
        Me.llenarDataGridPermisos()
    End Sub

    Private Sub btnCancelarUsr_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarUsr.Click
        Me.MostrarArriba()
    End Sub
    Private Sub btnCancelarRole_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarRole.Click
        Me.MostrarArriba()
    End Sub

    Protected Sub dgRoles_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgRoles.RowCommand
        Dim IDRole As Int32 = CType(e.CommandArgument, Int32)

        ViewState().Add("IDRole", IDRole)

        Select Case e.CommandName
            Case "Editar"
                Me.prepararEditarRole()
            Case "Borrar"
                Me.BorrarRole(IDRole)
            Case "Usuarios"
                Me.verUsuarios()
            Case "Permisos"
                Me.verPermisos()
        End Select
    End Sub

    Protected Sub dgUsuarios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgUsuarios.RowCommand
        Dim Usuario As String = CType(e.CommandArgument, String)

        Dim Role As New Seguridad.Role(ViewState().Item("IDRole"))
        Dim Resultado As String = Role.RemoverUsuario(Usuario, Me.UsrUserName)

        If Resultado <> "0" Then
            Me.lblErrorUsrAsoc.Text = Resultado
            Me.lblErrorUsrAsoc.Visible = True
        End If

        Me.llenarDataGridUsuarios()
    End Sub

    Protected Sub dgPermisos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgPermisos.RowCommand
        Dim Permiso As String = CType(e.CommandArgument, String)

        Dim Role As New Seguridad.Role(ViewState().Item("IDRole"))
        Dim resultado As String = Role.RemoverPermiso(Permiso, Me.UsrUserName)

        If resultado <> "0" Then
            Me.lblErrorPermAsoc.Text = resultado & " Error"
            Me.lblErrorPermAsoc.Visible = True
        End If

        Me.llenarDataGridPermisos()
    End Sub

End Class