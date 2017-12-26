Imports System.Data

Partial Class Op
    Inherits System.Web.UI.Page
    Protected iTotalMov As Decimal = 0
    Protected iTotalEmp As Decimal = 0
    Protected iTotalCer As Decimal = 0
    Protected iTotalArc As Decimal = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim InfoBancos As New Info


        Me.gvMov.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolMov)
        Me.gvMov.DataMember = "Data"
        Me.gvMov.DataBind()



        Me.gvEmp.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolEmp)
        Me.gvEmp.DataMember = "Data"
        Me.gvEmp.DataBind()


        Me.gvCer.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolCer)
        Me.gvCer.DataMember = "Data"
        Me.gvCer.DataBind()


        Me.gvArcEnv.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolAE)
        Me.gvArcEnv.DataMember = "Data"
        Me.gvArcEnv.DataBind()



    End Sub

    Protected Sub gvMov_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvMov.RowDataBound

        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalMov = iTotalMov + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalMov.ToString("N0")


        End If

    End Sub
    Protected Sub gvEmp_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvEmp.RowDataBound

        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalEmp = iTotalEmp + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalEmp.ToString("N0")


        End If

    End Sub
    Protected Sub gvCer_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvCer.RowDataBound

        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalCer = iTotalCer + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalCer.ToString("N0")


        End If

    End Sub
    Protected Sub gvArc_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvArcEnv.RowDataBound

        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalArc = iTotalArc + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalArc.ToString("N0")


        End If

    End Sub
End Class
