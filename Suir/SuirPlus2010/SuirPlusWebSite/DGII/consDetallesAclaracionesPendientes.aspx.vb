Imports System.Data

Partial Class DGII_consDetallesAclaracionesPendientes
    Inherits BasePage
    
    ' Declaracion de las variables globales.
    Protected dt As DataTable
    Protected dt2 As DataTable

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
    ' Proceso de carga del dbgrid de las Aclaraciones Pendientes.
    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        'Establecemos los roles que manejara la página.
        Me.RolesRequeridos = New String() {10, 46}
        ' Despliego la variable que recibo de la página anterior.
        Me.lbltxtBanco.Text = Request("desc")
        Me.DetallesAclaracionesPendientes()

    End Sub
    Private Sub DetallesAclaracionesPendientes()

        Try

            Me.lbltxtBanco.Text = Request("desc")

            dt = SuirPlus.Bancos.Dgii.getPageResumenAclaracionesDet(CInt(Request("id_entidad_recaudadora")), Request("rango"), Me.pageNum, Me.PageSize)
            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvDetalle.DataSource = dt
            Me.gvDetalle.DataBind()

        Catch ex As Exception
            Response.Write(ex.ToString())
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
        setNavigation()
    End Sub


    Private Sub btBuscar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        DetallesAclaracionesPendientes()
    End Sub

    Private Sub On_ExportaExcel(ByVal sender As Object, ByVal e As EventArgs) Handles ucExpExcel.ExportaExcel
        ucExpExcel.FileName = "Aclaración de Bancos"
        ucExpExcel.DataSource = SuirPlus.Bancos.Dgii.getResumenAclaracionesDet(CInt(Request("id_entidad_recaudadora")))
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

        DetallesAclaracionesPendientes()

    End Sub
End Class
