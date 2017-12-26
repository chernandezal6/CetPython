Imports SuirPlus
Imports System.Data
Imports SuirPlus.Utilitarios

Partial Class sys_FormularioReclamacion
    Inherits BasePage
    Dim script As String
    Private Property RNC() As String
        Get
            If ViewState("RNC") Is Nothing Then
                Return -1
            Else
                Return ViewState("RNC")
            End If
        End Get
        Set(ByVal value As String)
            ViewState("RNC") = value
        End Set
    End Property

    Public Property NoReclamacion() As Integer
        Get
            If ViewState("NoReclamacion") Is Nothing Then
                Return -1
            Else
                Return ViewState("NoReclamacion")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("NoReclamacion") = value
        End Set
    End Property

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

        AfectarNP()

        LoadNPPagadas()

    End Sub

#End Region

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        CargarDatos()
    End Sub

    Private Sub CargarDatos()
        Try
            If Not Me.txtRNC.Text = String.Empty Or Not Me.txtCedula.Text = String.Empty Then

                'Diferente de certificacion
                If ddlTipoReclamacion.SelectedValue <> "23" Then
                    Dim RncCedula As String = IIf(String.IsNullOrEmpty(Me.txtRNC.Text) = True, Me.txtCedula.Text, Me.txtRNC.Text)
                    'Cargando los datos del empleador
                    Dim em As New Empresas.Empleador(RncCedula)

                    If Not em.RazonSocial = Nothing Then

                        Me.lblRazonSocial.Text = em.RazonSocial
                        Me.txtEmail.Text = em.Email
                        Me.txtContacto.Text = String.Empty
                        Me.txtCargo.Text = String.Empty
                        Me.UCTelefono1.PhoneNumber = em.Telefono1
                        Me.txtExt.Text = em.Ext1
                        Me.UCFax.PhoneNumber = em.Fax
                        Me.pnlInfo.Visible = True
                        Me.lblMensaje.Visible = False

                        Me.ddlTipoReclamacion.Enabled = False
                        Me.txtRNC.Enabled = False
                        Me.txtCedula.Enabled = False
                        Me.btnConsultar.Enabled = False
                        Me.RNC = em.RNCCedula

                        MostrarPaneles()
                    Else
                        Me.pnlInfo.Visible = False
                        Me.lblMensaje.Visible = True
                        Me.lblMensaje.Text = "RNC/Cédula Inválida"

                    End If

                Else
                    'Si es una certificacion
                    If trRNC.Visible = True Then
                        Dim RncCedula As String = IIf(String.IsNullOrEmpty(Me.txtRNC.Text) = True, Me.txtCedula.Text, Me.txtRNC.Text)
                        Dim em As New Empresas.Empleador(RncCedula)
                        If Not em.RazonSocial = Nothing Then

                            Me.lblRazonSocial.Text = em.RazonSocial
                            Me.txtEmail.Text = em.Email
                            Me.txtContacto.Text = String.Empty
                            Me.txtCargo.Text = String.Empty
                            Me.UCTelefono1.PhoneNumber = em.Telefono1
                            Me.txtExt.Text = em.Ext1
                            Me.UCFax.PhoneNumber = em.Fax
                            Me.RNC = em.RNCCedula

                            Me.ddlTipoCert.Enabled = False
                            Me.ddlTipoReclamacion.Enabled = False
                            Me.txtRNC.Enabled = False
                            Me.txtCedula.Enabled = False
                            Me.btnConsultar.Enabled = False

                            Me.pnlInfo.Visible = True
                            Me.pnlFirmas.Visible = True

                        End If
                    Else
                        tblEmpleador.Visible = False
                    End If

                    If trCedula.Visible = True Then
                        Dim tmpstr As String = SuirPlus.Utilitarios.TSS.consultaCiudadano("C", txtCedula.Text)

                        If Split(tmpstr, "|")(0) = "0" Then
                            lblNombre.Text = Split(tmpstr, "|")(1) & " " & Split(tmpstr, "|")(2)
                            lblNSS.Text = Split(tmpstr, "|")(3)
                            lblCedulaCiudadano.Text = Utilitarios.Utils.FormatearCedula(txtCedula.Text)

                            Me.ddlTipoCert.Enabled = False
                            Me.ddlTipoReclamacion.Enabled = False
                            Me.txtRNC.Enabled = False
                            Me.txtCedula.Enabled = False
                            Me.btnConsultar.Enabled = False

                            pnlInfo.Visible = True
                            pnlFirmas.Visible = True
                            tblCiudadano.Visible = True
                        Else
                            Me.lblMensaje.Text = "Cédula Inválida"
                        End If

                    End If
                End If
            Else
                Me.pnlInfo.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "RNC/Cédula requerida"
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try
    End Sub

    Private Sub MostrarPaneles()
        Me.pnlInfo.Visible = True
        Me.pnlBajaRNC.Visible = False
        Me.pnlCancelacionRef.Visible = False
        Me.pnlFirmas.Visible = False
        Me.pnlNotPagadas.Visible = False

        If Me.ddlTipoReclamacion.SelectedValue > 0 Then
            If (Me.ddlTipoReclamacion.SelectedValue = 20) Or (Me.ddlTipoReclamacion.SelectedValue = 21) Then
                'habilitar panel notificaciones de pago

                Dim dt As New DataTable
                dt = SolicitudesEnLinea.Solicitudes.getReferencias(Me.txtRNC.Text)
                If dt.Rows.Count > 0 Then
                    Me.pnlCancelacionRef.Visible = True
                    Me.pnlFirmas.Visible = True
                    gvNotificaciones.DataSource = dt
                    gvNotificaciones.DataBind()

                Else
                    Me.pnlInfo.Visible = False
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "No existe notificaciones de pago para este rnc\cédula"

                End If

            ElseIf Me.ddlTipoReclamacion.SelectedValue = 22 Then
                'habilitar panel baja empleador
                Me.pnlBajaRNC.Visible = True
                Me.pnlFirmas.Visible = True
            ElseIf Me.ddlTipoReclamacion.SelectedValue = 24 Then

                LoadNPPagadas()
                Me.pnlFirmas.Visible = True
                Me.pnlNotPagadas.Visible = True


            End If
        End If
    End Sub

    Private Sub LoadNPPagadas()
        Dim dtTSS As DataTable

        dtTSS = Empresas.Facturacion.Factura.getConsultaNotificaionesPorRNC(SuirPlus.Empresas.Facturacion.Factura.eConcepto.SDSS, Me.RNC, "6321", "PA", Me.PageSize, Me.pageNum)

        If dtTSS.Rows.Count > 0 Then
            Me.lblTotalRegistros.Text = dtTSS.Rows(0)("RECORDCOUNT")
            Me.gvNotPagadas.DataSource = dtTSS
            Me.gvNotPagadas.DataBind()
            Me.pnlNavigation.Visible = True
            setNavigation()
        Else
            Me.gvNotPagadas.DataSource = dtTSS
            Me.gvNotPagadas.DataBind()
            Me.pnlNavigation.Visible = False
        End If

    End Sub

    Protected Sub ddlTipoReclamacion_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTipoReclamacion.SelectedIndexChanged
        If ddlTipoReclamacion.SelectedValue = 23 Then

            binTiposCertificaciones()

            trRNC.Visible = False
            trCedula.Visible = False
            trCertificaciones.Visible = True
        ElseIf ddlTipoReclamacion.SelectedValue = 22 Then
            trRNC.Visible = True
            trCedula.Visible = False
            trCertificaciones.Visible = False
        Else
            trRNC.Visible = True
            trCedula.Visible = True
            trCertificaciones.Visible = False
        End If

        trBotones.Visible = True
    End Sub

    Private Sub binTiposCertificaciones()

        Dim dtTipos As DataTable = Empresas.Certificaciones.getTipoCertificacion(False)
        Me.ddlTipoCert.DataSource = dtTipos
        Me.ddlTipoCert.DataValueField = "ID_TIPO_CERTIFICACION"
        Me.ddlTipoCert.DataTextField = "TIPO_CERTIFICACION_DES"
        Me.ddlTipoCert.DataBind()
        Me.ddlTipoCert.Items.Insert(0, New ListItem("--Seleccione--", "0"))


    End Sub

    Protected Sub btnConsBaja1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsBaja1.Click

        Try
            If Not Me.txtBajaRncAct.Text = String.Empty Then
                Dim em As New Empresas.Empleador(Me.txtBajaRncAct.Text)
                If Not em.RazonSocial = Nothing Then

                    Me.lblRazonSocialActual.Text = em.RazonSocial
                    Me.pnlInfo.Visible = True
                    Me.lblMensaje.Visible = False
                Else
                    Me.pnlInfo.Visible = False
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "RNC/Cédula Inválida"
                End If
            Else
                Me.pnlInfo.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "RNC/Cédula requerida"
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnConsBaja2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsBaja2.Click

        Try
            If Not Me.txtBajaRncNoOpera.Text = String.Empty Then
                Dim em As New Empresas.Empleador(Me.txtBajaRncNoOpera.Text)
                If Not em.RazonSocial = Nothing Then

                    Me.lblRazonSocialNoOpera.Text = em.RazonSocial
                    Me.pnlInfo.Visible = True
                Else
                    Me.pnlInfo.Visible = False
                    Me.lblMensaje.Visible = True
                    Me.lblMensaje.Text = "RNC/Cédula Inválida"
                End If
            Else
                Me.pnlInfo.Visible = False
                Me.lblMensaje.Visible = True
                Me.lblMensaje.Text = "RNC/Cédula requerida"
            End If
        Catch ex As Exception
            Me.lblMensaje.Visible = True
            Me.lblMensaje.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Response.Redirect("FormularioReclamacion.aspx")
    End Sub

    Protected Sub ddlTipoCert_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTipoCert.SelectedIndexChanged

        If ddlTipoCert.SelectedValue = "7" Or ddlTipoCert.SelectedValue = "3" Or ddlTipoCert.SelectedValue = "A" Or ddlTipoCert.SelectedValue = "B" Or ddlTipoCert.SelectedValue = "9" Or ddlTipoCert.SelectedValue = "10" Then
            trCedula.Visible = True
            trRNC.Visible = False
        End If

        If ddlTipoCert.SelectedValue = "5" Or ddlTipoCert.SelectedValue = "6" Or ddlTipoCert.SelectedValue = "8" Or ddlTipoCert.SelectedValue = "4" Then
            trRNC.Visible = True
            trCedula.Visible = False
        End If

        If ddlTipoCert.SelectedValue = "4" Then
            trFechaDesde.Visible = True
            trFechaHasta.Visible = True
        Else
            trFechaDesde.Visible = False
            trFechaHasta.Visible = False
        End If

        If ddlTipoCert.SelectedValue = "2" Or ddlTipoCert.SelectedValue = "C" Then
            trCedula.Visible = True
            trRNC.Visible = True
        End If

        If ddlTipoCert.SelectedValue = "12" Then
            trCedula.Visible = False
            trRNC.Visible = True
        End If

    End Sub

    Private Sub AfectarNP()
        Dim myTable As New DataTable

        If Not IsNothing(ViewState("Table")) Then
            myTable = ViewState("Table")
        Else
            Dim dc As New DataColumn
            dc.ColumnName = "IdReferencia"
            myTable.Columns.Add(dc)

            Dim dc1 As New DataColumn
            dc1.ColumnName = "Check"
            myTable.Columns.Add(dc1)
        End If


        For Each grow As GridViewRow In gvNotPagadas.Rows
            myTable.DefaultView.RowFilter = "IdReferencia = '" & grow.Cells(0).Text & "'"

            If myTable.DefaultView.Count > 0 Then
                myTable.DefaultView.Table.Rows.RemoveAt(0)
            End If


            If CType(grow.FindControl("chkAfectar"), CheckBox).Checked Then

                Dim myrow0 As DataRow
                myrow0 = myTable.NewRow()
                myrow0("IdReferencia") = grow.Cells(0).Text
                myrow0("Check") = "S"

                myTable.Rows.Add(myrow0)
            End If

        Next

        ViewState("Table") = myTable
    End Sub

    Protected Sub gvNotPagadas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNotPagadas.RowDataBound
        If (e.Row.RowType = DataControlRowType.DataRow) Then
            Dim myTable As New DataTable

            If Not IsNothing(ViewState("Table")) Then
                myTable = ViewState("Table")

                myTable.DefaultView.RowFilter = "IdReferencia = '" & e.Row.Cells(0).Text & "'"

                If myTable.DefaultView.Count > 0 Then
                    CType(e.Row.FindControl("chkAfectar"), CheckBox).Checked = True
                End If
            End If
        End If
    End Sub

    Private Sub GetTiposSolicitudes()
        ddlTipoReclamacion.DataSource = SolicitudesEnLinea.Reclamaciones.getTiposSolicitudes
        ddlTipoReclamacion.DataTextField = "TipoSolicitud"
        ddlTipoReclamacion.DataValueField = "IdTipo"
        ddlTipoReclamacion.DataBind()
        ddlTipoReclamacion.Items.Insert(0, New ListItem("--Seleccione--"))
    End Sub

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            GetTiposSolicitudes()
        End If
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        GuardarSolicitud()
    End Sub

    Private Sub GuardarSolicitud()
        Dim certificacion As String = String.Empty

        If ddlTipoReclamacion.SelectedValue = "24" Then
            AfectarNP()
        ElseIf ddlTipoReclamacion.SelectedValue = "23" Then
            certificacion = ddlTipoCert.SelectedValue
        End If





        Dim result As String = String.Empty

        result = SolicitudesEnLinea.Reclamaciones.crearSolicitud(ddlTipoReclamacion.SelectedValue, txtRNC.Text, txtCedula.Text, String.Empty, Me.UsrUserName, txtMotivo.Text, certificacion)


        If Split(result, "|")(1) = "0" Then
            NoReclamacion = Split(result, "|")(0)


            If ddlTipoReclamacion.SelectedValue = "24" Then
                Dim myTable As New DataTable

                If Not IsNothing(ViewState("Table")) Then
                    myTable = ViewState("Table")

                    For i As Integer = 0 To myTable.Rows.Count - 1
                        SolicitudesEnLinea.Reclamaciones.crearDetSolicitud(NoReclamacion, txtRNC.Text, myTable.Rows(i)("IdReferencia").ToString())
                    Next
                End If

            ElseIf ddlTipoReclamacion.SelectedValue = "20" Or ddlTipoReclamacion.SelectedValue = "21" Then

                For i As Integer = 0 To gvNotificaciones.Rows.Count - 1
                    If CType(gvNotificaciones.Rows(i).FindControl("cblCancelacion"), CheckBox).Checked Then
                        SolicitudesEnLinea.Reclamaciones.crearDetSolicitud(NoReclamacion, txtRNC.Text, gvNotificaciones.Rows(i).Cells(0).Text)
                    End If
                Next
            End If


            pnlFinal.Visible = True
            Me.pnlInfo.Visible = False
            Me.pnlBajaRNC.Visible = False
            Me.pnlCancelacionRef.Visible = False
            Me.pnlFirmas.Visible = False
            Me.pnlNotPagadas.Visible = False
            Me.fsPrincipal.Visible = False
            Me.lblNoReclamacion.Text = NoReclamacion
            Me.lblTipoReclamacion.Text = ddlTipoReclamacion.SelectedItem.Text

            Dim script As String = "<script Language=JavaScript>" + "window.open('VerReclamacion.aspx?NoRec=" & NoReclamacion & "')</script>"

            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
        Else

            Dim script As String = "<script Language=JavaScript>" + "alert('Ha Ocurrido un error')</script>"

            Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)


        End If


    End Sub

    Protected Sub btnNuevaCert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNuevaCert.Click
        Response.Redirect("FormularioReclamacion.aspx")
    End Sub
End Class
