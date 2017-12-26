Imports Suirplus
Partial Class Seguridad_popUsuarios
    Inherits System.Web.UI.Page

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.lblIDRoles.Text = Request("IDRole")
            Me.lblIDPermiso.Text = Request("IDPermiso")
            Me.lblUsrResponsable.Text = Request("UsuarioResponsable")
            Me.CargaInicial()
        End If

    End Sub

    Private Sub CargaInicial()
        If (Me.lblIDPermiso.Text = "") And (Me.lblIDRoles.Text = "") Then
            Exit Sub
        End If

        If (Me.lblIDRoles.Text = "") Then
            ' Es un Permiso
            Me.dgUsuarios.DataSource = Seguridad.Usuario.getUsuariosNoTienenPermiso(Me.lblIDPermiso.Text)
            Me.dgUsuarios.DataBind()
        ElseIf (Me.lblIDPermiso.Text = "") Then
            ' Es un Role
            Me.dgUsuarios.DataSource = Seguridad.Usuario.getUsuariosNoTienenRole(Me.lblIDRoles.Text)
            Me.dgUsuarios.DataBind()
        End If

    End Sub

    Private Function AgregarUsuario(ByVal UserName As String) As String
        If (Me.lblIDPermiso.Text = "") And (Me.lblIDRoles.Text = "") Then
            Return String.Empty
        End If

        Dim Resultado As String = String.Empty

        If (Me.lblIDRoles.Text = "") Then
            ' Es un Permiso
            Dim Per As New Seguridad.Permiso(Me.lblIDPermiso.Text)
            Resultado = Per.AgregarUsuario(UserName, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Me.lblIDPermiso.Text & " | " & Resultado
            End If

        ElseIf (Me.lblIDPermiso.Text = "") Then
            ' Es un Role
            Dim Rol As New Seguridad.Role(Me.lblIDRoles.Text)
            Resultado = Rol.AgregarUsuario(UserName, Me.lblUsrResponsable.Text)

            If Resultado <> "0" Then
                Return Resultado
            End If

        End If

        Return Resultado
    End Function

    Private Sub btCerrar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btCerrar.Click
        Me.ClientScript.RegisterStartupScript(Me.GetType(), "_cerrar", "<script language='javascript'> window.close();</script>")
    End Sub

    Private Sub btAgregar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btAgregar.Click
        Dim dgItem As GridViewRow

        For Each dgItem In Me.dgUsuarios.Rows

            Dim chkBox As CheckBox = CType(dgItem.Cells(0).Controls(1), System.Web.UI.WebControls.CheckBox)

            If chkBox.Checked Then
                Dim lbl As Label = CType(dgItem.FindControl("lblID"), Label)
                Dim Resultado As String = Me.AgregarUsuario(lbl.Text)

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
