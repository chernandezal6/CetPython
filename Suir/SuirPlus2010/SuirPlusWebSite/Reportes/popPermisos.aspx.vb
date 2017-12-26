Imports SuirPlus
Partial Class Seguridad_popPermisos
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.lblIDRoles.Text = Request("IDRole")
            Me.lblUserName.Text = Request("UserName")
            Me.lblUsrResponsable.Text = Request("UsuarioResponsable")
            Me.CargaInicial()
        End If

    End Sub

    Private Sub CargaInicial()
        If (Me.lblUserName.Text = "") And (Me.lblIDRoles.Text = "") Then
            Exit Sub
        End If

        If (Me.lblIDRoles.Text = "") Then
            ' Es un Usuario
            Me.dgPermisos.DataSource = Seguridad.Permiso.getPermisosNoTieneUsuario(Me.lblUserName.Text)
            Me.dgPermisos.DataBind()
        ElseIf (Me.lblUserName.Text = "") Then
            ' Es un Role
            Me.dgPermisos.DataSource = Seguridad.Permiso.getPermisosNoTieneRole(Me.lblIDRoles.Text)
            Me.dgPermisos.DataBind()
        End If

    End Sub

    Private Function AgregarPermiso(ByVal IDPermiso As Int32) As String
        If (Me.lblUserName.Text = "") And (Me.lblIDRoles.Text = "") Then
            Return String.Empty
        End If

        Dim Resultado As String = String.Empty

        If (Me.lblIDRoles.Text = "") Then

            ' Es un Usuario
            Dim Usr As New Seguridad.Usuario(Me.lblUserName.Text)
            Resultado = Usr.AgregarPermiso(IDPermiso, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Me.lblUserName.Text & " | " & Resultado
            End If

        ElseIf (Me.lblUserName.Text = "") Then

            ' Es un Role
            Dim Rol As New Seguridad.Role(Me.lblIDRoles.Text)
            Resultado = Rol.AgregarPermiso(IDPermiso, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Resultado
            End If

        End If

        Return Resultado
    End Function

    Private Sub btCerrar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCerrar.Click
        Me.ClientScript.RegisterStartupScript(Me.GetType, "_cerrar", "<script language='javascript'> window.close();</script>")
    End Sub

    Private Sub btAgregar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btAgregar.Click
        Dim dgItem As GridViewRow

        For Each dgItem In Me.dgPermisos.Rows

            Dim chkBox As CheckBox = CType(dgItem.Cells(0).Controls(1), System.Web.UI.WebControls.CheckBox)

            If chkBox.Checked Then
                Dim lbl As Label = CType(dgItem.FindControl("lblID"), Label)
                Dim Resultado As String = Me.AgregarPermiso(lbl.Text)

                If Resultado <> "0" Then
                    Me.lblMensajeError.Text = Resultado
                    Me.lblMensajeError.Visible = True
                    Exit Sub
                End If

            End If

        Next

        Me.CargaInicial()
    End Sub

End Class
