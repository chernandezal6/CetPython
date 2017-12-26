Imports System.Data

Partial Class SEL
    Inherits System.Web.UI.Page

    Protected iTotalSol1 As Decimal = 0
    Protected iTotalCCG As Decimal = 0
    Protected iTotalCerTip As Decimal = 0
    Protected iTotalCerUsu As Decimal = 0
    Protected iTotalAbiTip As Decimal = 0
    Protected iTotalAbiSts As Decimal = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim InfoBancos As New Info

        Me.gvSol1.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolWTSS)
        Me.gvSol1.DataMember = "Data"
        Me.gvSol1.DataBind()

        Me.gvSolCCG.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolCCG)
        Me.gvSolCCG.DataMember = "Data"
        Me.gvSolCCG.DataBind()

        Me.gvSolCerTip.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolCerTip)
        Me.gvSolCerTip.DataMember = "Data"
        Me.gvSolCerTip.DataBind()

        Me.gvSolCerUsu.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolCerUsu)
        Me.gvSolCerUsu.DataMember = "Data"
        Me.gvSolCerUsu.DataBind()

        Me.gvSolAbiTip.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolAbiTip)
        Me.gvSolAbiTip.DataMember = "Data"
        Me.gvSolAbiTip.DataBind()

        Me.gvSolAbiSts.DataSource = InfoBancos.getData(InfoBancos.sSQLopSolAbiSts)
        Me.gvSolAbiSts.DataMember = "Data"
        Me.gvSolAbiSts.DataBind()

    End Sub

    Protected Sub gvSol1_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSol1.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalSol1 = iTotalSol1 + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalSol1.ToString("N0")

        End If
    End Sub

    Protected Sub gvSolCCG_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolCCG.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalCCG = iTotalCCG + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalCCG.ToString("N0")

        End If
    End Sub

    Protected Sub gvSolCerTip_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolCerTip.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalCerTip = iTotalCerTip + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalCerTip.ToString("N0")

        End If
    End Sub

    Protected Sub gvSolCerUsu_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolCerUsu.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalCerUsu = iTotalCerUsu + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalCerUsu.ToString("N0")

        End If
    End Sub

    Protected Sub gvSolAbiTip_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolAbiTip.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalAbiTip = iTotalAbiTip + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAbiTip.ToString("N0")

        End If
    End Sub

    Protected Sub gvSolAbiSts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolAbiSts.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalAbiSts = iTotalAbiSts + Convert.ToDecimal(e.Row.Cells(1).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAbiSts.ToString("N0")

        End If
    End Sub
End Class
