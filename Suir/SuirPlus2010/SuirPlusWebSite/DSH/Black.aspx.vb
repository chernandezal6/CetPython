Imports System.Drawing
Imports WebChart
Imports System.Data

Partial Class Black
    Inherits System.Web.UI.Page
    Dim dataTotal As Decimal = 0.0
    Dim dataTotalFac As Long = 0
    Dim dataTotal2 As Decimal = 0.0
    Dim dataTotalFac2 As Long = 0
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim infoBan As New Info


        Me.CargarInfoBanco(infoBan.sSQLBancoTSS2)
        Me.CargarInfoHora(infoBan.sSQLHoraTSS2)

    End Sub

    Private Sub CargarInfoBanco(ByVal ssql)

        Dim InfoBancos As New Info
        Dim dsBancos As DataSet = InfoBancos.getData(ssql)


        Me.DataList1.DataSource = dsBancos
        Me.DataList1.DataMember = "Data"
        Me.DataList1.DataBind()

        Dim chart As PieChart = New PieChart
        chart.DataSource = dsBancos.Tables(0).DefaultView
        chart.DataXValueField = "Banco"
        chart.DataYValueField = "Facturas"
        chart.DataLabels.Visible = True
        chart.DataLabels.ForeColor = System.Drawing.Color.Blue
        chart.Shadow.Visible = True
        chart.Explosion = 10
        chart.Legend = "Banco"
        chart.DataBind()

        'ChartControl1.Charts.Add(chart)
        'ChartControl1.RedrawChart()

        Dim chart2 As StackedColumnChart = New StackedColumnChart
        chart2.DataSource = dsBancos.Tables(0).DefaultView
        chart2.DataXValueField = "Banco"
        chart2.DataYValueField = "Total"
        chart2.DataLabels.Visible = True
        chart2.DataLabels.ForeColor = System.Drawing.Color.Blue
        chart2.Shadow.Visible = True
        chart2.Legend = "Banco"
        chart2.ShowLegend = True
        chart2.DataBind()

        'ChartControl2.Charts.Add(chart2)
        'ChartControl2.RedrawChart()

    End Sub
    Private Sub CargarInfoHora(ByVal ssql)

        Dim InfoBancos2 As New Info
        Dim dsBancos2 As DataSet = InfoBancos2.getData(ssql)

        Me.DataList2.DataSource = dsBancos2
        Me.DataList2.DataMember = "Data"
        Me.DataList2.DataBind()

        Dim chart7 As PieChart = New PieChart
        chart7.DataSource = dsBancos2.Tables(0).DefaultView
        chart7.DataXValueField = "Hora"
        chart7.DataYValueField = "Facturas"
        chart7.DataLabels.Visible = True
        chart7.DataLabels.ForeColor = System.Drawing.Color.Blue
        chart7.Shadow.Visible = True
        chart7.Explosion = 10
        chart7.Legend = "Hora"
        chart7.DataBind()

        'ChartControl3.Charts.Add(chart7)
        'ChartControl3.RedrawChart()

        Dim chart8 As StackedColumnChart = New StackedColumnChart
        chart8.DataSource = dsBancos2.Tables(0).DefaultView
        chart8.DataXValueField = "Hora"
        chart8.DataYValueField = "Total"
        chart8.DataLabels.Visible = True
        chart8.DataLabels.ForeColor = System.Drawing.Color.Blue
        chart8.Shadow.Visible = True
        chart8.Legend = "Hora"
        chart8.ShowLegend = True
        chart8.DataBind()

        'ChartControl4.Charts.Add(chart8)
        'ChartControl4.RedrawChart()

    End Sub



    'Protected Sub gvBancosTSS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvBancosTSS.RowDataBound

    '    Dim tableData As DataRowView = e.Row.DataItem

    '    If e.Row.RowType = DataControlRowType.DataRow Then

    '        iTotalFac = iTotalFac + Convert.ToDecimal(e.Row.Cells(1).Text)
    '        iTotalMon = iTotalMon + Convert.ToDecimal(e.Row.Cells(2).Text)

    '    ElseIf e.Row.RowType = DataControlRowType.Footer Then
    '        e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
    '        e.Row.Cells(0).Text = "Total:"
    '        e.Row.Cells(1).Text = iTotalFac.ToString("N2")
    '        e.Row.Cells(2).Text = iTotalMon.ToString("N0")

    '    End If

    'End Sub

    'Protected Sub gvHora_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvHora.RowDataBound
    '    Dim tableData As DataRowView = e.Row.DataItem

    '    If e.Row.RowType = DataControlRowType.DataRow Then

    '        iTotalFac2 = iTotalFac2 + Convert.ToDecimal(e.Row.Cells(1).Text)
    '        iTotalMon2 = iTotalMon2 + Convert.ToDecimal(e.Row.Cells(2).Text)

    '    ElseIf e.Row.RowType = DataControlRowType.Footer Then
    '        e.Row.Cells(0).Text = "Total:"
    '        e.Row.Cells(1).Text = iTotalFac2.ToString("N2")
    '        e.Row.Cells(2).Text = iTotalMon2.ToString("N0")

    '    End If
    'End Sub

    Protected Sub DataList1_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles DataList1.ItemDataBound

        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim datafac As String = CType(e.Item.FindControl("lblCantidadFacturas"), Label).Text
            Dim dataTot As String = CType(e.Item.FindControl("lblTotalAutorizado"), Label).Text

            dataTotal = dataTotal + Convert.ToDecimal(dataTot)
            dataTotalFac = dataTotalFac + Convert.ToDecimal(datafac)

            dataTot = String.Empty
            datafac = String.Empty

        ElseIf e.Item.ItemType = ListItemType.Footer Then
            CType(e.Item.FindControl("lblSumTotal"), Label).Text = dataTotal.ToString("C")
            CType(e.Item.FindControl("lblSumFacturas"), Label).Text = dataTotalFac.ToString("N0")
        End If

    End Sub

    Protected Sub DataList2_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles DataList2.ItemDataBound
        If e.Item.ItemType = ListItemType.AlternatingItem Or e.Item.ItemType = ListItemType.Item Then
            Dim datafac2 As String = CType(e.Item.FindControl("lblCantidadFacturas"), Label).Text
            Dim dataTot2 As String = CType(e.Item.FindControl("lblTotalAutorizado"), Label).Text

            dataTotal2 = dataTotal2 + Convert.ToDecimal(dataTot2)
            dataTotalFac2 = dataTotalFac2 + Convert.ToDecimal(datafac2)

            dataTot2 = String.Empty
            datafac2 = String.Empty

        ElseIf e.Item.ItemType = ListItemType.Footer Then
            CType(e.Item.FindControl("lblSumTotal"), Label).Text = dataTotal2.ToString("C")
            CType(e.Item.FindControl("lblSumFacturas"), Label).Text = dataTotalFac2.ToString("N0")
        End If
    End Sub
End Class
