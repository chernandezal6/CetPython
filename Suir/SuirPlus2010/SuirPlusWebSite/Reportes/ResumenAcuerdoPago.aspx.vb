Imports SuirPlus
Imports System.Data

Partial Class Reportes_ResumenAcuerdoPago
    Inherits BasePage


    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Try
            Me.lblMsg.Text = String.Empty
            If (Me.txtFechaDesde.Text.Length = 10) And (Me.txtFechaHasta.Text.Length = 10) Then

                getData(Me.txtFechaDesde.Text, Me.txtFechaHasta.Text)
            Else
                lblMsg.Visible = True
                Me.lblMsg.Text = "Error en fechas"
            End If

        Catch ex As Exception
            lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try



    End Sub

    Protected Sub getData(ByVal desde As String, ByVal hasta As String)
        Dim dt As New DataTable
        Try
            dt = Empresas.Consultas.get_Resumen_AcuerdoPago(desde, hasta)

            If dt.Rows.Count > 0 Then
                Me.pnlResumenAcuerdoPago.Visible = True
                Me.lblMsg.Visible = False
                rvResumenAcuerdoPago.LocalReport.DataSources.Clear()
                rvResumenAcuerdoPago.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("ResumenAcuerdoPago_ds", dt))
                rvResumenAcuerdoPago.LocalReport.Refresh()
            Else
                Me.pnlResumenAcuerdoPago.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para el rango fechas seleccionado"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlResumenAcuerdoPago.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("ResumenAcuerdoPago.aspx")
    End Sub
End Class
