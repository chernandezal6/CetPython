Imports SuirPlus
Partial Class Legal_consSolicitudFacilidadPago
    Inherits BasePage
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            Dim NroSol As Nullable(Of Integer) = Nothing
            Dim RegPat As Nullable(Of Integer) = Nothing
            Dim Status As String = String.Empty

            If ddlStatus.SelectedValue <> "T" Then
                Status = ddlStatus.SelectedValue
            End If

            If Not txtSolicitud.Text = String.Empty Then
                NroSol = Me.txtSolicitud.Text
            End If

            If Not Me.txtRNC.Text = String.Empty Then
                Dim em As New Empresas.Empleador(Me.txtRNC.Text)
                RegPat = em.RegistroPatronal
            End If

            Dim sol As System.Data.DataTable = Legal.LeyFacilidadesPago.getSolicitudFacilidadesPago(NroSol, RegPat, Me.txtRazonSocial.Text, txtDesde.Text, txtHasta.Text, Status)

            If sol.Rows.Count > 0 Then
                Me.gvData.DataSource = sol
                Me.gvData.DataBind()
                Me.tblData.Visible = True
            Else
                Me.gvData.DataSource = Nothing
                Me.gvData.DataBind()
                Me.lblMensaje.Text = "No se encontró información para el criterio especificado. <br /> Trate nuevamente."
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.txtSolicitud.Text = String.Empty
        Me.txtRNC.Text = String.Empty
        Me.txtRazonSocial.Text = String.Empty
        Me.txtDesde.Text = String.Empty
        Me.txtHasta.Text = String.Empty
        Me.lblMensaje.Text = String.Empty
        Me.gvData.DataSource = Nothing
        Me.gvData.DataBind()
    End Sub
End Class
