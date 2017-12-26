Imports Suirplus
Partial Class Seguridad_segPermisos
    Inherits BasePage

    Private Estatus As Modo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not Page.IsPostBack Then
            Me.CargaInicial()
        Else
            Me.Estatus = ViewState().Item("Modo")

        End If

    End Sub

    Private Sub CargaInicial()
        Me.llenarDataGridPermisos()

        Me.ddlSeccion.DataTextField = "seccion_des"
        Me.ddlSeccion.DataValueField = "id_seccion"
        Me.ddlSeccion.DataSource = Seguridad.Seccion.getSecciones(-1)
        Me.ddlSeccion.DataBind()

    End Sub

    Private Sub llenarDataGridPermisos()
        Me.dgPermisos.DataSource = Seguridad.Permiso.getPermisos(-1)
        Me.dgPermisos.DataBind()
    End Sub

    Private Sub llenarDataGridUsuarios()

        Dim IDPermiso As Int32 = viewstate().Item("IDPermiso")

        Dim Permiso As New Seguridad.Permiso(IDPermiso)
        Me.dgUsuarios.DataSource = Permiso.getUsuariosTienenPermiso
        Me.dgUsuarios.DataBind()
        Me.dgUsuarios.Visible = True

        Me.lblUsuariosHeader.Text = "Usuarios con el Permiso: " & Permiso.Descripcion

        Me.btAgregarUsuario.Attributes.Clear()
        Me.btAgregarUsuario.Attributes.Add("onclick", "mWindow = window.open('popUsuarios.aspx?IDPermiso=" & Permiso.ID_Permiso & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=450,height=500,scrollbars=yes');")

    End Sub
    Private Sub LlenarDataGridRoles()

        Dim IDPermiso As Int32 = viewstate().Item("IDPermiso")
        Dim Permiso As New Seguridad.Permiso(IDPermiso)

        Me.dgRoles.DataSource = Permiso.getRolesTienenPermiso
        Me.dgRoles.DataBind()
        Me.dgRoles.Visible = True

        Me.lblRolesHeader.Text = "Roles con el Permiso: " & Permiso.Descripcion

        Me.btAgregarRole.Attributes.Clear()
        Me.btAgregarRole.Attributes.Add("onclick", "mWindow = window.open('popRoles.aspx?IDPermiso=" & Permiso.ID_Permiso & "&UsuarioResponsable=" & Me.UsrUserName & "',null,'width=250,height=500,scrollbars=yes');")


    End Sub

    Private Sub limpiarCampos()
        Me.txtDescripcion.Text = ""
        Me.txtURL.Text = ""
        Me.txtOrdenMenu.Text = ""
    End Sub

    Private Sub MostrarArriba()
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlRolesAsociados.Visible = False
        Me.pnlUsuariosAsociados.Visible = False
        Me.llenarDataGridPermisos()
        Me.updDetalle.Update()
        Me.updPermiso.Update()
        Me.updPermisos.Update()
        Me.updRoles.Update()
    End Sub
    Private Sub MostrarAbajo()

        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False
        Me.pnlRolesAsociados.Visible = False
        Me.pnlUsuariosAsociados.Visible = False

        Me.ddlTipoPermiso.Enabled = True

        Me.valSum.Visible = True
        Me.reqFieldDescripcion.Visible = True
        Me.reqFieldURL.Visible = True

        Me.limpiarCampos()
        Me.updDetalle.Update()

    End Sub
    Private Sub MostrarUsuariosAsociados()
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlRolesAsociados.Visible = False
        Me.pnlUsuariosAsociados.Visible = True
        Me.updPermisos.Update()
        Me.updRoles.Update()
    End Sub
    Private Sub MostrarRolesAsociados()
        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True
        Me.pnlRolesAsociados.Visible = True
        Me.pnlUsuariosAsociados.Visible = False
        Me.updPermisos.Update()
        Me.updRoles.Update()
    End Sub

    Private Sub btCancelarEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCancelarEdit.Click
        Me.MostrarArriba()
    End Sub

    Private Sub btnNuevoPermiso_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevoPermiso.Click

        Me.lblCrearModificar.Text = "Creación de Permiso"
        Me.Estatus = Modo.Nuevo
        viewstate().Add("Modo", Me.Estatus)
        Me.MostrarAbajo()

    End Sub

    Private Sub btAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btAceptar.Click

        Dim Resultado As String = String.Empty
        If Me.Estatus = Modo.Nuevo Then

            Resultado = SuirPlus.Seguridad.Permiso.nuevoPermiso(Me.txtDescripcion.Text, Me.ddlSeccion.SelectedValue, Me.txtOrdenMenu.Text, Me.txtURL.Text, Me.UsrUserName, Me.ddlTipoPermiso.SelectedValue, ddlCuota.SelectedValue)
            If Resultado = "0" Then
                Me.MostrarArriba()
            Else
                Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
                Me.lblMensajeDeError.Visible = True
            End If

        ElseIf Me.Estatus = Modo.Edicion Then

            Resultado = Me.EditarPermiso(viewstate().Item("IDPermiso"))

        End If

        If Resultado = "0" Then
            Me.MostrarArriba()
        Else
            Me.lblMensajeDeError.Text = SuirPlus.Utilitarios.Utils.sacarMensajeDeError(Resultado)
            Me.lblMensajeDeError.Visible = True
        End If

    End Sub

    Private Sub prepararEditarPermiso()

        Me.Estatus = Modo.Edicion

        ViewState().Add("Modo", Me.Estatus)

        Me.lblCrearModificar.Text = "Modificación de Permiso"

        Me.MostrarAbajo()

        Dim Permiso As New Seguridad.Permiso(viewstate().Item("IDPermiso"))

        Me.txtDescripcion.Text = Permiso.Descripcion
        Me.ddlEstatus.SelectedValue = Permiso.Status
        Me.ddlTipoPermiso.SelectedValue = Permiso.Tipo
        Me.ddlSeccion.SelectedValue = Permiso.Seccion
        Me.txtOrdenMenu.Text = Permiso.OrdenMenu
        Me.txtURL.Text = Permiso.URL
        Me.ddlCuota.SelectedValue = IIf(Permiso.MarcaCuota = Nothing, "N", Permiso.MarcaCuota)
        Me.updDetalle.Update()
    End Sub

    Private Function EditarPermiso(ByVal IDPermiso As Int32) As String

        Dim Permiso As New Seguridad.Permiso(IDPermiso)

        Permiso.URL = Me.txtURL.Text
        Permiso.Status = Me.ddlEstatus.SelectedValue
        Permiso.Tipo = Me.ddlTipoPermiso.SelectedValue
        Permiso.Descripcion = Me.txtDescripcion.Text
        Permiso.Seccion = Me.ddlSeccion.SelectedValue
        Permiso.OrdenMenu = Me.txtOrdenMenu.Text
        Permiso.MarcaCuota = Me.ddlCuota.SelectedValue

        Return Permiso.GuardarCambios(Me.UsrUserName)

    End Function

    Private Sub BorrarPermiso(ByVal IDPermiso As Int32)

        Dim resultado As String = Seguridad.Permiso.borrarPermiso(IDPermiso)
        If resultado <> "0" Then
            Me.lblErrorPermisos.Text = resultado
            Me.lblErrorPermisos.Visible = True
        End If

        Me.MostrarArriba()

    End Sub

    Private Sub verUsuarios()
        Me.MostrarUsuariosAsociados()
        Me.llenarDataGridUsuarios()
    End Sub

    Private Sub verRoles()
        Me.MostrarRolesAsociados()
        Me.LlenarDataGridRoles()
    End Sub

    Private Sub btCancelarUsr_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCancelarUsr.Click
        Me.MostrarArriba()
    End Sub

    Private Sub btCancelarPerm_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCancelarPerm.Click
        Me.MostrarArriba()
    End Sub

    Protected Sub dgRoles_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgRoles.RowCommand
        Dim Role As String = Convert.ToString(e.CommandArgument)

        Dim Permiso As New Seguridad.Permiso(ViewState().Item("IDPermiso"))
        Dim resultado As String = Permiso.RemoverRole(Role, Me.UsrUserName)

        If resultado <> "0" Then
            Me.lblErroAsocRoles.Text = resultado & " Error"
            Me.lblErroAsocRoles.Visible = True
        End If

        Me.LlenarDataGridRoles()
    End Sub

    Protected Sub dgUsuarios_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgUsuarios.RowCommand
        Dim Usuario As String = Convert.ToString(e.CommandArgument)

        Dim Permiso As New Seguridad.Permiso(ViewState().Item("IDPermiso"))
        Dim Resultado As String = Permiso.RemoverUsuario(Usuario, Me.UsrUserName)

        If Resultado <> "0" Then
            Me.lblErrorUsrAsoc.Text = Resultado
            Me.lblErrorUsrAsoc.Visible = True
        End If

        Me.llenarDataGridUsuarios()
    End Sub

    Protected Sub dgPermisos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles dgPermisos.RowCommand
        Dim IDPermiso As Int32 = Convert.ToInt32(e.CommandArgument)

        ViewState().Add("IDPermiso", IDPermiso)

        Select Case e.CommandName
            Case "Editar"
                Me.prepararEditarPermiso()
            Case "Borrar"
                Me.BorrarPermiso(IDPermiso)
            Case "Usuarios"
                Me.verUsuarios()
            Case "Roles"
                Me.verRoles()
        End Select
    End Sub

End Class
