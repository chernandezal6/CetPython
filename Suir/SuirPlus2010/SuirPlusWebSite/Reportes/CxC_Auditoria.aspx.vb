Imports SuirPlus
Imports System.Data

Partial Class Reportes_CxC_Auditoria
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            getData()
        End If

    End Sub

    Protected Sub getData()
        Dim dt As New DataTable
        Try

            dt = Empresas.Consultas.get_CxC_auditoria()

            If dt.Rows.Count > 0 Then
                Me.pnlCxCAuditoria.Visible = True
                Me.lblMsg.Visible = False
                rvCxCAuditoria.LocalReport.DataSources.Clear()
                rvCxCAuditoria.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("CxC_Auditoria_ds", dt))
                rvCxCAuditoria.LocalReport.Refresh()
            Else
                Me.pnlCxCAuditoria.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No hay data para esta consulta"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlCxCAuditoria.Visible = False
        End Try
    End Sub

End Class
