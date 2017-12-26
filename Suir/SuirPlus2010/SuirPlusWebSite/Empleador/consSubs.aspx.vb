Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils
Partial Class Empleador_consSubs
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

        bindGrid()

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            bindGrid()
        End If

    End Sub
    Protected Sub bindGrid()

        lblMensaje.Text = String.Empty
        Dim dtDetalle As DataTable = Nothing
        Try
            dtDetalle = SuirPlus.Empresas.SubsidiosSFS.Consultas.getInfoSubs(Me.UsrRegistroPatronal, Me.pageNum, Me.PageSize, Me.txtCedula.Text)

            If dtDetalle.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDetalle.Rows(0)("RECORDCOUNT")
                Me.gvEmbarazos.DataSource = dtDetalle
                Me.gvEmbarazos.DataBind()
                setNavigation()
                divEmbarazadas.Visible = True
            Else
                Me.lblMensaje.Text = "No existen Registros"
                divEmbarazadas.Visible = False
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        dtDetalle = Nothing

    End Sub
    Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtAfiliadosEmpresas As New DataTable
        dtAfiliadosEmpresas = Nothing
        dtAfiliadosEmpresas = SuirPlus.Empresas.SubsidiosSFS.Consultas.getInfoSubs(Me.UsrRegistroPatronal, 1, CInt(Me.lblTotalRegistros.Text), Me.txtCedula.Text)

        dtAfiliadosEmpresas.Columns.Remove("RECORDCOUNT")
        dtAfiliadosEmpresas.Columns.Remove("NUM")
        ucExportarExcel1.FileName = "ARS_" & Me.UsrRNC & ".xls"
        ucExportarExcel1.DataSource = dtAfiliadosEmpresas

    End Sub
    Protected Sub gvEmbarazos_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEmbarazos.RowCommand

        Session("cedulaMadre") = e.CommandArgument.ToString()
        Response.Redirect("~/Consultas/consMaternidad.aspx")

    End Sub
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.pageNum = 1
        bindGrid()
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Me.txtCedula.Text = String.Empty
        Me.lblMensaje.Text = String.Empty
        Me.PageSize = BasePage.PageSize
        Me.pageNum = 1
        bindGrid()
    End Sub
    Protected Sub gvEmbarazos_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvEmbarazos.RowDataBound
        e.Row.Cells(0).Text = ProperCase(e.Row.Cells(0).Text)
        e.Row.Cells(1).Text = FormatearCedula(e.Row.Cells(1).Text)
    End Sub
End Class
