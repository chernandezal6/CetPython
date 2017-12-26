
Imports SuirPlus.Finanzas
Imports System.Data
Partial Class Finanzas_DetNachaReclamaciones
    Inherits BasePage

    Private Nacha As String
    Private Monto As String
    Private Status As String

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        If Not Page.IsPostBack Then
            Nacha = Request.QueryString.Item("nacha")
            Me.lblNacha.Text = Nacha
            Me.lblMontoNacha.Text = Request.QueryString.Item("monto")
            Me.lblEstatus.Text = Request.QueryString.Item("estatus")

            CargarDetNacha()
        End If


    End Sub

    Private Sub CargarDetNacha()

        Dim dt As New DataTable
        dt = DevolucionAportes.getDetNachas(Nacha, Me.pageNum, Me.PageSize)

        If dt.Rows.Count > 0 Then

            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvDetNacha.DataSource = dt
            Me.gvDetNacha.DataBind()
            Me.pnlNavegacion.Visible = True
        Else
            Me.pnlNavegacion.Visible = False
            Me.gvDetNacha.DataSource = Nothing
            Me.gvDetNacha.DataBind()
        End If

        dt = Nothing
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

        CargarDetNacha()

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Nacha = Request.QueryString.Item("nacha")

        Dim dt As New DataTable
        dt = DevolucionAportes.getDetNachas(Nacha, 1, Me.lblTotalRegistros.Text)
        dt.Columns.Remove("RECORDCOUNT")
        dt.Columns.Remove("NUM")
        Me.ucExportarExcel1.FileName = "Detalle Devolucion Aportes.xls"
        ucExportarExcel1.DataSource = dt
    End Sub

    Protected Sub lnkEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEncabezado.Click
        Response.Redirect("~/finanzas/NachasReclamaciones.aspx")
    End Sub


End Class
