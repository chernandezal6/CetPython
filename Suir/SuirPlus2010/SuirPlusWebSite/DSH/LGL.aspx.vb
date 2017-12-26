Imports System.Data

Partial Class LGL
    Inherits System.Web.UI.Page

    Protected iTotalAcuSts As Decimal = 0
    Protected iTotalAcuDep As Decimal = 0
    Protected iTotalSolUsrHoy As Decimal = 0
    Protected iTotalSolUsrAll As Decimal = 0
    Protected iTotalAcuUsrHoy As Decimal = 0
    Protected iTotalAcuUsrAll As Decimal = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim InfoBancos As New Info

        Me.gvAcuSts.DataSource = InfoBancos.getData(InfoBancos.sSQLlglAcuerdosPagosStatus)
        Me.gvAcuSts.DataMember = "Data"
        Me.gvAcuSts.DataBind()

        Me.gvAcuDep.DataSource = InfoBancos.getData(InfoBancos.sSQLlglAcuerdosPagosDepto)
        Me.gvAcuDep.DataMember = "Data"
        Me.gvAcuDep.DataBind()

        Me.gvLeyHoy.DataSource = InfoBancos.getData(InfoBancos.sSQLlglLey18907Hoy)
        Me.gvLeyHoy.DataMember = "Data"
        Me.gvLeyHoy.DataBind()

        Me.gvLeyAll.DataSource = InfoBancos.getData(InfoBancos.sSQLlglLey18907All)
        Me.gvLeyAll.DataMember = "Data"
        Me.gvLeyAll.DataBind()

        Me.gvSolUsrHoy.DataSource = InfoBancos.getData(InfoBancos.sSQLlglSolxUsrHoy)
        Me.gvSolUsrHoy.DataMember = "Data"
        Me.gvSolUsrHoy.DataBind()

        Me.gvSolUsrAll.DataSource = InfoBancos.getData(InfoBancos.sSQLlglSolxUsrAll)
        Me.gvSolUsrAll.DataMember = "Data"
        Me.gvSolUsrAll.DataBind()

        Me.gvAcuUsrHoy.DataSource = InfoBancos.getData(InfoBancos.sSQLlglAcuxUsrHoy)
        Me.gvAcuUsrHoy.DataMember = "Data"
        Me.gvAcuUsrHoy.DataBind()

        Me.gvAcuUsrAll.DataSource = InfoBancos.getData(InfoBancos.sSQLlglAcuxUsrAll)
        Me.gvAcuUsrAll.DataMember = "Data"
        Me.gvAcuUsrAll.DataBind()

    End Sub

    Protected Sub gvAcuSts_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAcuSts.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalAcuSts = iTotalAcuSts + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAcuSts.ToString("N0")
        End If
    End Sub

    Protected Sub gvAcuDep_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAcuDep.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalAcuDep = iTotalAcuDep + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAcuSts.ToString("N0")
        End If
    End Sub

    Protected Sub gvSolUsrHoy_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolUsrHoy.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalSolUsrHoy = iTotalSolUsrHoy + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalSolUsrHoy.ToString("N0")
        End If
    End Sub

    Protected Sub gvSolUsrAll_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvSolUsrAll.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalSolUsrAll = iTotalSolUsrAll + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalSolUsrAll.ToString("N0")
        End If
    End Sub

    Protected Sub gvAcuUsrHoy_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAcuUsrHoy.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalAcuUsrHoy = iTotalAcuUsrHoy + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAcuUsrHoy.ToString("N0")
        End If
    End Sub

    Protected Sub gvAcuUsrAll_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvAcuUsrAll.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem
        If e.Row.RowType = DataControlRowType.DataRow Then
            iTotalAcuUsrAll = iTotalAcuUsrAll + Convert.ToDecimal(e.Row.Cells(1).Text)
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalAcuUsrAll.ToString("N0")
        End If
    End Sub

End Class
