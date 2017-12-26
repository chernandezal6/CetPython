Imports SuirPlus
Imports System.Data
Imports System.IO
Partial Class Finanzas_consDispersion
    Inherits BasePage

    Private TotalRows As Integer
    Private tDependientes As Integer
    Private tTitulares As Integer
    Private tAdicionales As Integer
    Private tTotales As Integer
    Private tPago As Decimal
    Private dtexcel As New Data.DataTable

    Private Property IDCarga() As Integer
        Get
            If ViewState("IDCarga") Is Nothing Then
                Return -1
            Else
                Return ViewState("IDCarga")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("IDCarga") = value
        End Set
    End Property

    Public Property pageNumDisp() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNumDisp.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNumDisp.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNumDisp.Text = value
        End Set
    End Property

    Public Property PageSizeDisp() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSizeDisp.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSizeDisp.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSizeDisp.Text = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.PageSizeDisp = 6
        End If

        tDependientes = 0
        tTitulares = 0
        tAdicionales = 0
        tTotales = 0
        tPago = 0

        BindCompletados()


    End Sub

    Private Sub BindCompletados()
        Me.lblMensaje.Text = String.Empty

        Try
            Dim dt As System.Data.DataTable = Finanzas.Dispersion.getDispersionesCompletados(pageNumDisp, PageSizeDisp)
            If dt.Rows.Count > 0 Then

                Me.lblMensaje.Text = String.Empty
                Me.PanelRegistrosDisp.Visible = True
                Me.gvDipersionesCompletados.DataSource = dt
                Me.gvDipersionesCompletados.DataBind()
                Me.lblTotalRegistrosDisp.Text = dt.Rows(0)("RECORDCOUNT")
                setNavigationDisp()
            Else
                Me.lblMensaje.Text = "No existe información para los criterios especificado. Trate nuevamente."
                Me.PanelRegistrosDisp.Visible = False

            End If


            dt = Nothing
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub gvDispersion_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            tTitulares = tTitulares + e.Row.Cells(2).Text
            tDependientes = tDependientes + e.Row.Cells(3).Text
            tAdicionales = tAdicionales + e.Row.Cells(4).Text
            tTotales = tTotales + e.Row.Cells(5).Text
            tPago = tPago + e.Row.Cells(6).Text
        ElseIf e.Row.RowType = DataControlRowType.Footer Then
            e.Row.Cells(1).Text = "Totales:&nbsp;"
            e.Row.Cells(1).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(2).Text = String.Format("{0:###,###,##0}", tTitulares)
            e.Row.Cells(2).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(3).Text = String.Format("{0:###,###,##0}", tDependientes)
            e.Row.Cells(3).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(4).Text = String.Format("{0:###,###,##0}", tAdicionales)
            e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(5).Text = String.Format("{0:###,###,##0}", tTotales)
            e.Row.Cells(5).HorizontalAlign = HorizontalAlign.Right
            e.Row.Cells(6).Text = String.Format("{0:c}", tPago)
            e.Row.Cells(6).HorizontalAlign = HorizontalAlign.Right
        End If
    End Sub

    Private Sub BindDispersion(ByVal IdCarga As Integer)
        Try
            Dim dt As System.Data.DataTable = Finanzas.Dispersion.getDispersionCarga(IdCarga)
            If dt.Rows.Count > 0 Then
                Me.lblMensaje.Text = String.Empty
                Me.gvDispersion.DataSource = dt
                Me.pnlDetalleDispersion.Visible = True
            Else
                Me.lblMensaje.Text = "No existe información para los criterios especificado. Trate nuevamente."
                Me.gvDispersion.DataSource = Nothing
                Me.pnlDetalleDispersion.Visible = False
            End If

            Me.gvDispersion.DataBind()
            dt = Nothing
        Catch ex As Exception
            Me.lblMensaje.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub setNavigationDisp()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistrosDisp.Text) Then
            totalRecords = CInt(Me.lblTotalRegistrosDisp.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeDisp)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeDisp > totalRecords Then
            PageSizeDisp = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPageDisp.Text = pageNumDisp
        Me.lblTotalPagesDisp.Text = totalPages

        If pageNumDisp = 1 Then
            Me.btnLnkFirstPageDisp.Enabled = False
            Me.btnLnkPreviousPageDisp.Enabled = False
        Else
            Me.btnLnkFirstPageDisp.Enabled = True
            Me.btnLnkPreviousPageDisp.Enabled = True
        End If

        If pageNumDisp = totalPages Then
            Me.btnLnkNextPageDisp.Enabled = False
            Me.btnLnkLastPageDisp.Enabled = False
        Else
            Me.btnLnkNextPageDisp.Enabled = True
            Me.btnLnkLastPageDisp.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLinkDisp_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNumDisp = 1
            Case "Last"
                pageNumDisp = Convert.ToInt32(lblTotalPagesDisp.Text)
            Case "Next"
                pageNumDisp = Convert.ToInt32(lblCurrentPageDisp.Text) + 1
            Case "Prev"
                pageNumDisp = Convert.ToInt32(lblCurrentPageDisp.Text) - 1
        End Select

        BindCompletados()
        Me.pnlDetalleDispersion.Visible = False

    End Sub

    Protected Sub gvDipersionesCompletados_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        If e.CommandName = "VerDetalle" Then
            Me.IDCarga = e.CommandArgument
            BindDispersion(Me.IDCarga)

        End If

    End Sub

    Protected Sub lnkExportExcel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkExportExcel.Click
        Dim dt As System.Data.DataTable = Finanzas.Dispersion.getDispersionCargaFormateada(IDCarga)

        Page.Controls.Clear()

        Dim dg As New GridView

        'creamos un row para utilizarlo como footer y lo agregamos al datatable
        Dim fr As DataRow
        fr = dt.NewRow
        dt.Rows.Add(fr)

        dg.DataSource = dt
        dg.DataBind()

        dg.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
        dg.HeaderStyle.Font.Bold = True
        dg.CaptionAlign = TableCaptionAlign.Right

        Dim i As Integer = 0
        'recorremos cada fila del gridview y le damos los formatos de lugar
        For Each row As GridViewRow In dg.Rows
            TotalRows = TotalRows + 1

            If TotalRows <> dg.Rows.Count Then

                row.Cells(0).HorizontalAlign = HorizontalAlign.Center
                row.Cells(1).HorizontalAlign = HorizontalAlign.Left

                'almacenamos los valores de cada columna para colocarlos posteriormente en el footer
                If row.RowType = DataControlRowType.DataRow Then
                    tTitulares = tTitulares + Convert.ToInt32(row.Cells(2).Text)
                    tDependientes = tDependientes + Convert.ToInt32(row.Cells(3).Text)
                    tAdicionales = tAdicionales + Convert.ToInt32(row.Cells(4).Text)
                    tTotales = tTotales + Convert.ToInt32(row.Cells(5).Text)
                    tPago = tPago + Convert.ToDecimal(row.Cells(6).Text)
                End If

            Else

                ' Preparamos con valores y formatos el footer completo

                row.Cells(1).Font.Bold = True
                row.Cells(1).Text = "Totales:&nbsp;"
                row.Cells(1).HorizontalAlign = HorizontalAlign.Right
                row.Cells(2).Font.Bold = True
                row.Cells(2).Text = String.Format("{0:###,###,##0}", tTitulares)
                row.Cells(2).HorizontalAlign = HorizontalAlign.Right
                row.Cells(3).Font.Bold = True
                row.Cells(3).Text = String.Format("{0:###,###,##0}", tDependientes)
                row.Cells(3).HorizontalAlign = HorizontalAlign.Right
                row.Cells(4).Font.Bold = True
                row.Cells(4).Text = String.Format("{0:###,###,##0}", tAdicionales)
                row.Cells(4).HorizontalAlign = HorizontalAlign.Right
                row.Cells(5).Font.Bold = True
                row.Cells(5).Text = String.Format("{0:###,###,##0}", tTotales)
                row.Cells(5).HorizontalAlign = HorizontalAlign.Right
                row.Cells(6).Font.Bold = True
                row.Cells(6).Text = String.Format("{0:c}", tPago)
                row.Cells(6).HorizontalAlign = HorizontalAlign.Right
            End If

            'manejamos la forma de alternar el color de cada fila del gridview antes de exportarlo a excel

            If i = 0 Then
                i = 1
            Else

                row.Cells(0).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(1).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(2).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(3).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(4).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(5).BackColor = System.Drawing.Color.Gainsboro
                row.Cells(6).BackColor = System.Drawing.Color.Gainsboro

                i = 0

            End If

        Next

        'apartir de aqui exportamos a excel lo anteriormente preparado
        Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader("Content-Disposition", "attachment; filename= " & "ArchivoDispersionArs.xls")
        Response.Charset = ""
        Me.EnableViewState = False

        Dim tw As New System.IO.StringWriter()
        Dim hw As New System.Web.UI.HtmlTextWriter(tw)

        dg.RenderControl(hw)
        Response.Write(tw.ToString())
        Response.End()
    End Sub

End Class
