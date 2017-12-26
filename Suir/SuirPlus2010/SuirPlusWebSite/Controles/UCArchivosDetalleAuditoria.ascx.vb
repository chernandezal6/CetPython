
Imports System.data

Partial Class Controles_UCArchivosDetalleAuditoria
    Inherits System.Web.UI.UserControl

    Protected dt As DataTable

#Region "Atributos y Propiedades"

    Private myIdReferencia As Integer

    Public WriteOnly Property IdReferencia() As Integer
        Set(ByVal Value As Integer)
            myIdReferencia = Value
        End Set
    End Property


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


    Private Sub cargaInicial()
        Session("referencia") = myIdReferencia

    End Sub

    Public Overrides Sub DataBind()

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize

        If Not Page.IsPostBack Then
            myIdReferencia = Session("referencia")
        Else

            Me.cargaInicial()

        End If

        bindGrid()
    End Sub
    Protected Sub bindGrid()
        myIdReferencia = Session("referencia")
        Dim dtDetalle As DataTable = Nothing

        Try
            dtDetalle = SuirPlus.Empresas.Archivo.get_PageDetArchivoAuditoria(myIdReferencia, Me.pageNum, Me.PageSize)

            If dtDetalle.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDetalle.Rows(0)("RECORDCOUNT")
                Me.gvDetalleArchivo.DataSource = dtDetalle
                Me.gvDetalleArchivo.DataBind()
                Me.pnlDetalle.Visible = True

            Else
                Me.lblTotalRegistros.Text = "0"
                Me.gvDetalleArchivo.DataSource = Nothing
                Me.gvDetalleArchivo.DataBind()
                Me.pnlDetalle.Visible = False
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "No existe más información para este error"
            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
        End Try

        dtDetalle = Nothing
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

        bindGrid()

    End Sub

    Public Function formateaDocumento(ByVal documento As String) As String

        'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
        If documento.Length <> 11 Then
            Return documento
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)

    End Function

    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If



    End Function

    Protected Sub gvDetalleArchivo_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDetalleArchivo.RowDataBound

        If e.Row.RowType = ListItemType.Item Or e.Row.RowType = ListItemType.AlternatingItem Then
            'No importa que tipo de item sea, le asignamos valores a los label que representan el valor actual.
            e.Row.Cells(4).Text = formateaSalario(e.Row.Cells(4).Text)
            'CType(e.Row.FindControl("lblsalarioFormateado"), Label).Text = formateaSalario(DataBinder.Eval(e.Row.DataItem, "salario_ss"))
        End If


    End Sub
End Class
