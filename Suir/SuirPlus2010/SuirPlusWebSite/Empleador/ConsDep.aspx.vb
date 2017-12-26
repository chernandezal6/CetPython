Imports SuirPlus
Imports System.Data
Imports Oracle.DataAccess.Client

Partial Class Empleador_ConsDep
    Inherits BasePage
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
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            LoadData()
        End If
    End Sub

    Private Sub LoadData()
        Dim RNC As String = String.Empty
        If Me.UsrImpersonandoUnRepresentante Then
            RNC = Me.UsrImpRNC
        Else
            RNC = Me.UsrRNC
        End If


        Dim ds As DataTable = SuirPlus.Empresas.DependienteAdicional.getPageDepFonamat(RNC, pageNum, PageSize)

        If ds.Rows.Count > 0 Then
            gvDetalleDependiente.DataSource = ds
            gvDetalleDependiente.DataBind()
            Me.lblTotalRegistros.Text = ds.Rows(0)("RECORDCOUNT")
            Me.pnlNavegacion.Visible = True
            Me.lblError.Visible = False
        Else
            Me.lblError.Visible = True
            Me.lblError.Text = "Usted no tiene dependientes adicionales registrados"
        End If

        setNavigation()

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

        LoadData()

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As System.EventArgs) Handles ucExportarExcel.ExportaExcel
        Dim RNC As String = String.Empty
        If Me.UsrImpersonandoUnRepresentante Then
            RNC = Me.UsrImpRNC
        Else
            RNC = Me.UsrRNC
        End If


        Dim ds As DataTable = SuirPlus.Empresas.DependienteAdicional.getPageDepFonamat(RNC, 1, 999999)

        If ds.Rows.Count > 0 Then
            ds.Columns.Remove("recordcount")
            ds.Columns.Remove("num")

            ucExportarExcel.FileName = "DepFonamat.xls"
            ucExportarExcel.DataSource = ds
        End If
    End Sub
End Class
