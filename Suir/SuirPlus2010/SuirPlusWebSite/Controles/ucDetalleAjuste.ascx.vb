Imports System.Data

Partial Class ucDetalleAjuste
    Inherits BaseCtrlFacturaDetalle

#Region "Miembros y Propiedades"

    Private myPaginaEncabezado As String
    Public Property PaginaEncabezado As String
        Get
            Return myPaginaEncabezado
        End Get
        Set(ByVal value As String)
            myPaginaEncabezado = value
        End Set
    End Property


    Public Property pageNumInf() As Integer
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

    Public Property PageSizeInf() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
                Return 20
            End If
            Return Int16.Parse(Me.lblPageSize.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize.Text = value
        End Set
    End Property
#End Region

    Public Overrides Sub DataBind()
        bindGrid()
    End Sub

    Protected Sub bindGrid()

        Dim dtDetalle As DataTable = Nothing

        Try
            dtDetalle = SuirPlus.Empresas.Facturacion.FacturaSS.getDetalleAjuste(Me.NroReferencia, Me.pageNumInf, Me.PageSizeInf)
            If dtDetalle.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDetalle.Rows(0)("RECORDCOUNT")
                Me.gvDetalle.DataSource = dtDetalle
                Me.gvDetalle.DataBind()
            End If

            If Not Page.IsPostBack Then
                fillLabels()
            End If

        Catch ex As Exception
            Me.lblMensaje.Text = ex.ToString
        End Try

        dtDetalle = Nothing
        setNavigation()
        gvDetalle.Columns(6).Visible = False

    End Sub
    Protected Sub gvDetalle_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalle.RowDataBound
        If e.Row.Cells(6).Text = "3" Then
            If (e.Row.RowType = DataControlRowType.DataRow) Then
                e.Row.Cells(3).Text = "<a href=""../Empleador/consPagosCapitas.aspx?nro=" & NroReferencia & """>" & e.Row.Cells(3).Text & "</a>"

            End If
        End If


    End Sub
    Protected Sub fillLabels()
        Me.lblNoReferencia.Text = SuirPlus.Utilitarios.Utils.FormateaReferencia(Me.NroReferencia)

        Dim dtMontos As DataTable = Nothing

        dtMontos = SuirPlus.Empresas.Facturacion.FacturaSS.getMontoTotalAjuste(Me.NroReferencia)

        If dtMontos.Rows.Count > 0 Then
            gvMonto.DataSource = dtMontos
            gvMonto.DataBind()
        End If
 
    End Sub


    Private Sub setNavigation()

        Dim totalRecords As Integer = 0

        If IsNumeric(Me.lblTotalRegistros.Text) Then
            totalRecords = CInt(Me.lblTotalRegistros.Text)
        End If

        Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSizeInf)

        If totalRecords = 1 Or totalPages = 0 Then
            totalPages = 1
        End If

        If PageSizeInf > totalRecords Then
            PageSizeInf = Int16.Parse(totalPages)
        End If

        Me.lblCurrentPage.Text = pageNumInf
        Me.lblTotalPages.Text = totalPages

        If pageNumInf = 1 Then
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
        Else
            Me.btnLnkFirstPage.Enabled = True
            Me.btnLnkPreviousPage.Enabled = True
        End If

        If pageNumInf = totalPages Then
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
                pageNumInf = 1
            Case "Last"
                pageNumInf = Convert.ToInt32(lblTotalPages.Text)
            Case "Next"
                pageNumInf = Convert.ToInt32(lblCurrentPage.Text) + 1
            Case "Prev"
                pageNumInf = Convert.ToInt32(lblCurrentPage.Text) - 1
        End Select

        bindGrid()

    End Sub

    Protected Function formateaNSS(ByVal NSS As Integer) As String

        Return SuirPlus.Utilitarios.Utils.FormatearNSS(NSS.ToString)

    End Function

    Protected Function formateaDocumento(ByVal documento As Object) As String

        If Not IsDBNull(documento) Then
            'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
            If documento.Length <> 11 Then
                Return documento
            End If

            Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)
        Else
            Return String.Empty
        End If

    End Function

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtDetalle As DataTable = Nothing

        dtDetalle = SuirPlus.Empresas.Facturacion.FacturaSS.getDetalleAjuste(Me.NroReferencia, 1, 9999)
        If dtDetalle.Rows.Count > 0 Then
            dtDetalle.Columns.Remove("NUM")
            dtDetalle.Columns.Remove("ID_AJUSTE")
            dtDetalle.Columns.Remove("ID_REFERENCIA")
            dtDetalle.Columns.Remove("RECORDCOUNT")
            Me.ucExportarExcel1.FileName = "DetalleAjuste.xls"
            Me.ucExportarExcel1.DataSource = dtDetalle


        End If
    End Sub

    Protected Sub lnkEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lnkEncabezado.Click

        If myPaginaEncabezado = "" Then
            Response.Redirect("ConsFactura.aspx?nro=" & Me.NroReferencia)
        Else
            Response.Redirect(myPaginaEncabezado & Me.NroReferencia)
        End If


    End Sub
End Class
