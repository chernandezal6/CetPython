
Partial Class Certificaciones_SolicitudCertificacion
    Inherits BasePage

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            CargarTipoCertificaciones("", "")
        End If

    End Sub

    Sub CargarTipoCertificaciones(ByVal RNC As String, ByVal Usuario As String)
        If RNC = String.Empty Then
            RNC = UsrRNC
        End If

        If Usuario = String.Empty Then
            Usuario = UsrUserName

        End If

        gvSolicitud.DataSource = SuirPlus.Empresas.Certificaciones.GetInfoSolicitud(RNC, Usuario)
        gvSolicitud.DataBind()
        pnlInfo.Visible = False
        pnlCertificaciones.Visible = True


        btnSiguiente.Enabled = False
        gvSolicitud.Columns(1).Visible = False

    End Sub

    Protected Sub btnSiguiente_Click(sender As Object, e As EventArgs) Handles btnSiguiente.Click
        If hdTipoCertificacion.Value <> String.Empty Then
            Response.Redirect("ConfirmarDatos.aspx?ID=" + hdTipoCertificacion.Value)
        End If
    End Sub

    Protected Sub rdTipo_CheckedChanged(sender As Object, e As EventArgs)
        gvSolicitud.Columns(1).Visible = True

        For Each oldrow As GridViewRow In gvSolicitud.Rows
            DirectCast(oldrow.FindControl("rdCertificacion"), RadioButton).Checked = False
        Next

        'Set the new selected row
        Dim rb As RadioButton = DirectCast(sender, RadioButton)
        Dim row As GridViewRow = DirectCast(rb.NamingContainer, GridViewRow)
        DirectCast(row.FindControl("rdCertificacion"), RadioButton).Checked = True

        For i As Integer = 0 To gvSolicitud.Rows.Count - 1
            If CType(gvSolicitud.Rows(i).FindControl("rdCertificacion"), CheckBox).Checked = True Then
                hdTipoCertificacion.Value = gvSolicitud.Rows.Item(i).Cells(1).Text
            End If
        Next

        gvSolicitud.Columns(1).Visible = False

        If hdTipoCertificacion.Value <> String.Empty Then
            btnSiguiente.Enabled = True
        End If



    End Sub

    Protected Sub btnRnc_Click(sender As Object, e As EventArgs) Handles btnRnc.Click
        If txtRnc.Text = String.Empty Then
            lblMensaje.Text = "Introduzca el RNC"
            Return

        Else
            CargarTipoCertificaciones(txtRnc.Text, UsrUserName)
            pnlCertificaciones.Visible = True
        End If
    End Sub
End Class
