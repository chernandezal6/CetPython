
Partial Class Mantenimientos_ConsPasaporte
    Inherits BasePage

    Private UsuarioLogueado As String
    Private PermisoConsulta As String
    Private RegPat As String



#Region "Paginación"

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

        'If PageSize > totalRecords Then
        '    PageSize = Int16.Parse(totalPages)
        'End If

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

        CargarPasaportes()

    End Sub

#End Region

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            CargarPasaportes()
        End If


    End Sub

    Sub CargarPasaportes()

        If UsrRegistroPatronal <> Nothing Then
            UsuarioLogueado = UsrUserName
            RegPat = UsrRegistroPatronal
        Else
            UsuarioLogueado = UsrUserName
        End If

        'If txtFechaDesde.Text <> Nothing Then
        '    desde = Convert.ToDateTime(txtFechaDesde.Text)
        'End If
        'If txtFechaHasta.Text <> Nothing Then
        '    hasta = Convert.ToDateTime(txtFechaHasta.Text)
        'End If

        Dim data = SuirPlus.Mantenimientos.Mantenimientos.getPasaportes(UsrRegistroPatronal, txtPasaporte.Text, UsuarioLogueado, txtNombres.Text, txtPrimerApellido.Text, txtsegundoApellido.Text, txtFechaDesde.Text, txtFechaHasta.Text, "PE", pageNum, PageSize)
        gvListaPasaporte.DataSource = data
        gvListaPasaporte.DataBind()

        Me.lblTotalRegistros.Text = data.Rows.Count
        setNavigation()

    End Sub


    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        CargarPasaportes()
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        Response.Redirect("ConsPasaporte.aspx")

    End Sub
End Class
