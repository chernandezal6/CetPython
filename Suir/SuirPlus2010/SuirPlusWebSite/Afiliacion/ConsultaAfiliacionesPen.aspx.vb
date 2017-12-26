Imports System.Data
Imports SuirPlus
Partial Class ConsultaAfiliacionesPen
    Inherits BasePage

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

#End Region

    Private Sub LoadData()
        Dim dtTSS As DataTable

        dtTSS = Afiliacion.Afiliaciones.getAfiliacionesPendientes(Me.ddlARS.SelectedValue, Me.PageSize, Me.pageNum)

        If dtTSS.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dtTSS.Rows(0)("RECORDCOUNT")
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = True
            setNavigation()

            Me.lblARS.Text = dtTSS.Rows(0)("ARS_DES").ToString()
        Else
            lblMensaje.Text = "No existen registro para esta busqueda."
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = False
        End If

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If Not Me.ddlARS.SelectedValue = "0" Then
            LoadData()
        Else
            lblMensaje.Text = "Debe elegir una fecha desde y una hasta y una ARS."
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaAfiliacionesPen.aspx")
    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtTSS As DataTable

        dtTSS = Afiliacion.Afiliaciones.getAfiliacionesPendientes(Me.ddlARS.SelectedValue, Me.lblTotalRegistros.Text, 1)

        If dtTSS.Rows.Count > 0 Then
            Me.ucExportarExcel1.FileName = "AfiliacionesPendientes.xls"
            Me.ucExportarExcel1.DataSource = dtTSS
        End If
    End Sub

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(getARSUsuario) Then
                Me.ddlARS.SelectedValue = getARSUsuario()
                Me.ddlARS.Enabled = False
            End If
        End If
    End Sub

    Public Function getARSUsuario() As String
        Dim usuario As New Seguridad.Usuario(Me.UsrUserName)
        usuario.Roles = New Seguridad.Autorizacion(Me.UsrUserName).getRoles().Split("|")

        'Si el usuario Pertenece a SENASA
        If usuario.IsInRole("277") Then
            Return "52"
            'Si el usuario Pertenece a SEMMA
        ElseIf usuario.IsInRole("278") Then
            Return "42"
            'Si el usuario Pertenece a ARS Salud Segura
        ElseIf usuario.IsInRole("296") Then
            Return "2"
            'Si el usuario Pertenece Secretaria de Hacienda
        ElseIf usuario.IsInRole("279") Then
            Return "98"
        End If

        Return String.Empty

    End Function
End Class
