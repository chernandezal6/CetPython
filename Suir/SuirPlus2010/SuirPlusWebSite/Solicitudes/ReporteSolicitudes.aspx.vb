Imports SuirPlus
Imports System.Data

Partial Class Solicitudes_ReporteSolicitudes
    Inherits BasePage
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

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        'validamos los parametros
        Me.pnlInfoEncabezado.Visible = False

        If (Me.txtDesde.Text = String.Empty Or Me.txtDesde.Text.Length <> 10) Or (Me.txtHasta.Text = String.Empty Or Me.txtHasta.Text.Length <> 10) Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La fecha inicio y la fecha final son requeridas correctamente"
            Exit Sub
        ElseIf (CDate(Me.txtDesde.Text)) > (CDate(Me.txtHasta.Text)) Then
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = "La fecha inicio debe ser menor a la fecha final"
            Exit Sub
        End If
        bindEncabezado()
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("ReporteSolicitudes.aspx")
    End Sub

    Protected Sub bindEncabezado()
        Dim dt As New DataTable

        Try
            dt = SolicitudesEnLinea.Solicitudes.getPageSolicitudes(CDate(Me.txtDesde.Text), CDate(Me.txtHasta.Text), 1, 9999)

            If dt.Rows.Count > 0 Then
                Me.pnlInfoEncabezado.Visible = True
                Me.pnlInfoDetSolicitudes.Visible = False
                Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
                gvInfoEncabezado.DataSource = dt
                gvInfoEncabezado.DataBind()
                Me.lblTotalSolTrabajadas.Text = calcTotalSolicitudes()

            Else
                Me.pnlInfoEncabezado.Visible = False
                Me.pnlNavegacion2.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros para este rango de fechas"
                Exit Sub
            End If

            dt = Nothing

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try

    End Sub

    Protected Sub bindDetSolicitudes(ByVal solicitud As String)
        Dim dt2 As New DataTable
        Session.Remove("solicitud")

        Dim IdTipoSolicitud As String = Split(solicitud, "|")(0)
        Me.lblSolicitud.Text = Split(solicitud, "|")(1)
        Session("solicitud") = solicitud

        Try
            dt2 = SolicitudesEnLinea.Solicitudes.getPageDetSolicitudes(IdTipoSolicitud, CDate(Me.txtDesde.Text), CDate(Me.txtHasta.Text), pageNum2, PageSize2)
            If dt2.Rows.Count > 0 Then
                'limpiamos las variables de session utilizadas.

                Session.Remove("IdTipoSol")
                Session.Remove("TipoSol")
                Session.Remove("fechaDesde")
                Session.Remove("fechaHasta")
                Session.Remove("Registros")
                Me.pnlInfoDetSolicitudes.Visible = True
                Me.pnlInfoEncabezado.Visible = False
                Me.pnlNavegacion2.Visible = True
                Me.lblTotalRegistros2.Text = dt2.Rows(0)("RECORDCOUNT")
                gvDetSolicitudes.DataSource = dt2
                gvDetSolicitudes.DataBind()

                Session("IdTipoSol") = IdTipoSolicitud
                Session("TipoSol") = Me.lblSolicitud.Text
                Session("fechaDesde") = CDate(Me.txtDesde.Text)
                Session("fechaHasta") = CDate(Me.txtHasta.Text)
                Session("Registros") = Me.lblTotalRegistros2.Text

            Else
                Me.pnlInfoDetSolicitudes.Visible = False
                Me.pnlNavegacion2.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "No existen registros"
                Exit Sub
            End If

            dt2 = Nothing
            setNavigation2()

        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message

        End Try


    End Sub

    Protected Sub gvInfoEncabezado_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvInfoEncabezado.RowCommand
        If e.CommandName = "VerDetalle" Then

            Me.pageNum2 = 1
            Me.PageSize2 = BasePage.PageSize

            bindDetSolicitudes(e.CommandArgument)

        End If
    End Sub

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

        bindDetSolicitudes(Session("solicitud"))

    End Sub

    Protected Sub lbVolverEncabezado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbVolverEncabezado.Click
        Me.btnBuscar_Click(Nothing, Nothing)
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
        dtExportar = SolicitudesEnLinea.Solicitudes.getPageDetSolicitudes(Session("IdTipoSol"), Session("fechaDesde"), Session("fechaHasta"), 1, Session("Registros"))

        'quitamos las columnas que no necesitamos del datatable
        dtExportar.Columns.Remove("RECORDCOUNT")
        dtExportar.Columns.Remove("NUM")
        dtExportar.Columns.Remove("USUARIO")
        dtExportar.Columns.Remove("ID_TIPO_SOLICITUD")
        dtExportar.Columns.Remove("TIPOSOLICITUD")

        'procedemos a exportar a excel con el nombre del archivo customisado
        ucExportarExcel1.FileName = "Reporte de: " & Session("TipoSol") & ".xls"
        ucExportarExcel1.DataSource = dtExportar



    End Sub
End Class
