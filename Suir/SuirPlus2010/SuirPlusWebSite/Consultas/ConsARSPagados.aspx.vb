Imports System.Data
Imports SuirPlus
Partial Class Consultas_ConsARSPagados
    Inherits BasePage
#Region "Miembros y Propiedades"

    Public Property pageNum() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum.Text = value
        End Set
    End Property

    Public Property PageSize() As Int16
        Get
            Return 30
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property

#End Region


    Protected Sub btBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btBuscar.Click
        Mostrar_Datos()
    End Sub

    Private Sub Mostrar_Datos()
        Dim dt As New DataTable
        Try
            dt = Ars.Consultas.getPagosNoReferencia(Me.txtReferencia.Text, Me.pageNum, Me.PageSize)

            If dt.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                gvPagosARS.DataSource = dt
                gvPagosARS.DataBind()
                setNavigation()
                Me.PanelRegistros.Visible = True

            Else
                Me.lblMensaje.Text = "No se encontraron registros para este numero de referencia!!"
                gvPagosARS.DataSource = Nothing
                gvPagosARS.DataBind()
                Me.PanelRegistros.Visible = False
            End If

            dt = Nothing
        Catch ex As Exception
            lblMensaje.Text = ex.Message.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSize > totalRecords Then
            PageSize = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNum
        Me.lblTotalPages.Text = totalPages

        If pageNum = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNum = totalPages Then
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
        Else
            Me.btnLnkNextPage.Enabled = True
            Me.btnLnkLastPage.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum = 1
            Case "Last"
                pageNum = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        Mostrar_Datos()

    End Sub

    Protected Sub btLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btLimpiar.Click
        Response.Redirect("ConsARSPagados.aspx")
    End Sub

    Protected Sub gvPagosARS_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(0).Text = e.Row.Cells(2).Text Then
                e.Row.Cells(2).Text = String.Empty
                e.Row.Cells(3).Text = String.Empty
            End If
        End If
    End Sub


    'exportamos a excel

    Protected Sub UcExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles UcExportarExcel1.ExportaExcel
        Dim dtPagosNoRerenecia As New DataTable
        dtPagosNoRerenecia = Nothing
        If Me.lblTotalRegistros.Text = String.Empty Then
            Me.lblTotalRegistros.Text = 0
        End If

        dtPagosNoRerenecia = Ars.Consultas.getPagosNoReferencia(Me.txtReferencia.Text, 1, CInt(Me.lblTotalRegistros.Text))
        If dtPagosNoRerenecia.Rows.Count > 0 Then
            dtPagosNoRerenecia.Columns.Remove("RECORDCOUNT")
            dtPagosNoRerenecia.Columns.Remove("NUM")
            Me.UcExportarExcel1.FileName = "Notificacion: " & Me.txtReferencia.Text & ".xls"
            Me.UcExportarExcel1.DataSource = dtPagosNoRerenecia
        End If
    End Sub


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not String.IsNullOrEmpty(Request.QueryString("Ref")) Then
            txtReferencia.Text = Request.QueryString("Ref")
            Mostrar_Datos()

        End If
    End Sub
End Class
