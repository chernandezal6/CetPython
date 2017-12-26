Imports SuirPlus
Partial Class Seguridad_segRolCertificaciones
    Inherits BasePage

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        If Not Page.IsPostBack Then
            Me.CargarRoles()
            Me.CargarCertificaciones()
            lblMensaje.Text = String.Empty
        End If

    End Sub

    Private Sub CargarRoles()
        Me.ddlRoles.DataTextField = "roles_des"
        Me.ddlRoles.DataValueField = "id_role"
        Me.ddlRoles.DataSource = Seguridad.Role.getRoles(-1)
        Me.ddlRoles.DataBind()
        Me.ddlRoles.Items.Insert(0, New ListItem("Seleccione", "-1"))
    End Sub

    Private Sub CargarCertificaciones()
        Me.ddlCertificacion.DataTextField = "tipo_certificacion_des"
        Me.ddlCertificacion.DataValueField = "id_tipo_certificacion"
        Me.ddlCertificacion.DataSource = Empresas.Certificaciones.getTipoCertificaciones()
        Me.ddlCertificacion.DataBind()
        Me.ddlCertificacion.Items.Insert(0, New ListItem("Seleccione", "-1"))
    End Sub

    Private Sub CargarCertificacionPorRol()
        Me.ddlCertificacion.DataTextField = "tipo_certificacion_des"
        Me.ddlCertificacion.DataValueField = "id_tipo_certificacion"
        Me.ddlCertificacion.DataSource = Empresas.Certificaciones.getTipoCertificacionesPorRol(ddlRoles.SelectedValue)
        Me.ddlCertificacion.DataBind()
        Me.ddlCertificacion.Items.Insert(0, New ListItem("Seleccione", "-1"))
    End Sub

    Private Sub btnAsignar_Click(sender As Object, e As EventArgs) Handles btnAsignar.Click

        Dim Resultado As String = String.Empty

        If (Me.ddlRoles.SelectedValue = "-1") Or (Me.ddlCertificacion.SelectedValue = "-1") Then
            lblerror.Text = "Ambos valores son requeridos"
            lblerror.Visible = True
            Return
        Else

            Resultado = SuirPlus.Seguridad.Role.InsertarRolCertificacion(Me.ddlRoles.SelectedValue, Me.ddlCertificacion.SelectedValue, UsrUserName)

            If Resultado = "0" Then
                lblMensaje.Text = "Rol asignado satisfactoriamente."
                lblMensaje.Visible = True
                lblerror.Text = String.Empty
                lblerror.Visible = False
                btnAsignar.Enabled = False
            Else
                lblerror.Text = Split(Resultado, "|")(1)
                lblerror.Visible = True
                btnAsignar.Enabled = False
                Return
            End If
        End If
    End Sub

    Private Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        Response.Redirect("segRolCertificaciones.aspx")
    End Sub

    Private Sub ddlCertificaciones_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCertificacion.SelectedIndexChanged
        lblerror.Text = String.Empty
        lblerror.Visible = False
        Return
    End Sub

    Private Sub ddlRoles_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlRoles.SelectedIndexChanged
        CargarCertificacionPorRol()
        lblerror.Text = String.Empty
        lblerror.Visible = False
        Return
    End Sub
End Class
