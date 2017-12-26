Imports SuirPlus
Imports System.Data
Partial Class Solicitudes_ReporteGeneralSolicitudes
    Inherits BasePage
    Dim fechaDesde As DateTime
    Dim fechaHasta As DateTime


#Region "Navegacion"

    Dim totalSolicitudes As Integer
    Public Property pageNum2() As Integer
        Get
            If (String.IsNullOrEmpty(Me.lblPageNum2.Text)) Then
                Return 1
            End If
            Return Convert.ToInt32(Me.lblPageNum2.Text)
        End Get
        Set(ByVal value As Integer)
            Me.lblPageNum2.Text = value
        End Set
    End Property

    Public Property PageSize2() As Int16
        Get
            If String.IsNullOrEmpty(Me.lblPageSize2.Text) Then
                Return BasePage.PageSize
            End If
            Return Int16.Parse(Me.lblPageSize2.Text)
        End Get
        Set(ByVal value As Int16)
            Me.lblPageSize2.Text = value
        End Set
    End Property
    Private Sub setNavigation2()

        Dim totalRecords2 As Integer = 0

        If IsNumeric(Me.lblTotalRegistros2.Text) Then
            totalRecords2 = CInt(Me.lblTotalRegistros2.Text)
        End If

        Dim totalPages2 As Double = Math.Ceiling(Convert.ToDouble(totalRecords2) / PageSize2)

        If totalRecords2 = 1 Or totalPages2 = 0 Then
            totalPages2 = 1
        End If

        If PageSize2 > totalRecords2 Then
            PageSize2 = Int16.Parse(totalPages2)
        End If

        Me.lblCurrentPage2.Text = pageNum2
        Me.lblTotalPages2.Text = totalPages2

        If pageNum2 = 1 Then
            Me.btnLnkFirstPage2.Enabled = False
            Me.btnLnkPreviousPage2.Enabled = False
        Else
            Me.btnLnkFirstPage2.Enabled = True
            Me.btnLnkPreviousPage2.Enabled = True
        End If

        If pageNum2 = totalPages2 Then
            Me.btnLnkNextPage2.Enabled = False
            Me.btnLnkLastPage2.Enabled = False
        Else
            Me.btnLnkNextPage2.Enabled = True
            Me.btnLnkLastPage2.Enabled = True
        End If

    End Sub

    Protected Sub NavigationLink_Click2(ByVal s As Object, ByVal e As CommandEventArgs)

        Select Case e.CommandName
            Case "First"
                pageNum2 = 1
            Case "Last"
                pageNum2 = Convert.ToInt32(lblTotalPages2.Text)
            Case "Next"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) + 1
            Case "Prev"
                pageNum2 = Convert.ToInt32(lblCurrentPage2.Text) - 1
        End Select

        bindEncabezado()

    End Sub
    Protected Function calcTotalSolicitudes() As Integer

        Dim total As Integer = 0
        Dim i As Integer = 0
        Dim dttotalSolicitudes As New DataTable
        dttotalSolicitudes = SolicitudesEnLinea.Solicitudes.getPageSolicitudes(CDate(Me.txtDesde.Text), CDate(Me.txtHasta.Text), 1, 9999)

        Dim dr As DataRow
        For Each dr In dttotalSolicitudes.Rows
            total = total + dttotalSolicitudes.Rows(i)("Solicitudes Trabajadas")
            i = i + 1
        Next
        Return total
    End Function

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dtExportar As New DataTable

        'cargamos el datatable con la información a exportar a excel
        dtExportar = SolicitudesEnLinea.Solicitudes.getSolicitudesGeneral(ddlStatus.Text, "0", ddlTipoServicio.Text, ViewState("fechaDesde"), ViewState("fechaHasta"), 1, 9999)

        'quitamos las columnas que no necesitamos del datatable
        dtExportar.Columns.Remove("RECORDCOUNT")
        dtExportar.Columns.Remove("NUM")
        dtExportar.Columns.Remove("ULT_USR_MODIFICO")
        dtExportar.Columns.Remove("ID_TIPO_SOLICITUD")
        dtExportar.Columns.Remove("STATUS")

        'procedemos a exportar a excel con el nombre del archivo customisado
        ucExportarExcel1.FileName = "Reporte de Solicitudes.xls"
        ucExportarExcel1.DataSource = dtExportar

    End Sub

#End Region

#Region "Navegacion Usuarios"
    'Public Property pageNum() As Integer
    'Get
    'If (String.IsNullOrEmpty(Me.lblPageNum.Text)) Then
    'Return 1
    'End If
    'Return Convert.ToInt32(Me.lblPageNum.Text)
    'End Get
    'Set(ByVal value As Integer)
    'Me.lblPageNum.Text = value
    'End Set
    'End Property
    'Public Property PageSize() As Int16
    'Get
    'If String.IsNullOrEmpty(Me.lblPageSize.Text) Then
    'Return BasePage.PageSize
    'End If
    'Return Int16.Parse(Me.lblPageSize.Text)
    'End Get
    'Set(ByVal value As Int16)
    'Me.lblPageSize.Text = value
    'End Set
    'End Property

    'Private Sub setNavigation()

    'Dim totalRecords As Integer = 0

    'If IsNumeric(Me.lblTotalRegistros.Text) Then
    'totalRecords = CInt(Me.lblTotalRegistros.Text)
    'End If

    'Dim totalPages As Double = Math.Ceiling(Convert.ToDouble(totalRecords) / PageSize)

    'If totalRecords = 1 Or totalPages = 0 Then
    'totalPages = 1
    'End If

    'If PageSize > totalRecords Then
    'PageSize = Int16.Parse(totalPages)
    'End If

    'Me.lblCurrentPage.Text = pageNum
    'Me.lblTotalPages.Text = totalPages

    'If pageNum = 1 Then
    'Me.btnLnkFirstPage.Enabled = False
    'Me.btnLnkPreviousPage.Enabled = False
    'Else
    'Me.btnLnkFirstPage.Enabled = True
    'Me.btnLnkPreviousPage.Enabled = True
    'End If

    'If pageNum = totalPages Then
    'Me.btnLnkNextPage.Enabled = False
    'Me.btnLnkLastPage.Enabled = False
    'Else
    'Me.btnLnkNextPage.Enabled = True
    'Me.btnLnkLastPage.Enabled = True
    'End If

    'End Sub
    Protected Sub NavigationLink_Click(ByVal s As Object, ByVal e As CommandEventArgs) Handles btnLnkPreviousPage.Command

        'Select Case e.CommandName
        'Case "First"
        'pageNum = 1
        'Case "Last"
        'pageNum = Convert.ToInt32(lblTotalPages.Text)
        'Case "Next"
        'pageNum = Convert.ToInt32(lblCurrentPage.Text) + 1
        'Case "Prev"
        'pageNum = Convert.ToInt32(lblCurrentPage.Text) - 1
        'End Select

        'gvUsuario(ViewState("solicitud").ToString)

    End Sub


    'Private Sub LimpiarUsuarios()
    'PageSize = BasePage.PageSize
    'lblMensajeUsuarios.Text = String.Empty
    'pageNum = 1
    'gvUsuario(ViewState("solicitud").ToString)
    'End Sub

#End Region


#Region "General"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack() Then
            GetTiposSolicitudes()
            GetUsuarios()
        End If
        pageNum2 = 1
        PageSize2 = BasePage.PageSize

    End Sub
    Private Sub GetTiposSolicitudes()
        ddlTipoServicio.DataSource = SolicitudesEnLinea.Solicitudes.getSolicitudesServicio()
        ddlTipoServicio.DataTextField = "TipoSolicitud"
        ddlTipoServicio.DataValueField = "IdTipo"
        ddlTipoServicio.DataBind()
        ddlTipoServicio.Items.Insert(0, New ListItem("--Todos--"))
    End Sub
    Private Sub GetUsuarios()
        Dim rol As New Seguridad.Role(48)
        Dim dt As DataTable
        dt = rol.getUsuariosTienenRole()

        If dt.Rows.Count > 0 Then
            ddlUsuario.DataSource = dt
            ddlUsuario.DataTextField = "nombre"
            ddlUsuario.DataValueField = "id_usuario"
            ddlUsuario.DataBind()
            ddlUsuario.Items.Insert(0, New ListItem("--Todos--", "0"))
        End If
    End Sub
    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ReporteGeneralSolicitudes.aspx")
    End Sub

#End Region

#Region "Solicitudes"
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        Me.lblMensaje.Text = String.Empty
        Me.pnlInfoEncabezado.Visible = False
        Me.pnlUsuarios.Visible = False
        gvUsuarios.DataSource = Nothing
        gvUsuarios.DataBind()

        If (Me.txtDesde.Text = String.Empty And (Not Me.txtHasta.Text = String.Empty)) Or (Me.txtHasta.Text = String.Empty And Not (Me.txtDesde.Text = String.Empty)) Then
            Me.lblMensaje.Text = "La fecha inicio y la fecha final son requeridas correctamente"
            Exit Sub
        ElseIf Not (Me.txtDesde.Text.Equals(String.Empty) And Me.txtHasta.Text.Equals(String.Empty)) Then
            If (CDate(Me.txtDesde.Text)) > (CDate(Me.txtHasta.Text)) Then
                Me.lblMensaje.Text = "La fecha inicio debe ser menor a la fecha final"
                Exit Sub
            Else
                ViewState("fechaDesde") = Me.txtDesde.Text
                ViewState("fechaHasta") = Me.txtHasta.Text

            End If
        Else
            ViewState("fechaDesde") = Date.MinValue
            ViewState("fechaHasta") = Date.MinValue
        End If
        bindEncabezado()

    End Sub
    Protected Sub bindEncabezado()
        Dim dt As New DataTable
        Me.lblMensaje.Text = String.Empty
        Try

            Dim date1 = ViewState("fechaDesde")
            Dim date2 = ViewState("fechaHasta")



            dt = SolicitudesEnLinea.Solicitudes.getSolicitudesGeneral(ddlStatus.Text, ddlUsuario.Text, ddlTipoServicio.Text, date1, date2, pageNum2, PageSize2)


            If dt.Rows.Count > 0 Then
                Me.pnlInfoEncabezado.Visible = True
                Me.pnlNavegacion2.Visible = True
                'Me.pnlInfoDetSolicitudes.Visible = False
                Me.lblTotalRegistros2.Text = dt.Rows(0)("RECORDCOUNT")
                gvInfoEncabezado.DataSource = dt
                gvInfoEncabezado.DataBind()
                'Me.lblTotalSolTrabajadas.Text = calcTotalSolicitudes()
                setNavigation2()
            Else
                Me.pnlInfoEncabezado.Visible = False
                Me.pnlNavegacion2.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros para estos criterios de búsqueda"
                Exit Sub
            End If

            dt = Nothing

        Catch ex As Exception

            Me.lblMensaje.Text = ex.Message

        End Try

    End Sub
    Protected Sub gvInfoEncabezado_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvInfoEncabezado.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells(1).Text.Equals("Registro de Empresa") And CInt(e.Row.Cells(8).Text) > 2 Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If


            If (e.Row.Cells(1).Text.Equals("Registro de N&#243;mina") And CInt(e.Row.Cells(10).Text) > 15) Then
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If
            If (e.Row.Cells(1).Text.Equals("Registro de N&#243;mina") And CInt(e.Row.Cells(9).Text) >= 1) Then
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If
            If (e.Row.Cells(1).Text.Equals("Registro de N&#243;mina") And CInt(e.Row.Cells(8).Text) >= 1) Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If


            If (e.Row.Cells(1).Text.Equals("Recuperaci&#243;n de Clave de Acceso") And CInt(e.Row.Cells(9).Text) = 8 And CInt(e.Row.Cells(10).Text) >= 1) Then
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If
            If (e.Row.Cells(1).Text.Equals("Recuperaci&#243;n de Clave de Acceso") And CInt(e.Row.Cells(9).Text) > 8) Then
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If
            If (e.Row.Cells(1).Text.Equals("Recuperaci&#243;n de Clave de Acceso") And CInt(e.Row.Cells(8).Text) >= 1) Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If


            'If (e.Row.Cells(1).Text.Equals("Registro de Novedades") And CInt(e.Row.Cells(10).Text) > 30) Then
            '    e.Row.Cells(10).BackColor = Drawing.Color.Red
            '    e.Row.BackColor = Drawing.Color.WhiteSmoke
            '    'e.Row.ForeColor = Drawing.Color.White
            'End If
            If (e.Row.Cells(1).Text.Equals("Registro de Novedades") And CInt(e.Row.Cells(9).Text) > 8) Then
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If
            If (e.Row.Cells(1).Text.Equals("Registro de Novedades") And CInt(e.Row.Cells(8).Text) >= 1) Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.Cells(9).BackColor = Drawing.Color.Red
                e.Row.Cells(10).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If


            If (e.Row.Cells(1).Text.Equals("Certificaciones") And CInt(e.Row.Cells(8).Text) > 2) Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If

            If (e.Row.Cells(1).Text.Equals("Informaci&#243;n P&#250;blica") And CInt(e.Row.Cells(8).Text) > 15) Then
                e.Row.Cells(8).BackColor = Drawing.Color.Red
                e.Row.BackColor = Drawing.Color.WhiteSmoke
                'e.Row.ForeColor = Drawing.Color.White
            End If

        End If

    End Sub
#End Region

#Region "Usuarios"
    'Protected Sub UcExp_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

    'Dim dtUsuarios As DataTable = SolicitudesEnLinea.Solicitudes.getHistoricoUsuarios(ViewState("solicitud").ToString)
    ''dtUsuarios.Columns.Remove("RECORDCOUNT")
    ''dtUsuarios.Columns.Remove("NUM")

    'ucExportarExcel1.FileName = "TareasPorSolicitud.xls"
    'ucExportarExcel1.DataSource = dtUsuarios

    'End Sub
    Protected Sub gvInfoEncabezado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoEncabezado.RowCommand
        If e.CommandName = "VerDetalle" Then

            'Me.pageNum = 1
            'Me.PageSize = BasePage.PageSize

            ViewState("solicitud") = e.CommandArgument
            gvUsuario(e.CommandArgument)

        End If
        If e.CommandName = "Ver" Then
            Response.Redirect("ManejoSolicitudesDetalle.aspx?NroSol=" & e.CommandArgument)
        End If
    End Sub
    Private Sub gvUsuario(ByVal solicitud As String)
        Try
            Me.pnlUsuarios.Visible = True
            Dim dtUsuarios As DataTable = SolicitudesEnLinea.Solicitudes.getHistoricoUsuarios(solicitud)
            If dtUsuarios.Rows.Count > 0 Then
                Me.gvUsuarios.DataSource = dtUsuarios
                Me.gvUsuarios.DataBind()
                Me.pnlUsuarios.Visible = True
                Me.lblMensajeUsuarios.Text = String.Empty
            Else
                Me.lblMensajeUsuarios.Text = "No hay data para mostrar"
                Me.gvUsuarios.DataSource = Nothing
                Me.gvUsuarios.DataBind()
            End If

        Catch ex As Exception
            Me.lblMensajeUsuarios.Text = ex.Message
        End Try

        'setNavigation()

    End Sub
#End Region



End Class
