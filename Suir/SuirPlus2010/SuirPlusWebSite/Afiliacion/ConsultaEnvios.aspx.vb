Imports System.Data
Imports SuirPlus
Partial Class Afiliacion_ConsultaEnvios
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

        GetDetalleArchivo()

    End Sub

#End Region

    Private Property IDRecepcion() As Integer
        Get
            If ViewState("IDRecepcion") Is Nothing Then
                Return -1
            Else
                Return ViewState("IDRecepcion")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("IDRecepcion") = value
        End Set
    End Property

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        If Not String.IsNullOrEmpty(Me.txtDesde.Text) And Not String.IsNullOrEmpty(Me.txtHasta.Text) Or Not String.IsNullOrEmpty(txtNoEnvio.Text) Then
            If Not String.IsNullOrEmpty(getARSUsuario) Then
                GetEncabezado()
            Else
                lblMensaje.Text = "Error Cargando el ID ARS"
            End If
        Else
            lblMensaje.Text = "Debe elegir una fecha desde y una hasta o un No Envio."
        End If
    End Sub

    Private Sub GetEncabezado()
        Dim dtTSS As DataTable


        Dim desde = Nothing
        If Not String.IsNullOrEmpty(Me.txtDesde.Text) = True Then
            desde = CDate(Me.txtDesde.Text)
        End If

        Dim hasta = Nothing
        If Not String.IsNullOrEmpty(Me.txtHasta.Text) = True Then
            hasta = CDate(Me.txtHasta.Text)
        End If


        dtTSS = Afiliacion.Afiliaciones.getInfoArchivo(IIf(String.IsNullOrEmpty(Me.txtNoEnvio.Text), 0, Me.txtNoEnvio.Text), desde, hasta, getARSUsuario)

        If dtTSS.Rows.Count > 0 Then
            Me.gvEncabezado.DataSource = dtTSS
            Me.gvEncabezado.DataBind()
            Me.panelEncabezado.Visible = True

        Else
            lblMensaje.Text = "No existen registro para esta busqueda."
            Me.gvEncabezado.DataSource = dtTSS
            Me.gvEncabezado.DataBind()
            Me.panelEncabezado.Visible = False
        End If
    End Sub

    Protected Sub gvEncabezado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEncabezado.RowCommand
        If e.CommandName = "Ver" Then
            Me.IDRecepcion = e.CommandArgument
            GetDetalleArchivo()
        End If
    End Sub

    Private Sub GetDetalleArchivo()
        Dim dtTSS As DataTable

        dtTSS = Afiliacion.Afiliaciones.getDetalleArchivoPage(Me.IDRecepcion, Me.PageSize, Me.pageNum)

        If dtTSS.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dtTSS.Rows(0)("RECORDCOUNT")
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = True
            setNavigation()
        Else
            lblMensaje.Text = "No existen registro para esta busqueda."
            Me.gvArchivos.DataSource = dtTSS
            Me.gvArchivos.DataBind()
            Me.pnlNavegacion.Visible = False
        End If
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ConsultaEnvios.aspx")
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

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel
        Dim dtTSS As DataTable

        dtTSS = Afiliacion.Afiliaciones.getDetalleArchivoPage(Me.IDRecepcion, Me.lblTotalRegistros.Text, 1)

        If dtTSS.Rows.Count > 0 Then
            Me.ucExportarExcel1.FileName = "DetalleArchivo.xls"
            Me.ucExportarExcel1.DataSource = dtTSS
        End If
    End Sub
End Class
