Imports SuirPlus
Imports System.Data

Partial Class Reportes_Emp_pagan_via_TN
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            getData()
        End If

    End Sub

    Protected Sub getData()
        Dim dt As New DataTable
        Try

            dt = Empresas.Consultas.get_Emp_pagan_via_TN()

            If dt.Rows.Count > 0 Then
                Me.pnlEmp_pagan_via_TN.Visible = True
                Me.lblMsg.Visible = False
                rvEmp_pagan_via_TN.LocalReport.DataSources.Clear()
                rvEmp_pagan_via_TN.LocalReport.DataSources.Add(New Microsoft.Reporting.WebForms.ReportDataSource("EmpleadoresPaganViaTN_ds", dt))
                rvEmp_pagan_via_TN.LocalReport.Refresh()
            Else
                Me.pnlEmp_pagan_via_TN.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No hay data para esta consulta"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            Me.pnlEmp_pagan_via_TN.Visible = False
        End Try
    End Sub
End Class
