Imports SuirPlus
Imports System.Data

Partial Class Empleador_consARS
    Inherits BasePage

#Region "Metodos y Propiedades"
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
#End Region

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.tdNucleoFamiliar.Visible = False
            Me.gvArs.SelectedIndex = -1
            bindGrid()
        End If
        
    End Sub

    Protected Sub bindGrid()

        Dim dtDetalle As DataTable = Nothing

        Try
            dtDetalle = SuirPlus.Ars.Consultas.consultaAfiliadosPorEmpresa(Me.UsrRegistroPatronal, Me.pageNum, Me.PageSize)

            If dtDetalle.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDetalle.Rows(0)("RECORDCOUNT")
                Me.gvArs.DataSource = dtDetalle
                Me.gvArs.DataBind()
                setNavigation()
                Me.pnlGeneral.Visible = True
            Else
                Me.lblMensaje.Text = "No existen Registros"
                Me.pnlGeneral.Visible = False
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.ToString
            Me.pnlGeneral.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        dtDetalle = Nothing

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

    Protected Sub NavigationLink_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
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

        bindGrid()

    End Sub

    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles UcExp.ExportaExcel
        Dim dtAfiliadosEmpresas As New DataTable
        dtAfiliadosEmpresas = Nothing
        dtAfiliadosEmpresas = SuirPlus.Ars.Consultas.consultaAfiliadosPorEmpresa(Me.UsrRegistroPatronal, 1, CInt(Me.lblTotalRegistros.Text))
        dtAfiliadosEmpresas.Columns.Remove("RECORDCOUNT")
        dtAfiliadosEmpresas.Columns.Remove("NUM")
        UcExp.FileName = "ARS_" & Me.UsrRNC & ".xls"
        UcExp.DataSource = dtAfiliadosEmpresas
        ' UcExp.DataSource = SuirPlus.Empresas.ARS.consAfiliadosPorEmpresaFull(Me.UsrRegistroPatronal)

    End Sub

    Protected Sub gvArs_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvArs.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then
            CType(e.Row.FindControl("imgDependientes"), ImageButton).CommandArgument = e.Row.RowIndex
            CType(e.Row.FindControl("lnkDependientes"), LinkButton).CommandArgument = e.Row.RowIndex
        End If
    End Sub

    Protected Sub gvArs_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvArs.RowCommand
        'Muestra el detalle del parametro seleccionado
        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Dim Documento As String = Convert.ToString(Me.gvArs.Rows(index).Cells(1).Text)
        Me.gvArs.SelectedIndex = index

        'Muestra el nucleo familiar del titular selecionado
        Dim Res As String = ""
        Dim Nombre As String = ""
        Dim ARS As String = ""
        Dim Status As String = ""

        Me.gvNucleo.DataSource = SuirPlus.Ars.Consultas.consultaAfilado(Documento, Nombre, ARS, Status, Res, Nothing, Nothing)
        Me.gvNucleo.DataBind()
        Me.tdNucleoFamiliar.Visible = True
    End Sub


End Class
