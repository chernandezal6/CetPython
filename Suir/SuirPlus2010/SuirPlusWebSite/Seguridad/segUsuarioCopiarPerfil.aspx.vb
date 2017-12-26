Imports SuirPlus

Partial Class Seguridad_segCopiar
    Inherits BasePage

    Private Sub llenarDataGrids()
        Try
            Dim Usuario As New Seguridad.Usuario(tbUsuarioPadre.Text)

            Me.gvRoles.DataSource = Usuario.getRoles
            Me.gvRoles.DataBind()

            Me.gvPermisos.DataSource = Usuario.getPermisos()
            Me.gvPermisos.DataBind()

            Me.dUsuarioHijo.Visible = True
            Me.lblNombreUsuerPadre.Text = Usuario.NombreCompleto
        Catch ex As Exception
            Dim s As String()
            s = ex.Message.Split("|")
            lblMensaje.Text = "Error: " & s(0)
            lblMensaje.ForeColor = Drawing.Color.Red

            Me.gvRoles.DataBind()
            Me.gvPermisos.DataBind()
            Me.dUsuarioHijo.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub copiarPermisos()
        Try
            Dim UsuarioHijo As New Seguridad.Usuario(tbNombreUsuarioHijo.Text)
            Dim UsuarioPadre As New Seguridad.Usuario(tbUsuarioPadre.Text)

            'remover permisos
            For Each dr As System.Data.DataRow In UsuarioHijo.getPermisos().Rows
                UsuarioHijo.RemoverPermiso(Convert.ToInt32(dr("id_permiso")), UsuarioHijo.UserName)
            Next

            'remover roles
            For Each dr As System.Data.DataRow In UsuarioHijo.getRoles().Rows
                UsuarioHijo.RemoverRole(Convert.ToInt32(dr("id_role")), UsuarioHijo.UserName)
            Next

            'Copiar los permisos del usuario origial
            For Each dr As System.Data.DataRow In UsuarioPadre.getPermisos().Rows
                UsuarioHijo.AgregarPermiso(Convert.ToInt32(dr("id_permiso")), UsuarioHijo.UserName)
            Next

            'Copiar los roels del usuario origial
            For Each dr As System.Data.DataRow In UsuarioPadre.getRoles().Rows
                UsuarioHijo.AgregarRole(Convert.ToInt32(dr("id_role")), UsuarioHijo.UserName)
            Next

            lblMensaje.ForeColor = Drawing.Color.Green
            lblMensaje.Text = "Operación realizada con exito, los permisos y roles de " & _
                                UsuarioPadre.UserName & " fueron copiados a " & UsuarioHijo.UserName

            lblMensaje.ForeColor = Drawing.Color.Red
        Catch ex As Exception
            Dim s As String()
            s = ex.Message.Split("|")
            lblMensaje.Text = "Error: " & s(0)
            lblMensaje.ForeColor = Drawing.Color.Red

            Me.gvRoles.DataBind()
            Me.gvPermisos.DataBind()
            Me.dUsuarioHijo.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnBuscarUsuario_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscarUsuario.Click
        lblMensaje.Text = ""
        llenarDataGrids()
    End Sub

    Protected Sub gvPermisos_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gvPermisos.PageIndexChanging
        gvPermisos.PageIndex = e.NewPageIndex
        llenarDataGrids()
    End Sub

    Protected Sub btAsigPR_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        lblMensaje.Text = ""
        If Not tbUsuarioPadre.Text = tbNombreUsuarioHijo.Text Then
            copiarPermisos()
        Else
            lblMensaje.Text = "Error: el usuario no puede ser el mismo."
            lblMensaje.ForeColor = Drawing.Color.Red
        End If
    End Sub
End Class
