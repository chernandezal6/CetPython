Imports SuirPlus
Imports System.Data
Partial Class ConsARSCarteraErrores
    Inherits BasePage
    Private Property IDError() As Integer
        Get
            If ViewState("IDError") Is Nothing Then
                Return -1
            Else
                Return ViewState("IDError")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("IDError") = value
        End Set
    End Property

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
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
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

#End Region

    Private Sub BindErrores(ByVal IdCarga As Integer)
        Try
            Dim dt As New DataTable
            dt = Ars.Consultas.getErroresCartera(IdCarga)


            If dt.Rows.Count > 0 Then
                gvErroresCartera.DataSource = dt
                gvErroresCartera.DataBind()
            Else
                Me.lblMensaje.Text = "No se encontraron registros!!"
                gvErroresCartera.DataSource = Nothing
                gvErroresCartera.DataBind()
                'Ocultado el otro grid
                PanelRegistros.Visible = False
                gvDetalleErrores.DataSource = Nothing
                gvDetalleErrores.DataBind()
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message.ToString
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub gvErroresCartera_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvErroresCartera.RowCommand
        If e.CommandName = "VerDetalle" Then
            Me.IDError = e.CommandArgument
            BindDetallesErrores(Me.IDError)
        End If
    End Sub

    Private Sub BindDetallesErrores(ByVal IDError As Integer)

        Try
            Dim dt As New DataTable
            dt = Ars.Consultas.getDetalleErroresCartera(IDError, pageNum, PageSize)

            If dt.Rows.Count > 0 Then
                gvDetalleErrores.DataSource = dt
                gvDetalleErrores.DataBind()
                PanelRegistros.Visible = True
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                setNavigation()
            Else
                'Me.lblMsg.Text = "No se encontraron registros!!"
                PanelRegistros.Visible = False
                gvDetalleErrores.DataSource = Nothing
                gvDetalleErrores.DataBind()
            End If
        Catch ex As Exception
            lblMensaje.Text = ex.Message.ToString
            Exepciones.Log.LogToDB(ex.ToString())
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

        BindDetallesErrores(Me.IDError)

    End Sub

    Protected Sub gvDipersionesErrores_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Me.lblMensaje.Text = String.Empty
        Me.PanelRegistros.Visible = False
        If e.CommandName = "VerDetalle" Then
            Me.IDCarga = e.CommandArgument
            BindErrores(Me.IDCarga)
        End If
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

        BindErrores(Me.IDCarga)

    End Sub

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack() Then
            Try
                Dim dt As New DataTable
                dt = Ars.Consultas.getDispersionesErrores(pageNumDisp, PageSizeDisp)

                If dt.Rows.Count > 0 Then
                    gvDipersionesErrores.DataSource = dt
                    gvDipersionesErrores.DataBind()
                    PanelRegistrosDisp.Visible = True
                    Me.lblTotalRegistrosDisp.Text = dt.Rows(0)("RECORDCOUNT")
                    setNavigationDisp()
                Else
                    Me.lblMensaje.Text = "No se encontraron registros!!"
                    PanelRegistrosDisp.Visible = False
                    gvDipersionesErrores.DataSource = Nothing
                    gvDipersionesErrores.DataBind()
                End If
            Catch ex As Exception
                lblMensaje.Text = ex.Message.ToString
                Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If
    End Sub
End Class
