Imports System.Data

Partial Class DGII_consResumenAclaracionesPendientes
    Inherits BasePage

    ' Declaramos las variables globales.
    Protected dt As DataTable
    Protected dt2 As DataTable
    Protected paginaTam As Integer

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

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        'Me.RolesRequeridos = New String() {10, 46}
        AclaracionesPendientes()
    End Sub

    Private Sub AclaracionesPendientes()

        Try

            dt = SuirPlus.Bancos.Dgii.getPageResumenAclaraciones(Me.pageNum, Me.PageSize)
            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()

        Catch ex As Exception
            Response.Write(ex.ToString())
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

        setNavigation()
    End Sub

    Public Overrides Sub DataBind()
        AclaracionesPendientes()
    End Sub

    Protected Sub gvDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalle.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(1).Text = "<a href=""consDetallesAclaracionesPendientes.aspx?id_entidad_recaudadora=" & e.Row.Cells(0).Text & "&rango=" & e.Row.Cells(2).Text & "&desc=" & e.Row.Cells(1).Text & """>" & e.Row.Cells(1).Text & "</a>"
        End If
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

        AclaracionesPendientes()

    End Sub

End Class

