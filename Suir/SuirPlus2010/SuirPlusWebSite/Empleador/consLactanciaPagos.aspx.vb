Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios.Utils

Partial Class Empleador_consLactanciaPagos
    Inherits BasePage


#Region "Propiedades"
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

    Public Property pageNum2() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum2.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum2.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum2.Text = value
        End Set
    End Property

    Public Property PageSize2() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize2.Text) Then
                Return BasePage.PageSize
            End If
            Return BasePage.PageSize
            'Return Int16.Parse(Me.lblPageSize2.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize2.Text = value
        End Set

    End Property
#End Region

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

        bindPagosLactancia()

    End Sub

    Private Sub setNavigation2()

        Dim totalRecords2 As Integer = 0

        If IsNumeric(Me.lblTotalRegistros2.Text) Then
            totalRecords2 = CInt(Me.lblTotalRegistros2.Text)
        End If

        Dim totalPages2 As Double = Math.Ceiling(Convert.ToDouble(totalRecords2) / PageSize2)

        If totalRecords2 = 1 Or totalPages2 = 0 Then
            totalPages2 = 1
        End If

        If PageSize2 > totalRecords2 Then
            PageSize2 = Int16.Parse(totalPages2)
        End If

        Me.lblCurrentPage2.Text = pageNum2
        Me.lblTotalPages2.Text = totalPages2

        If pageNum2 = 1 Then
            Me.btnLnkFirstPage2.Enabled = False
            Me.btnLnkPreviousPage2.Enabled = False
        Else
            Me.btnLnkFirstPage2.Enabled = True
            Me.btnLnkPreviousPage2.Enabled = True
        End If

        If pageNum2 = totalPages2 Then
            Me.btnLnkNextPage2.Enabled = False
            Me.btnLnkLastPage2.Enabled = False
        Else
            Me.btnLnkNextPage2.Enabled = True
            Me.btnLnkLastPage2.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink2_Click(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First2"
                pageNum2 = 1
            Case "Last2"
                pageNum2 = Convert.ToInt32(lblTotalPages2.Text)
            Case "Next2"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) + 1
            Case "Prev2"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) - 1
        End Select

        bindPagosLactanciaError()

    End Sub

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'llenamos los siguientes objetos con el registro patronal logueado...
        If Not Page.IsPostBack Then
            bindPagosLactancia()

            bindPagosLactanciaError()

            If (Me.divPagoLactancia.Visible = False) And (Me.divPagoLactanciaError.Visible = False) Then
                Me.lblMensaje.Text = "No existen datos para esta consulta"
                Me.upInfoPagoLactancia.Visible = False
            Else
                Me.upInfoPagoLactancia.Visible = True
                Me.lblMensaje.Text = String.Empty
            End If
        End If

    End Sub

    Protected Sub bindPagosLactancia()
        Dim dt As New DataTable
        dt = Empresas.SubsidiosSFS.Consultas.getPagosLactancia(Me.UsrRegistroPatronal, pageNum, PageSize, txtCedula.Text)

        If dt.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.divPagoLactancia.Visible = True
            Me.gvPagoLactancia.DataSource = dt
            Me.gvPagoLactancia.DataBind()
            Me.pnlNavegacion.Visible = True
        Else
            Me.divPagoLactancia.Visible = False
            Me.pnlNavegacion.Visible = False
        End If

        dt = Nothing
        setNavigation()

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtExport As New DataTable
        dtExport = Empresas.SubsidiosSFS.Consultas.getPagosLactancia(Me.UsrRegistroPatronal, 1, CInt(Me.lblTotalRegistros.Text), txtCedula.Text)
        dtExport.Columns.Remove("RECORDCOUNT")
        dtExport.Columns.Remove("NUM")
        Me.ucExportarExcel1.DataSource = dtExport
        Me.ucExportarExcel1.FileName = "PagosLactancia.xls"

    End Sub

    Protected Sub bindPagosLactanciaError()
        Dim dt As New DataTable
        dt = Empresas.SubsidiosSFS.Consultas.getPagosLactanciaConError(Me.UsrRegistroPatronal, pageNum2, PageSize2, txtCedula.Text)

        If dt.Rows.Count > 0 Then
            Me.lblTotalRegistros2.Text = dt.Rows(0)("RECORDCOUNT")
            Me.divPagoLactanciaError.Visible = True
            Me.gvPagoLactanciaError.DataSource = dt
            Me.gvPagoLactanciaError.DataBind()
            Me.pnlNavegacion2.Visible = True
        Else
            Me.divPagoLactanciaError.Visible = False
            Me.pnlNavegacion2.Visible = False
            Me.lblMensaje.Text = "No existen datos para esta consulta"
        End If
        dt = Nothing
        setNavigation2()

    End Sub

    Protected Sub ucExportarExcel2_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel2.ExportaExcel
        Dim dtExport2 As New DataTable
        dtExport2 = Empresas.SubsidiosSFS.Consultas.getPagosLactanciaConError(Me.UsrRegistroPatronal, 1, CInt(Me.lblTotalRegistros2.Text), txtCedula.Text)
        dtExport2.Columns.Remove("RECORDCOUNT")
        dtExport2.Columns.Remove("NUM")
        Me.ucExportarExcel2.DataSource = dtExport2
        Me.ucExportarExcel2.FileName = "PagosLactanciaConError.xls"
    End Sub

    Protected Function formateaCedula(ByVal cedula As String) As String
        Return Utilitarios.Utils.FormatearCedula(cedula)
    End Function

    Protected Function formateaPeriodo(ByVal Periodo As String) As String

        If Periodo = String.Empty Then
            Return String.Empty
        Else
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        End If

    End Function

    Protected Sub gvPagoLactancia_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagoLactancia.RowDataBound
        e.Row.Cells(0).Text = ProperCase(e.Row.Cells(0).Text)
        e.Row.Cells(2).Text = ProperCase(e.Row.Cells(2).Text)
    End Sub

    Protected Sub gvPagoLactanciaError_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvPagoLactanciaError.RowDataBound
        e.Row.Cells(0).Text = ProperCase(e.Row.Cells(0).Text)
        e.Row.Cells(2).Text = ProperCase(e.Row.Cells(2).Text)
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.lblMensaje.Text = String.Empty
        Me.pageNum = 1
        Me.pageNum2 = 1
        bindPagosLactancia()
        bindPagosLactanciaError()
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.txtCedula.Text = String.Empty
        Me.lblMensaje.Text = String.Empty
        Me.PageSize = BasePage.PageSize
        Me.pageNum = 1
        Me.pageNum2 = 1
        bindPagosLactancia()
        bindPagosLactanciaError()
    End Sub
End Class
