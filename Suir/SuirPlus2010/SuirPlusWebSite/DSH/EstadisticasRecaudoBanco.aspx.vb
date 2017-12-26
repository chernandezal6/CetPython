Imports System.Drawing
Imports WebChart
Imports System.Data
Partial Class EstadisticasRecaudoBanco
    Inherits System.Web.UI.Page

    Protected iTotalFac As Decimal = 0
    Protected iTotalMon As Decimal = 0
    Protected iTotalFac2 As Decimal = 0
    Protected iTotalMon2 As Decimal = 0

    Protected iTotalFacB As Decimal = 0
    Protected iTotalMonB As Decimal = 0
    Protected iTotalFacB2 As Decimal = 0
    Protected iTotalMonB2 As Decimal = 0


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim infoBan As New Info

        Select Case Request.QueryString("Who")
            Case "ISR"
                Me.CargarInfoBanco(infoBan.sSQLBancoISR)
                Me.CargarInfoHora(infoBan.sSQLHoraISR)
            Case "TSS"
                Me.CargarInfoBanco(infoBan.sSQLBancoTSS)
                Me.CargarInfoHora(infoBan.sSQLHoraTSS)
            Case "IR17"
                Me.CargarInfoBanco(infoBan.sSQLBancoIR17)
                Me.CargarInfoHora(infoBan.sSQLHoraIR17)
            Case "INF"
                Me.CargarInfoBanco(infoBan.sSQLBancoINF)
                Me.CargarInfoHora(infoBan.sSQLHoraINF)
        End Select


    End Sub

    Private Sub CargarInfoBanco(ByVal ssql)

        Dim InfoBancos As New Info
        Dim dsBancos As DataSet = InfoBancos.getData(ssql)

        Dim pBancos As String = String.Empty
        Dim pTotalAutorizado As String = String.Empty
        Dim pTotalFacturas As String = String.Empty

        Dim leyendaFac As String = String.Empty
        Dim leyendaRec As String = String.Empty
        Dim TotalRecaudado As Integer
        Dim divRecaudado As Integer
        Dim Color As Integer
        Dim colores As String = String.Empty
        Dim colores2 As String = String.Empty

        'llenamos el grid de las estadisticas por banco
        Me.gvRecaudoPorBanco.DataSource = dsBancos
        Me.gvRecaudoPorBanco.DataBind()

        Dim dr As DataRow
        For Each dr In dsBancos.Tables(0).Rows
            If pBancos = "" Then
                pBancos = pBancos & dr(0).ToString()
                pTotalAutorizado = pTotalAutorizado & dr(1).ToString()
                pTotalFacturas = pTotalFacturas & dr(2).ToString()
                leyendaFac = leyendaFac & "[" & dr(2).ToString() & "]" & "  " & dr(0).ToString()

                'leyendaRec = leyendaRec & dr(1).ToString()
                ' leyendaRec = "[" & dr(1).ToString() & "]" & "  " & dr(0).ToString()
                leyendaRec = dr(0).ToString() & "  ->  " & "[" & String.Format("{0:n}", dr(1)) & "]"

                Color = Color + 1
                colores = colores & GetColor(1)
                colores2 = colores2 & GetColor(1)
            Else

                pBancos = pBancos & "|" & dr(0).ToString()
                pTotalAutorizado = pTotalAutorizado & "," & dr(1).ToString()
                pTotalFacturas = pTotalFacturas & "," & dr(2).ToString()
                leyendaFac = leyendaFac & "|" & "[" & dr(2).ToString() & "]" & "  " & dr(0).ToString()

                'leyendaRec = leyendaRec & " | " & dr(1).ToString()
                ' leyendaRec = leyendaRec & "|" & "[" & dr(1).ToString() & "]" & "  " & dr(0).ToString()
                leyendaRec = leyendaRec & "|" & dr(0).ToString() & "  ->  " & "[" & String.Format("{0:n}", dr(1)) & "]"

                Color = Color + 1
                colores = colores & "|" & GetColor(Color)
                colores2 = colores2 & "," & GetColor(Color)
            End If
            TotalRecaudado = TotalRecaudado + CInt(dr(1).ToString())
        Next
        divRecaudado = TotalRecaudado / 2


        Me.chtCantFactBancos.Src = "http://chart.apis.google.com/chart?cht=p3&chd=t:" & pTotalFacturas & "&chco=0000ff&chs=700x200&chl=" & leyendaFac 'pBancos

        Me.chtRecaudoBancosBar.Src = "http://chart.apis.google.com/chart?cht=bvs&chd=t:" & pTotalAutorizado & "&chxt=x,y&chxl=1:|Minimo|-|Maximo&chbh=40&chds=0," & divRecaudado & "&chs=700x300&chxs=0,000000,8&chco=" & colores

        Me.chtRecaudoBancosLegend.Src = "http://chart.apis.google.com/chart?cht=v&chs=400x300&chdl=" & leyendaRec & "&chco=" & colores2

    End Sub

    Private Function GetColor(ByVal valor As Integer)

        Dim res As String = String.Empty
        '0176D3,075912,D9EFDC,1947A4,F8031A,230C0E,910F1C,DDB025,5A5D9F,DA24AD
        Select Case valor
            Case 1
                res = ("DDB025")
            Case 2
                res = ("075912")
            Case 3
                res = ("DA24AD")
            Case 4
                res = ("F8031A")
            Case 5
                res = ("1947A4")
            Case 6
                res = ("230C0E")
            Case 7
                res = ("910F1C")
            Case 8
                res = ("D9EFDC")
            Case 9
                res = ("5A5D9F")
            Case 10
                res = ("0176D3")
                case 11
                res = ("80C65A")
            Case Else
                res = ("76A4FB")
        End Select
        Return res
    End Function

    Protected Sub gvRecaudoPorBanco_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvRecaudoPorBanco.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalFacB = iTotalFacB + Convert.ToDecimal(e.Row.Cells(1).Text)
            iTotalMonB = iTotalMonB + Convert.ToDecimal(e.Row.Cells(2).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Left
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalFacB.ToString("N2")
            e.Row.Cells(2).Text = iTotalMonB.ToString("N0")

        End If
    End Sub

    Private Sub CargarInfoHora(ByVal ssql)

        Dim pHoras As String = String.Empty
        Dim pTotalAutorizado As String = String.Empty
        Dim pTotalFacturas As String = String.Empty

        Dim leyendaFac As String = String.Empty
        Dim leyendaRec As String = String.Empty
        Dim TotalRecaudado As Integer
        Dim divRecaudado As Integer
        Dim Color As Integer
        Dim colores As String = String.Empty
        Dim colores2 As String = String.Empty

        Dim InfoHora As New Info
        Dim dsHora As DataSet = InfoHora.getData(ssql)
        'llenamos el grid de las estadisticas por Hora
        Me.gvRecaudoPorHora.DataSource = dsHora
        Me.gvRecaudoPorHora.DataBind()

        Dim dr As DataRow
        For Each dr In dsHora.Tables(0).Rows
            If pHoras = "" Then
                pHoras = pHoras & dr(0).ToString()
                pTotalAutorizado = pTotalAutorizado & dr(1).ToString()
                pTotalFacturas = pTotalFacturas & dr(2).ToString()
                leyendaFac = leyendaFac & "[" & dr(2).ToString() & "]" & "  " & dr(0).ToString()

                'leyendaRec = leyendaRec & dr(1).ToString()
                leyendaRec = dr(0).ToString() & "  ->  " & "[" & String.Format("{0:n}", dr(1)) & "]"

                Color = Color + 1
                colores = colores & GetColor(1)
                colores2 = colores2 & GetColor(1)
            Else

                pHoras = pHoras & "|" & dr(0).ToString()
                pTotalAutorizado = pTotalAutorizado & "," & dr(1).ToString()
                pTotalFacturas = pTotalFacturas & "," & dr(2).ToString()
                leyendaFac = leyendaFac & "|" & "[" & dr(2).ToString() & "]" & "  " & dr(0).ToString()

                'leyendaRec = leyendaRec & " | " & dr(1).ToString()
                leyendaRec = leyendaRec & "|" & dr(0).ToString() & "  ->  " & "[" & String.Format("{0:n}", dr(1)) & "]"
                Color = Color + 1
                colores = colores & "|" & GetColor(Color)
                colores2 = colores2 & "," & GetColor(Color)
            End If
            TotalRecaudado = TotalRecaudado + CInt(dr(1).ToString())
        Next
        divRecaudado = TotalRecaudado / 2


        Me.chtCantFactHoras.Src = "http://chart.apis.google.com/chart?cht=p&chd=t:" & pTotalFacturas & "&chco=075912&chs=600x300&chl=" & leyendaFac
        ' Me.chtRecaudoHorasBar.Src = "http://chart.apis.google.com/chart?cht=bvs&chd=t:" & pTotalAutorizado & "&chxt=x,y&chxl=1:|Minimo|-|Maximo|0:|" & pHoras & "&chbh=50&chds=0," & divRecaudado & "&chs=700x400&chxs=0,000000,8&chco=" & colores
        Me.chtRecaudoHorasBar.Src = "http://chart.apis.google.com/chart?cht=bvs&chd=t:" & pTotalAutorizado & "&chxt=x,y&chxl=1:|Minimo|-|Maximo&chbh=30&chds=300," & divRecaudado & "&chs=600x400&chxs=0,000000,8&chco=" & colores

        Me.chtRecaudoHorasLegend.Src = "http://chart.apis.google.com/chart?cht=v&chs=300x300&chdl=" & leyendaRec & "&chco=" & colores2

    End Sub

    Protected Sub gvRecaudoPorHora_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvRecaudoPorHora.RowDataBound
        Dim tableData As DataRowView = e.Row.DataItem

        If e.Row.RowType = DataControlRowType.DataRow Then

            iTotalFac2 = iTotalFac2 + Convert.ToDecimal(e.Row.Cells(1).Text)
            iTotalMon2 = iTotalMon2 + Convert.ToDecimal(e.Row.Cells(2).Text)

        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(0).Text = "Total:"
            e.Row.Cells(1).Text = iTotalFac2.ToString("N2")
            e.Row.Cells(2).Text = iTotalMon2.ToString("N0")

        End If

    End Sub
End Class
