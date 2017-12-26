
Partial Class Controles_UCArchivosDetalle
    Inherits System.Web.UI.UserControl

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    
    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    'Protected dt As Data.DataTable
    'Protected paginaActual As Integer = 1
    'Protected paginaTam As Integer

#Region "Atributos y Propiedades"

    Private myIdReferencia As Integer
    Private myIsDetalleDependiente As Boolean

    Public WriteOnly Property isDetalleDependiente() As Boolean
        Set(ByVal Value As Boolean)
            myIsDetalleDependiente = Value
        End Set
    End Property

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

    Private Sub CargarDetalle()

        'Si lo que se va a mostrar es el detalle de dependientes
        'entonces creamos las columnas adicionales en tiempo de ejecucion
        'y tambien cambiamos el titulo a algunos de los header
        If myIsDetalleDependiente Then
            reestructuraGrid()
        End If

        Me.cargaInicial()

    End Sub

    Private Sub reestructuraGrid()

        'Cambiamos algunas propiedad de la columna 0
        Dim tmpBcol As BoundField = Me.gvDetalleArchivo.Columns(0)
        tmpBcol.HeaderText = "Doc. Titular"
        tmpBcol.DataField = "no_documento"
        tmpBcol.HeaderStyle.HorizontalAlign = HorizontalAlign.Center
        tmpBcol.ItemStyle.Wrap = False

        'Oculta la columna 1 y cambia el header de la columna 2
        Me.gvDetalleArchivo.Columns(1).Visible = False
        Me.gvDetalleArchivo.Columns(2).HeaderText = "Titular"

        'BoundColumn del Tipo del documento del dependiente
        Dim bColTipoDocDependiente As New BoundField
        bColTipoDocDependiente.HeaderText = "Doc. <br/> Dependiente"
        bColTipoDocDependiente.DataField = "no_documento_dependiente"
        bColTipoDocDependiente.HtmlEncode = False
        bColTipoDocDependiente.ItemStyle.Wrap = False
        Me.gvDetalleArchivo.Columns.Add(bColTipoDocDependiente)


        'BoundColumn del Nombre del Dependiente
        Dim bColNombreDependiente As New BoundField
        bColNombreDependiente.HeaderText = "Dependiente"
        bColNombreDependiente.DataField = "Nombre_dependiente"
        Me.gvDetalleArchivo.Columns.Add(bColNombreDependiente)

    End Sub

    Private Sub cargaInicial()

        ' Me.pageNum = 1
        ' Me.PageSize = ConfigurationManager.AppSettings.Item("PAGE_SIZE")

        Dim dtDependientes As Data.DataTable = Nothing

        Try
            dtDependientes = SuirPlus.Empresas.ManejoArchivoPython.getArchivoDetalle(Me.myIdReferencia, Me.pageNum, Me.PageSize)

            If dtDependientes.Rows.Count > 0 Then
                Me.lblTotalRegistros.Text = dtDependientes.Rows(0)("RECORDCOUNT")
                Me.gvDetalleArchivo.DataSource = dtDependientes
                Me.gvDetalleArchivo.DataBind()
                Me.pnlDetalle.Visible = True

            Else
                Me.lblTotalRegistros.Text = "0"
                Me.gvDetalleArchivo.DataSource = Nothing
                Me.gvDetalleArchivo.DataBind()
                Me.pnlDetalle.Visible = False
            End If
        Catch ex As Exception
            Throw ex
        End Try

        dtDependientes = Nothing
        Bind()

    End Sub

    Private Sub Bind()

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

    Public Overrides Sub DataBind()
        CargarDetalle()
    End Sub

    Public Function formateaDocumento(ByVal documento As String) As String

        'Si el documento que se envia no tiene 11 digitos asumimos que es un pasaporte.
        If documento.Length <> 11 Then
            Return documento
        End If

        Return SuirPlus.Utilitarios.Utils.FormatearCedula(documento)

    End Function

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

        Me.cargaInicial()

    End Sub

End Class
