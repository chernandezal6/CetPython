Imports System.Data
Imports SuirPlus
Partial Class Legal_consEstatusNotLey188
    Inherits BasePage

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Dim regPat As String = Utilitarios.TSS.getRegistroPatronal(txtRNC.Text)

        'Si es un empleador inválido
        If regPat.IndexOf("|") > 0 Then
            Me.gvNotificaciones.DataSource = Nothing
            Me.gvNotificaciones.DataBind()
            Me.lblMensajeError.Text = "Cédula o Registo Patronal Inválido. Trate Nuevamente."
            Me.lblMensajeError.Visible = True
            Return
        End If

        If Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(Nothing, regPat, Nothing, Nothing, Nothing, "A").Rows.Count > 0 Then
            Me.lblMensajeError.Visible = False
            Dim dt As DataTable
            dt = Legal.LeyFacilidadesPago.getStatusRecalculo(Me.txtRNC.Text)

            Me.gvNotificaciones.DataSource = dt
            Me.gvNotificaciones.DataBind()
        Else
            Me.lblMensajeError.Text = "Este empleador no se a Acogido a la Ley 189-07 aun."
            Me.lblMensajeError.Visible = True
        End If
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("consEstatusNotLey189.aspx")
    End Sub
End Class
