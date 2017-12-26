Imports SuirPlus
Imports System.Data

Partial Class Reportes_RecaudoIbanking
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

            dt = Empresas.Consultas.get_RecIbanking(desde, hasta)

            If dt.Rows.Count > 0 Then
                Me.pnlRecaudoIbanking.Visible = True
                Me.lblMsg.Visible = False
                rvRecaudoIbanking.LocalReport.DataSources.Clear()
                rvRecaudoIbanking.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("RecaudoIbanking_ds", dt))
                rvRecaudoIbanking.LocalReport.Refresh()
            Else
                Me.pnlRecaudoIbanking.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe data para el rango fechas seleccionado"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlRecaudoIbanking.Visible = False
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.Response.Redirect("RecaudoIbanking.aspx")
    End Sub
End Class
