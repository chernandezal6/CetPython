Imports SuirPlus.Finanzas
Imports System.Data


Partial Class Finanzas_DevolucionAportes
    Inherits BasePage

    Private reclamacion As String
    Private rnc As String
    Private fechaDesde As String
    Private fechaHasta As String
    Private statusReclamacion As String

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

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize


        If Session("vfondosEntregados") <> String.Empty Then
            limpiarParametros()
            'llenamos las variables para los parametros esperados en la busqueda de reclamaciones
            Me.txtReclamacion.Text = Session("vfondosEntregados")
            Session.Remove("vfondosEntregados")
            Me.btnBuscar_Click(Nothing, Nothing)

        End If

        If Not Page.IsPostBack Then
            If Not (String.IsNullOrEmpty(Request.QueryString("rec"))) Then

                'llenamos las variables para los parametros esperados en la busqueda de reclamaciones
                Me.txtReclamacion.Text = Request.QueryString.Item("rec")
                Me.btnBuscar_Click(Nothing, Nothing)

            End If


            Dim dtStatus As System.Data.DataTable = DevolucionAportes.getStatusDA()

            'Cargando el dropdownlist de status
            ddlStatus.DataSource = dtStatus
            ddlStatus.DataTextField = "Descripcion"
            ddlStatus.DataValueField = "Id_Status"
            ddlStatus.DataBind()
            ddlStatus.Items.Insert(0, New ListItem("<--Todos-->", "T"))
            ddlStatus.SelectedValue = "T"
        End If



    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click
        Try
            'Ocultamos el contenido de la busqueda anterior
            pnlNavegacion.Visible = False

            ''validamos que al menos uno de los parametros se pase
            'If (Me.txtReclamacion.Text = String.Empty) And (Me.txtRNC.Text = String.Empty) And (Me.txtDesde.Text = Nothing) And (Me.txtHasta.Text = String.Empty) Then
            '    Me.lblMensaje.Visible = True
            '    Me.lblMensaje.Text = "Debe introducir uno de los parametros."
            '    pnlNavegacion.Visible = False
            '    Exit Sub
            'End If


            'validamos las fechas

            If (Me.txtDesde.Text <> String.Empty And Me.txtHasta.Text = String.Empty) Or (Me.txtDesde.Text = String.Empty And Me.txtHasta.Text <> String.Empty) Then
                Me.lblMensaje.Text = "Para buscar por rango de fechas necesita digitar la fecha desde y la fecha hasta."
                Exit Sub
            End If

            If (Me.txtDesde.Text <> String.Empty) And (Me.txtHasta.Text <> String.Empty) Then

                If (CDate(Me.txtHasta.Text)) < (CDate(Me.txtDesde.Text)) Then
                    Me.lblMensaje.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                    Exit Sub
                ElseIf (CDate(Me.txtDesde.Text)) > (CDate(Me.txtHasta.Text)) Then
                    Me.lblMensaje.Text = "La fecha desde, debe ser menor que la fecha hasta."
                    Exit Sub
                End If

            End If


            CargarReclamaciones()


        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click
        Response.Redirect("DevolucionAportes.aspx")
    End Sub

    Private Sub CargarReclamaciones()

        'llenamos las variables para los parametros esperados en la busqueda de reclamaciones
        reclamacion = Me.txtReclamacion.Text
        rnc = Me.txtRNC.Text
        fechaDesde = Me.txtDesde.Text
        fechaHasta = Me.txtHasta.Text

        'If (ddlStatus.SelectedValue = "AP") Or (ddlStatus.SelectedValue = "EP") Then
        '    statusReclamacion = "AP,EP"
        'ElseIf (ddlStatus.SelectedValue = "RE") Or (ddlStatus.SelectedValue = "CA") Then
        '    statusReclamacion = "RE,CA"
        'Else
        '    statusReclamacion = Me.ddlStatus.SelectedValue
        'End If

        statusReclamacion = Me.ddlStatus.SelectedValue

        Dim dt As New DataTable
        dt = DevolucionAportes.getReclamaciones(fechaDesde, fechaHasta, rnc, reclamacion, statusReclamacion, Me.pageNum, Me.PageSize)

        If dt.Rows.Count > 0 Then

            Me.lblTotalRegistros.Text = dt.Rows(0)("RECORDCOUNT")
            Me.gvDevoluciones.DataSource = dt
            Me.gvDevoluciones.DataBind()
            Me.pnlNavegacion.Visible = True
        Else
            Me.pnlNavegacion.Visible = False
            Me.gvDevoluciones.DataSource = Nothing
            Me.gvDevoluciones.DataBind()
            Me.lblMensaje.Text = "No existen registros para esta busqueda"
        End If

        dt = Nothing
        setNavigation()

    End Sub

    Protected Sub gvDevoluciones_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvDevoluciones.RowCommand

        Dim rec = e.CommandArgument.ToString.Split("|")(0)
        Dim rnc = e.CommandArgument.ToString.Split("|")(1)
        Dim rs = e.CommandArgument.ToString.Split("|")(2)
        Dim statusRec = e.CommandArgument.ToString.Split("|")(3)
        Try
            If e.CommandName.ToString = "DET" Then
                Response.Redirect("~/finanzas/DetDevolucionAportes.aspx?rec=" & rec & "&rnc=" & rnc & "&rs=" & rs & "&statusRec=" & statusRec)

            ElseIf (e.CommandName.ToString = "CAN") Then

                'Marcamos como cancelada esta reclamacion
                MarcarReclamacion(rec, "CA")
            ElseIf (e.CommandName.ToString = "COM") Then

                'Marcamos como COMPLETADA esta reclamacion
                MarcarReclamacion(rec, "ES")
            ElseIf (e.CommandName.ToString = "APR") Then

                'Marcamos como APROBADA esta reclamacion
                MarcarReclamacion(rec, "EN")
            ElseIf (e.CommandName.ToString = "ENV") Then

                'enviar a unipago
                EnviarUNIPAGO(rec)

            End If

            CargarReclamaciones()
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub gvDevoluciones_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvDevoluciones.RowDataBound

        ''Si el usuario tiene el permiso necesario muestra el link 
        Dim IdStatus As New Label

        If e.Row.RowType = DataControlRowType.DataRow Then

            IdStatus.Text = CType(e.Row.FindControl("lblIdStatus"), Label).Text

            If (e.Row.Cells(4).Text = "0") Then

                CType(e.Row.FindControl("lbCancelar"), LinkButton).Text = "Cancelar"

                If (Me.IsInPermiso("266")) And ((IdStatus.Text = "AP") Or (IdStatus.Text = "EP")) Then

                    CType(e.Row.FindControl("lbCancelar"), LinkButton).Visible = True
                Else
                    CType(e.Row.FindControl("lbCancelar"), LinkButton).Visible = False
                End If

                CType(e.Row.FindControl("lbDetalle"), LinkButton).Visible = False
                CType(e.Row.FindControl("lbCompletado"), LinkButton).Visible = False
                CType(e.Row.FindControl("lbAprobado"), LinkButton).Visible = False
                CType(e.Row.FindControl("lbEnviar"), LinkButton).Visible = False
            Else

                CType(e.Row.FindControl("lbDetalle"), LinkButton).Visible = True

                If (Me.IsInPermiso("266")) And ((IdStatus.Text = "AP") Or (IdStatus.Text = "EP")) Then
                    CType(e.Row.FindControl("lbCancelar"), LinkButton).Visible = True
                Else
                    CType(e.Row.FindControl("lbCancelar"), LinkButton).Visible = False
                End If

                If (Me.IsInPermiso("267")) And (IdStatus.Text = "EP") Then
                    CType(e.Row.FindControl("lbCompletado"), LinkButton).Visible = True
                Else
                    CType(e.Row.FindControl("lbCompletado"), LinkButton).Visible = False
                End If

                If Me.IsInPermiso("268") And (IdStatus.Text = "ES") Then
                    CType(e.Row.FindControl("lbAprobado"), LinkButton).Visible = True
                Else
                    CType(e.Row.FindControl("lbAprobado"), LinkButton).Visible = False
                End If

                If Me.IsInPermiso("269") And (IdStatus.Text = "EN") Then
                    CType(e.Row.FindControl("lbEnviar"), LinkButton).Visible = True
                Else
                    CType(e.Row.FindControl("lbEnviar"), LinkButton).Visible = False
                End If

            End If
        End If

    End Sub

    Protected Sub MarcarReclamacion(ByVal reclamacion As String, ByVal status As String)
        Try

            DevolucionAportes.MarcarReclamacion(reclamacion, status)

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try


    End Sub

    Protected Sub EnviarUNIPAGO(ByVal reclamacion As String)

        Try
            DevolucionAportes.EnviarUNIPAGO(reclamacion)

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

    Protected Sub ucExportarExcel1_ExportaExcel(ByVal sender As Object, ByVal e As System.EventArgs) Handles ucExportarExcel1.ExportaExcel

        Dim dt As New DataTable
        dt = DevolucionAportes.getReclamaciones(Me.txtDesde.Text, Me.txtHasta.Text, Me.txtRNC.Text, Me.txtReclamacion.Text, Me.ddlStatus.SelectedValue, 1, Me.lblTotalRegistros.Text)
        dt.Columns.Remove("RECORDCOUNT")
        dt.Columns.Remove("NUM")
        Me.ucExportarExcel1.FileName = "Devolucion Aportes.xls"
        ucExportarExcel1.DataSource = dt

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

        CargarReclamaciones()

    End Sub

    'Private Sub RegistrarTransFondos(ByVal Nroreclamacion As String)
    '    'cargamos la reclamacion en curso en una variable de session para reutilizarla cuando se cierre el popup window que estamos creando
    '    'esta variable funcionara como un queryString para esta misma pagina.
    '    Session("vfondosEntregados") = Nroreclamacion
    '    Dim popupScript As String = "<script language='javascript'>" & _
    '      "window.open('Entregafondos.aspx?rec=" + Nroreclamacion + "', 'CustomPopUp', " & _
    '      "'width=450, height=300, menubar=no, resizable=no')" & _
    '      "</script>"

    '    ClientScript.RegisterStartupScript(Me.GetType(), "popup", popupScript)

    'End Sub 

    'Public Function getStatus(ByVal status As String) As String

    '    'asignamos el código del estatus de la reclamación al parametro
    '    If status.ToUpper = "EN PROCESO" Then
    '        statusReclamacion = "EP"
    '    ElseIf status.ToUpper = "APERTURA" Then
    '        statusReclamacion = "AP"
    '    ElseIf status.ToUpper = "EN ESPERA REPUESTA" Then
    '        statusReclamacion = "EN"
    '    ElseIf status.ToUpper = "PENDIENTE DEVOLUCION" Then
    '        statusReclamacion = "OK"
    '    ElseIf status.ToUpper = "COMPLETADO" Then
    '        statusReclamacion = "CP"
    '    ElseIf status.ToUpper = "CANCELADA" Then
    '        statusReclamacion = "CA"
    '    ElseIf status.ToUpper = "RECHAZADA" Then
    '        statusReclamacion = "RE"
    '    End If
    '    Return statusReclamacion

    'End Function

    Private Sub limpiarParametros()

        Me.txtReclamacion.Text = String.Empty
        Me.txtRNC.Text = String.Empty
        Me.txtDesde.Text = String.Empty
        Me.txtHasta.Text = String.Empty
        Me.ddlStatus.SelectedValue = "T"

    End Sub

End Class
