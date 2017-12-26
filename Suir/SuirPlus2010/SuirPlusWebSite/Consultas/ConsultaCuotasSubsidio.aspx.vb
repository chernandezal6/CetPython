Imports SuirPlus
Imports System.Data
Partial Class ConsultaCuotasSubsidio
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
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaCuotasSubsidio.aspx")
    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If String.IsNullOrEmpty(txtFechaDesde.Text) Then
            lblMensaje.Text = "La fecha desde es requerida."
            Return
        End If

        If String.IsNullOrEmpty(txtFechaHasta.Text) Then
            lblMensaje.Text = "La fecha hasta es requerida."
            Return
        End If

        LoadData()
    End Sub

    Private Sub LoadData()
        Try
            Dim dt As New DataTable

            dt = Empresas.SubsidiosSFS.Consultas.getCuotasSubsidios(Convert.ToDateTime(Me.txtFechaDesde.Text), Convert.ToDateTime(Me.txtFechaHasta.Text), Me.ddlTipoEmpresa.SelectedValue, Me.pageNum, Me.PageSize)

            If dt.Rows.Count > 0 Then
                gvCuotasSubsidios.DataSource = dt
                gvCuotasSubsidios.DataBind()
                pnlDatos.Visible = True
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Else
                lblMensaje.Text = "No se encontraron registro para esta busqueda."
                gvCuotasSubsidios.DataSource = Nothing
                gvCuotasSubsidios.DataBind()
                pnlDatos.Visible = False
            End If
            setNavigation()
        Catch ex As Exception
            lblMensaje.Text = ex.Message
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

        LoadData()

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(sender As Object, e As EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dt As New DataTable

        dt = Empresas.SubsidiosSFS.Consultas.getCuotasSubsidios(Convert.ToDateTime(Me.txtFechaDesde.Text), Convert.ToDateTime(Me.txtFechaHasta.Text), Me.ddlTipoEmpresa.SelectedValue, 1, 999999)

        If dt.Rows.Count > 0 Then
            Me.ucExportarExcel1.FileName = "CuotasSubsidios.xls"
            Me.ucExportarExcel1.DataSource = dt
        End If
    End Sub
End Class
