Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios
Imports SuirPlus.Operaciones
Imports SuirPlus.Empresas

Partial Class Consultas_consEmpleador
    Inherits BasePage
    Dim ImagenMod() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
#Region "Propiedades"

    Protected Property pageNum() As Integer
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

    Protected Property PageSize() As Int16
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

    ''' <summary>
    ''' Propiedad de Registro Patronal guardada en el Viewstate.
    ''' </summary>
    ''' <value>Un integer que respresenta el Registro Patronal</value>
    ''' <returns>Un integer que respresenta el Registro Patronal</returns>
    ''' <remarks></remarks>
    Protected Property RegistroPatronal() As Integer
        Get
            Return ViewState("RegPatronal")
        End Get
        Set(ByVal value As Integer)
            ViewState("RegPatronal") = value
        End Set
    End Property

    ''' <summary>
    ''' Propiedad de RNC guardada en el Viewstate.
    ''' </summary>
    ''' <value>Una Cadena que representa el RNC</value>
    ''' <returns>Una Cadena que representa el RNC</returns>
    ''' <remarks></remarks>
    Public Property RNC() As String
        Get
            Return ViewState("RNC")
        End Get
        Set(ByVal value As String)
            ViewState("RNC") = value
        End Set
    End Property

    ''' <summary>
    ''' Propiedad de IDRepresentante guardada en el Viewstate.
    ''' </summary>  
    Public Property IDRepresentante() As String
        Get
            Return ViewState("IDRepresentante")
        End Get
        Set(ByVal value As String)
            ViewState("IDRepresentante") = value
        End Set
    End Property

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("rnc")) Then
                Me.txtRNC.Text = Request.QueryString("rnc")
                'Invokamos el metodo de buscar
                Me.btnBuscar_Click(Nothing, Nothing)
            End If
            Session.Remove("TienePermiso")

            If Me.IsInPermiso("324") Then
                Session("TienePermiso") = "SI"
            Else
                Session("TienePermiso") = "NO"

            End If
        End If

        Me.ucRepresentante.ShowPasaporte = False

    End Sub

    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscar.Click

        'Si todos los campos estan vacios entonces mostramos un mensaje.
        If String.IsNullOrEmpty(Me.txtNombreComercial.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtRazonSocial.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtRegPatronal.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtRNC.Text) _
        AndAlso String.IsNullOrEmpty(Me.txtTelefono.Text) Then

            Me.lblMensaje.Text = "Debe especificar algún criterio."
            Exit Sub

        End If

        Me.pageNum = 1
        Me.PageSize = BasePage.PageSize
        Me.lblTotalRegistros.Text = 0
        Me.Tabs.ActiveTabIndex = 0

        bindGrid()

    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiar.Click

        Me.txtRNC.Text = String.Empty
        Me.txtRegPatronal.Text = String.Empty
        Me.txtRazonSocial.Text = String.Empty
        Me.txtNombreComercial.Text = String.Empty
        Me.txtTelefono.Text = String.Empty

        Dim tmpDt As DataTable = Nothing
        Me.gvEmpleadores.DataSource = tmpDt
        Me.gvEmpleadores.DataBind()

        Me.hideGridEmpleadores()
        Me.hideTabs()

    End Sub

#Region "Grid Empleadores and Navigation"


    Protected Sub bindGrid()

        Dim tmpDT As DataTable = Nothing
        Dim regPatronal As Integer = Nothing

        If Not String.IsNullOrEmpty(Me.txtRegPatronal.Text) Then
            If IsNumeric(Me.txtRegPatronal.Text) Then
                regPatronal = Me.txtRegPatronal.Text
            End If
        End If

        tmpDT = Empresas.Empleador.consultaEmpleador(regPatronal, txtRNC.Text, _
                                txtNombreComercial.Text, txtRazonSocial.Text, txtTelefono.Text, Me.pageNum, Me.PageSize)


        If tmpDT.Rows.Count > 0 Then

            'Si solo viene un registro llenamos los paneles directamente y no mostramos el grid.
            If tmpDT.Rows.Count = 1 Then

                Me.RegistroPatronal = CInt(tmpDT.Rows(0)("ID_REGISTRO_PATRONAL").ToString())
                Me.RNC = tmpDT.Rows(0)("RNC_O_CEDULA").ToString()

                'Colocamos los link para ver notificaciones y otros
                setLink()

                'Cargamos el tabs de generales.
                cargarGenerales()

                'Ocultamos grid y actualizamos el updatepanel.
                hideGridEmpleadores()
                Me.upTabs.Update()
                Me.showTabs()

            Else

                'Mostramos el grid con los resultados.
                Me.lblTotalRegistros.Text = tmpDT.Rows(0)("RECORDCOUNT")
                Me.gvEmpleadores.DataSource = tmpDT
                Me.gvEmpleadores.DataBind()
                Me.hideTabs()
                showGridEmpleadores()

            End If

        Else
            Me.btnLnkFirstPage.Enabled = False
            Me.btnLnkLastPage.Enabled = False
            Me.btnLnkNextPage.Enabled = False
            Me.btnLnkPreviousPage.Enabled = False
            Me.pnlGridEmpleadores.Visible = True
            Me.hideGridEmpleadores()
            Me.hideTabs()
            Me.lblMensaje.Text = "No se encontró empleador(es)."
        End If

        setNavigation()

    End Sub

    Protected Sub gvEmpleadores_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEmpleadores.RowCommand

        If e.CommandName = "Ver" Then
            Me.RegistroPatronal = CInt(e.CommandArgument.ToString.Split("|")(0))
            Me.RNC = e.CommandArgument.ToString.Split("|")(1)

            'Colocamos los link para ver notificaciones y otros
            setLink()

            cargarGenerales()

            Me.pnlGridEmpleadores.Visible = False
            Me.upEmpleadores.Update()
            Me.showTabs()
        End If

    End Sub

    Protected Sub gvEmpleadores_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvEmpleadores.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            e.Row.Cells(0).Text = Utils.FormatearRNCCedula(e.Row.Cells(0).Text)
            e.Row.Cells(4).Text = Utils.FormatearTelefono(e.Row.Cells(4).Text)
            e.Row.Cells(5).Text = Utils.FormatearTelefono(e.Row.Cells(5).Text)

            If Not String.IsNullOrEmpty(Me.txtRazonSocial.Text) Then
                e.Row.Cells(2).Text = Utils.HighlightText(Me.txtRazonSocial.Text, e.Row.Cells(2).Text)
            End If

            If Not String.IsNullOrEmpty(Me.txtNombreComercial.Text) Then
                e.Row.Cells(3).Text = Utils.HighlightText(Me.txtRazonSocial.Text, e.Row.Cells(3).Text)
            End If

        End If

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

#End Region

#Region "Llena Paneles"

    Protected Sub cargarGenerales()
        Try

            If Not Me.RegistroPatronal = Nothing Then
                Me.lblFechaRegistro.Text = String.Empty
                Me.lblFechaConstitucion.Text = String.Empty
                Me.lblFechaInicioOperacion.Text = String.Empty
                lblMensajeInforme.Text = String.Empty
                btnCargarInforme.Enabled = True
                txtDescripcionInforme.Text = String.Empty

                Dim emp As New Empresas.Empleador(Me.RegistroPatronal)
                Me.lblRNC.Text = emp.RNCCedula
                Me.lblRegPatronal.Text = emp.RegistroPatronal
                Me.lblRazonSocial.Text = emp.RazonSocial
                Me.lblNombreComercial.Text = emp.NombreComercial
                Me.lblSectorEconomico.Text = emp.SectorEconomico
                Me.lblCapital.Text = FormatNumber(emp.Capital)
                Me.lblSectorSalarial.Text = emp.SectorSalarial
                Me.lblSalarioMinimoVigente.Text = String.Format("{0:n}", emp.SalarioMinimoVigente)

                'Me.hplinkDoc.NavigateUrl = "VerDocumentos.aspx?idReg=" & emp.RegistroPatronal
                'Me.lnkAnexar.NavigateUrl = "AnexarDocumento.aspx?idReg=" & emp.RegistroPatronal & "&usuario=" & Me.UsrUserName & "&accion=Anexar"
                'Me.lnkSubir.NavigateUrl = "AnexarDocumento.aspx?idReg=" & emp.RegistroPatronal & "&usuario=" & Me.UsrUserName & "&accion=Subir"
                Me.hplinkDoc.Attributes.Add("OnClick", "javascript:poptastic('VerDocumentos.aspx?idReg=" & emp.RegistroPatronal & "');")
                Me.lnkAnexar.Attributes.Add("OnClick", "javascript:poptastic('AnexarDocumento.aspx?idReg=" & emp.RegistroPatronal & "&usuario=" & Me.UsrUserName & "&accion=Anexar');")
                Me.lnkSubir.Attributes.Add("OnClick", "javascript:poptastic('AnexarDocumento.aspx?idReg=" & emp.RegistroPatronal & "&usuario=" & Me.UsrUserName & "&accion=Subir');")

                If emp.Estatus = "B" Then
                    lblEstatus.CssClass = "error"
                    lblEstatus.Font.Size = 10
                    Me.lblEstatus.Text = "DE BAJA"
                ElseIf emp.Estatus = "S" Then
                    lblEstatus.CssClass = "error"
                    lblEstatus.Font.Size = 10
                    Me.lblEstatus.Text = "SUSPENDIDO"
                Else
                    Me.lblEstatus.Text = "ACTIVO"
                    lblEstatus.CssClass = "labelData"
                    lblEstatus.Font.Size = 8
                End If
                'Me.lblEstatus.Text = IIf(emp.Estatus = "A", "ACTIVO", "DE BAJA")

                Me.lblOficioNro.Text = IIf(emp.IDOficio = "-1", "N/A", emp.IDOficio)
                Me.lblCategoriaRiesgo.Text = emp.IDRiesgo & " Factor de Riesgo (" & emp.FactorRiesgo & "%)"
                Me.lblTipoEmpresa.Text = emp.TipoEmpresaDescripcion

                If emp.PagaInfotep = "S" Then
                    Me.lblPagaInfotep.Text = "SI"
                    Me.lblPagaInfotep.CssClass = "labelData"
                Else
                    Me.lblPagaInfotep.Text = "NO"
                    Me.lblPagaInfotep.CssClass = "error"
                End If

                If emp.PagoDiscapacidad = String.Empty Or emp.PagoDiscapacidad = "N" Then
                    Me.lblPagoRectroActivo.Text = "NO"
                    Me.lblPagoRectroActivo.CssClass = "error"
                Else
                    Me.lblPagoRectroActivo.Text = "SI"
                    Me.lblPagoRectroActivo.CssClass = "labelData"

                End If

                If emp.PermitirPago Then
                    Me.lblPermitirPago.Text = "SI"
                    Me.lblPermitirPago.CssClass = "labelData"
                Else
                    Me.lblPermitirPago.Text = "NO"
                    Me.lblPermitirPago.CssClass = "error"
                End If

                If emp.isMovimientoPendiente Then
                    Me.lblMovimientos.Text = "<a class='error' href='../Novedades/ConsultaMovimientos.aspx?RegPat=" & emp.RegistroPatronal & "'>SI [Ver Movimientos]</a>"
                    Me.lblMovimientos.CssClass = "a.Flag"
                Else
                    Me.lblMovimientos.Text = "NO"
                    Me.lblMovimientos.CssClass = "labelData"
                End If

                'Me.lblPermitirPago.Text = IIf(emp.PermitirPago, "SI", "NO")
                Me.lblTieneAcuerdo.Text = IIf(emp.TieneAcuerdoDePago, "SI", "NO")
                Me.lblEncuestaCompletada.Text = IIf(emp.CompletoEncuesta, "SI", "NO")
                Me.lblEmail.Text = emp.Email
                Me.lblTelefono1.Text = Utils.FormatearTelefono(emp.Telefono1)

                'Agregamos la extension al telefono 1
                If Not String.IsNullOrEmpty(emp.Ext1) Then
                    Me.lblTelefono1.Text += " Ext. " & emp.Ext1
                End If

                Me.lblTelefono2.Text = Utils.FormatearTelefono(emp.Telefono2)

                If Not String.IsNullOrEmpty(emp.Ext2) Then
                    Me.lblTelefono2.Text += " Ext. " & emp.Ext2
                End If

                Me.lblFax.Text = Utils.FormatearTelefono(emp.Fax)
                Me.lblAdministracionLocal.Text = emp.AdministradoraLocal
                Me.lblCalle.Text = emp.Calle
                Me.lblNumero.Text = emp.Numero
                Me.lblEdificio.Text = emp.Edificio
                Me.lblPiso.Text = emp.Piso
                Me.lblApartamento.Text = emp.Apartamento
                Me.lblSector.Text = emp.Sector
                Me.lblMunicipio.Text = emp.Municipio
                Me.lblProvincia.Text = emp.Provincia

                If emp.FechaRegistro <> Nothing Then
                    Me.lblFechaRegistro.Text = String.Format("{0:d}", emp.FechaRegistro)
                End If

                If emp.FechaConstitucion <> Nothing Then
                    Me.lblFechaConstitucion.Text = String.Format("{0:d}", emp.FechaConstitucion)
                End If

                If emp.FechaIniciaActividades <> Nothing Then
                    Me.lblFechaInicioOperacion.Text = String.Format("{0:d}", emp.FechaIniciaActividades)
                End If
                'Verificamos si activamos el boton de marcar para rectificacion.
                Select Case emp.StatusCobro
                    Case Empresas.StatusCobrosType.Auditoria

                        lnkBtnMarcarEmp.Visible = False

                    Case Empresas.StatusCobrosType.Cobros

                        lnkBtnMarcarEmp.Visible = False

                    Case Empresas.StatusCobrosType.Legal

                        lnkBtnMarcarEmp.Visible = False
                        lnkBtnMarcarEmp.Text = String.Empty

                        'lnkBtnMarcarEmp.Visible = True
                        'lnkBtnMarcarEmp.CommandArgument = "Legal"
                        'lnkBtnMarcarEmp.Text = "[Permitir envío de Novedades Retroactivas]"
                        'Me.lblObservacion.Text = "El empleador está bloqueado, no permite envio de Novedades Retroactivas"
                        'Me.lblObservacion.Visible = True

                    Case Empresas.StatusCobrosType.Rectificacion

                        lnkBtnMarcarEmp.Visible = True
                        lnkBtnMarcarEmp.CommandArgument = "Rectificacion"
                        lnkBtnMarcarEmp.Text = "[Bloquear envío de Novedades Retroactivas]"
                        Me.lblObservacion.Text = "El empleador está en proceso de Rectificacion"
                        Me.lblObservacion.Visible = True

                    Case Empresas.StatusCobrosType.Normal

                        lnkBtnMarcarEmp.Visible = True
                        lnkBtnMarcarEmp.CommandArgument = "Bloquear"
                        lnkBtnMarcarEmp.Text = "[Bloquear envío de Novedades Retroactivas]"

                        Me.lblObservacion.Text = String.Empty
                        lnkBtnMarcarEmp.Visible = False

                End Select

                'para visualizar el linkButton de permitir envio de novedades retroactivas
                lnkBtnMarcarEmp.Visible = Me.IsInPermiso("166")


            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub cargarRepresentante()
        Me.lnkNuevoRep.Visible = Me.IsInPermiso("91")
        Me.dtRepresentante.DataSource = Empresas.Representante.getRepresentante(-1, Me.RegistroPatronal)
        Me.dtRepresentante.DataBind()
        Me.upRepresentantes.Update()

        'Limpiando control representante
        Me.ucRepresentante.iniForm()
        Me.btnCancelar_Click(Nothing, Nothing)

    End Sub

    Protected Sub cargarNomina()

        Me.gvNominas.DataSource = Empresas.Nomina.consultaNomina(Me.RegistroPatronal)
        Me.gvNominas.DataBind()
        Me.upNominas.Update()

    End Sub

    Protected Sub cargarCMRRegistros()

        'Cargando tipos de acciones
        Me.ddlTipoCaso.DataSource = Empresas.CRM.getTiposCRM(-1)
        Me.ddlTipoCaso.DataTextField = "TIPO_REGISTRO_DES"
        Me.ddlTipoCaso.DataValueField = "ID_TIPO_REGISTRO"
        Me.ddlTipoCaso.DataBind()
        Me.ddlTipoCaso.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))

        Me.txtFechaNotificacion.Text = Date.Now.ToString

        bindCRMDataList()

    End Sub

    Protected Sub ddlTipoCaso_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlTipoCaso.SelectedIndexChanged
        If Me.ddlTipoCaso.SelectedValue = 8 Then
            'Cargando tipos de acciones

            Dim dtTipo As DataTable
            dtTipo = SuirPlus.SolicitudesEnLinea.Solicitudes.getTiposSolicitudes()

            Me.ddlTipoSolicitud.DataSource = dtTipo
            Me.ddlTipoSolicitud.DataTextField = "TipoSolicitud"
            Me.ddlTipoSolicitud.DataValueField = "IdTipo"
            Me.ddlTipoSolicitud.DataBind()
            Me.ddlTipoSolicitud.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
            Me.trTipoSolicitudes.Visible = True

        Else
            Me.trTipoSolicitudes.Visible = False

        End If

        bindCRMDataList()

    End Sub

    Protected Sub cargarCRMReportes()

        'Cargando tipos de acciones
        Me.ddlTipoCasosRep.DataSource = Empresas.CRM.getTiposCRM(-1)
        Me.ddlTipoCasosRep.DataTextField = "TIPO_REGISTRO_DES"
        Me.ddlTipoCasosRep.DataValueField = "ID_TIPO_REGISTRO"
        Me.ddlTipoCasosRep.DataBind()
        Me.ddlTipoCasosRep.Items.Insert(0, New ListItem("<-- Todos -->", "-1"))

    End Sub

    Protected Sub cargarCRMUltimaAccion()

        'Cargando oficios
        Me.dlOficios.DataSource = Empresas.Empleador.getUtimosOficios(Me.RegistroPatronal)
        Me.dlOficios.DataBind()

        'Cargando certificaciones
        Me.dlCertificaciones.DataSource = Empresas.Empleador.getUtimosCert(Me.RegistroPatronal)
        Me.dlCertificaciones.DataBind()

    End Sub

    Protected Sub cargarLegal()

        Dim dtAcuerdos As DataTable = Nothing
        Dim dtNotificaciones As DataTable = Nothing

        Try
            'Llenamos el grid de acuerdos
            dtAcuerdos = SuirPlus.Legal.AcuerdosDePago.getAcuerdosPorEmpleador(SuirPlus.Legal.eTiposAcuerdos.Todos, Me.RegistroPatronal)
            If dtAcuerdos.Rows.Count > 0 Then
                Me.gvAcuerdos.DataSource = dtAcuerdos
                Me.gvAcuerdos.DataBind()
            Else
                Me.gvAcuerdos.DataSource = Nothing
                Me.gvAcuerdos.DataBind()
                Me.lblAcuerdosRealizado.Text = "No hay acuerdos realizados"
            End If

            'Llenamos el grid de notificaciones
            dtNotificaciones = SuirPlus.Legal.AcuerdosDePago.getNotificacionesPorEmpleador(Me.RegistroPatronal)
            If dtNotificaciones.Rows.Count > 0 Then
                Me.gvNotificaciones.DataSource = dtNotificaciones
                Me.gvNotificaciones.DataBind()
            Else
                Me.gvNotificaciones.DataSource = Nothing
                Me.gvNotificaciones.DataBind()
                Me.lblNotificacionesEmitidas.Text = "No hay Notificaciones emitidas"
            End If

        Catch ex As Exception
            Me.lblAcuerdosMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub cargarSFS()

        Dim dtCuenta As DataTable = SuirPlus.Empresas.CuentaBancaria.GetCuenta(Me.RegistroPatronal, String.Empty)

        If dtCuenta.Rows.Count > 0 Then
            lblNumeroCuenta.Text = dtCuenta.Rows(0)("NroCuenta").ToString()
            lblEntidadRecaudadora.Text = dtCuenta.Rows(0)("EntidadRecaudadora").ToString()
            lblTipoCuenta.Text = dtCuenta.Rows(0)("TipoCuenta").ToString()
        End If

    End Sub

    Protected Sub cargarInformes()

        'Cargando los informes
        Me.gvListadoInformes.DataSource = Empresas.Empleador.getInformesAuditoria(Me.RegistroPatronal)
        Me.gvListadoInformes.DataBind()

       
    End Sub

#End Region

#Region "CRM"

    Protected Sub bindCRMDataList()
        'Cargamos los ultimos registros
        Me.dlUltimosRegistros.DataSource = Empresas.CRM.getUtimosCRM(Me.RegistroPatronal)
        Me.dlUltimosRegistros.DataBind()

    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click

        'Validaciones
        If Me.ddlTipoCaso.SelectedValue = "-1" Then
            Me.lblMensajeCRM.Text = "Debe seleccionar un tipo de caso."
            Exit Sub
        End If

        If String.IsNullOrEmpty(Me.txtAsunto.Text) Then
            Me.lblMensajeCRM.Text = "Debe específicar el asunto."
            Exit Sub
        End If

        If String.IsNullOrEmpty(Me.txtContacto.Text) Then
            Me.lblMensajeCRM.Text = "Debe específicar el contacto."
            Exit Sub
        End If

        If String.IsNullOrEmpty(Me.txtDescripcion.Text) Then
            Me.lblMensajeCRM.Text = "Debe específicar la descripción"
            Exit Sub
        End If

        If Me.chkNotificame.Checked = True Then
            If String.IsNullOrEmpty(Me.txtFechaNotificacion.Text) Then
                Me.lblMensajeCRM.Text = "Debe específicar la fecha de notificación."
                Exit Sub
            End If
        End If

        Dim FechaNotificacion As Nullable(Of Date)
        If Me.chkNotificame.Checked Then
            FechaNotificacion = CDate(Me.txtFechaNotificacion.Text)
        Else
            FechaNotificacion = Nothing
        End If

        Try
            Dim tipoSol As Integer = 0
            If Me.ddlTipoSolicitud.SelectedValue = String.Empty Then
                tipoSol = 0
            Else
                tipoSol = CInt(Me.ddlTipoSolicitud.SelectedValue)

            End If

            Dim str As String = Empresas.CRM.insertaRegistroCRM(Me.RegistroPatronal, _
                                       Me.txtAsunto.Text, Integer.Parse(Me.ddlTipoCaso.SelectedValue), _
                                       tipoSol, Me.txtContacto.Text, Me.txtDescripcion.Text, _
                                       Me.UsrUserName, FechaNotificacion, Me.txtMailAdic1.Text, Me.txtMailAdic2.Text)

            If Split(str, "|")(0) = "0" Then
                Me.lblMensajeCRM.CssClass = "subHeader"
                Me.lblMensajeCRM.Text = "El " + Split(str, "|")(1).ToString() + " registro fue insertado satisfactoriamente."
                LimpiarCRMRegistros()
                bindCRMDataList()
            Else
                Me.lblMensajeCRM.CssClass = "error"
                Me.lblMensajeCRM.Text = "Error: " + Split(str, "|")(1).ToString()
            End If
        Catch ex As Exception
            Me.lblMensajeCRM.CssClass = "error"
            Me.lblMensajeCRM.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnLimpiarCRMregistros_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLimpiarCRMregistros.Click
        LimpiarCRMRegistros()
        bindCRMDataList()
        Me.txtFechaNotificacion.Text = Date.Now.ToString
    End Sub

    Protected Sub LimpiarCRMRegistros()

        Me.ddlTipoCaso.SelectedValue = "-1"
        Me.trTipoSolicitudes.Visible = False
        Me.txtAsunto.Text = String.Empty
        Me.txtContacto.Text = String.Empty
        Me.txtDescripcion.Text = String.Empty
        Me.txtFechaNotificacion.Text = String.Empty
        Me.chkNotificame.Checked = False
        Me.txtMailAdic1.Text = String.Empty
        Me.txtMailAdic2.Text = String.Empty

    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Me.dlReporte.DataSource = Empresas.CRM.getReporteCRM(Me.RegistroPatronal, _
                                    Me.ddlTipoCasosRep.SelectedValue, _
                                    CDate(Me.txtDesde.Text), _
                                    CDate(Me.txtHasta.Text))
        Me.dlReporte.DataBind()

    End Sub

#End Region

#Region "Utilitarios"

    Protected Sub showTabs()

        If Me.Tabs.Visible = False Then
            Me.Tabs.Visible = True
            Me.upTabs.Update()
        End If

    End Sub

    Protected Sub hideTabs()

        Me.Tabs.ActiveTabIndex = 0
        If Me.Tabs.Visible Then
            Me.Tabs.Visible = False
            Me.upTabs.Update()
        End If

    End Sub

    Protected Sub showGridEmpleadores()
        If Not pnlGridEmpleadores Is Nothing Then
            Me.pnlGridEmpleadores.Visible = True
            Me.upEmpleadores.Update()
        End If
    End Sub

    Protected Sub hideGridEmpleadores()

        If Not pnlGridEmpleadores Is Nothing Then
            Me.pnlGridEmpleadores.Visible = False
            Me.upEmpleadores.Update()
        End If

    End Sub

    Protected Function formatCedula(ByVal cedula As Object) As String

        If cedula Is DBNull.Value Then
            Return String.Empty
        End If

        If cedula.ToString.Length = 11 Then
            Return Utils.FormatearCedula(cedula)
        Else
            Return cedula
        End If

    End Function

    Protected Function formatTelefono(ByVal telefono As Object) As String
        If telefono Is DBNull.Value Then
            Return String.Empty
        End If

        Return Utils.FormatearTelefono(telefono)


    End Function

    Protected Sub setLink()

        Me.hlnkVerNotificaciones.NavigateUrl = "consFacturaRNC.aspx?rnc=" & Me.RNC & "&tipo=TSS"
        Me.hlnkVerLiquidaciones.NavigateUrl = "consFacturaRNC.aspx?rnc=" & Me.RNC & "&tipo=ISR"
        Me.hlnkVerLiquidacionesInfotep.NavigateUrl = "consFacturaRNC.aspx?rnc=" & Me.RNC & "&tipo=INF"
        Me.hlnkVerSolicitudes.NavigateUrl = "~/Solicitudes/ConsultabyRNC.aspx?rnc=" & Me.RNC
        Me.hlnkRegistroAuditoria.NavigateUrl = "~/Operaciones/consRegistroAuditoria.aspx?rnc=" & Me.RNC
        Me.hlnkActPerfil.NavigateUrl = "~/Censo/censoEmpleador.aspx?rnc=" & Me.RNC
        If Me.IsInPermiso(110) Then
            Me.hlnkActPerfil.Enabled = True
        Else
            Me.hlnkActPerfil.Enabled = False
        End If
    End Sub

#End Region

    Protected Sub Tabs_ActiveTabChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Tabs.ActiveTabChanged

        Dim tab As String = CType(sender, AjaxControlToolkit.TabContainer).ActiveTab.HeaderText

        'Esto para evitar que cuando le den click a los tabs vaya a buscar info sin haberse cargado un empleador.
        If Not Me.RegistroPatronal = Nothing Then
            Select Case tab
                Case "Representante"
                    cargarRepresentante()
                Case "Nomina"
                    cargarNomina()
                Case "CRM"
                    cargarCMRRegistros()
                Case "CRMReportes"
                    cargarCRMReportes()
                Case "CRMUltimaAccion"
                    cargarCRMUltimaAccion()
                Case "Legal"
                    cargarLegal()
                Case "Subsidios"
                    cargarSFS()
                Case "InformeAuditoria"
                    cargarInformes()
                Case "Documentos"
                    cargarInformes()
            End Select
        End If

    End Sub

    Protected Sub dtRepresentante_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataListCommandEventArgs) Handles dtRepresentante.ItemCommand
        Dim registro_patronal As String = String.Empty
        Dim nss As Integer
        Dim res As Integer
        If e.CommandName <> "Resetear" Then
            nss = CInt(Split(e.CommandArgument, "|")(0))
            registro_patronal = CInt(Split(e.CommandArgument, "|")(1))
        End If

        Try
            If e.CommandName = "Resetear" Then
                'Construimos el usuarios concatenando el RNC y la cedula que viene en el argument.
                Me.IDRepresentante = e.CommandArgument
            End If

            If e.CommandName = "Habilitar" Then
                res = Representante.deshabilitar_rep(nss, registro_patronal, "A", UsrUserName)
                cargarRepresentante()
            ElseIf (e.CommandName = "Deshabilitar") Then
                res = Representante.deshabilitar_rep(nss, registro_patronal, "T", UsrUserName)
                cargarRepresentante()
            End If
            If res <> "0" Then
                Throw New Exception(res)
            End If
        Catch ex As Exception
            Throw ex

        End Try

    End Sub

    Protected Sub dtRepresentante_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataListItemEventArgs) Handles dtRepresentante.ItemDataBound

        'Si el usuario tiene el role necesario se muesta el boton de resetear class.
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            If Me.IsInPermiso("167") Then
                CType(e.Item.FindControl("btnResetearClave"), LinkButton).Visible = True
            Else
                CType(e.Item.FindControl("btnResetearClave"), LinkButton).Visible = False
            End If

            ''validar status para determinar que boton prender(habilitar o deshabilitar)
            If (Session("TienePermiso") = "SI") Then
                Dim EstatusRep As String = CType(e.Item.FindControl("lblStatus"), Label).Text

                If EstatusRep = "A" Then
                    CType(e.Item.FindControl("lbtnHabilitar"), LinkButton).Visible = True
                    CType(e.Item.FindControl("lbtnDeshabilitar"), LinkButton).Visible = False
                Else
                    CType(e.Item.FindControl("lbtnDeshabilitar"), LinkButton).Visible = True
                    CType(e.Item.FindControl("lbtnHabilitar"), LinkButton).Visible = False
                End If
            End If

        End If

    End Sub

    Protected Sub gvNominas_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvNominas.RowDataBound

        'Si el usuario tiene el permiso necesario muestra el link de ver detalle de nomina y de ver dependientes.
        If e.Row.RowType = DataControlRowType.DataRow Then

            If Me.IsInPermiso("96") Then
                CType(e.Row.FindControl("lnkVerDetalleNomina"), HyperLink).Visible = True
                CType(e.Row.FindControl("lnkVerDependientes"), HyperLink).Visible = True
            Else
                CType(e.Row.FindControl("lnkVerDetalleNomina"), HyperLink).Visible = False
                CType(e.Row.FindControl("lnkVerDependientes"), HyperLink).Visible = False
            End If

        End If

    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        'If Me.IsInPermiso(110) Then
        '    Me.lnkBtnActPerfil.Visible = True
        'Else
        '    Me.lnkBtnActPerfil.Visible = True
        'End If

        If Not Page.IsPostBack Then
            Me.Tabs.ActiveTabIndex = 0
        End If

    End Sub


    ''Se utilizar para marcar y desmarcar la rectificacion de un empleador.
    Protected Sub lnkBtnMarcarEmp_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Try

            If lnkBtnMarcarEmp.CommandArgument.Length = 0 Then
                lnkBtnMarcarEmp.CommandArgument = "Legal"
            End If


            If lnkBtnMarcarEmp.CommandArgument = "Rectificacion" Then
                Empresas.Empleador.desmarcaRectificacion(Me.RegistroPatronal)
                Operaciones.RegistroLogAuditoria.CrearRegistro(Me.RegistroPatronal, Nothing, Me.UsrUserName, 1, Request.UserHostAddress, Request.UserHostName, String.Empty, Request.ServerVariables("LOCAL_ADDR"))

            ElseIf lnkBtnMarcarEmp.CommandArgument = "Legal" Then

                'Dim emp As New Empresas.Empleador(Me.RegistroPatronal)
                'emp.StatusCobro = Empresas.StatusCobrosType.Normal
                'emp.GuardarCambios(Me.UsrUserName)

                'Operaciones.RegistroLogAuditoria.CrearRegistro(Me.RegistroPatronal, Nothing, Me.UsrUserName, 1, Request.UserHostAddress, Request.UserHostName)

            ElseIf lnkBtnMarcarEmp.CommandArgument = "Bloquear" Then

                Dim emp As New Empresas.Empleador(Me.RegistroPatronal)
                emp.StatusCobro = Empresas.StatusCobrosType.Legal
                emp.GuardarCambios(Me.UsrUserName)

                Operaciones.RegistroLogAuditoria.CrearRegistro(Me.RegistroPatronal, Nothing, Me.UsrUserName, 1, Request.UserHostAddress, Request.UserHostName, String.Empty, Request.ServerVariables("LOCAL_ADDR"))

            End If

            cargarGenerales()
            Me.lblAcuerdosMsg.Text = "Actualizado satisfactoriamente"
        Catch ex As Exception
            lblAcuerdosMsg.Text = Me.UsrUserName & "|" & ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub lnkNuevoRep_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.pnlNuevoRep.Visible = True
        'Limpiando control representante
        Me.ucRepresentante.iniForm()
        Me.ucRepTelefono1.PhoneNumber = String.Empty
        Me.ucRepTelefono2.PhoneNumber = String.Empty
        Me.txtRepExt1.Text = String.Empty
        Me.txtRepExt2.Text = String.Empty
        Me.txtRepEmail.Text = String.Empty
        Me.chkboxNotificacionMail.Checked = True
        Me.mostrarNominas()

        Me.dtRepresentante.Visible = False
        Me.upRepresentantes.Update()


    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.pnlNuevoRep.Visible = False
        Me.dtRepresentante.Visible = True
        Me.upRepresentantes.Update()
    End Sub

    Protected Sub btnAceptar_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        'Validando el telefono 1 como obligatoria
        If Me.ucRepTelefono1.PhoneNumber = "" Then

            Me.lblRepMsg.Text = "Debe introducir el telefono 1 válido."
            Me.lblRepMsg.ForeColor = Drawing.Color.Red
            Return

        End If

        Try

            If Not Me.ucRepresentante.getNSS = "" Then

                'Validando que si quieren notificaciones por email introduzcan su email.
                If Me.chkboxNotificacionMail.Checked = True And Trim(Me.txtRepEmail.Text) = String.Empty Then
                    Me.lblRepMsg.Text = "Si desea recibir notificaciones via e-mail, debe introducir su e-mail."
                    Me.lblRepMsg.ForeColor = Drawing.Color.Red
                    Return

                End If

                'Agregando representante
                Dim ret As String = Empresas.Representante.insertaRepresentante(Trim(Me.ucRepresentante.getDocumento), Me.RegistroPatronal, Me.ddTipo.SelectedValue, "S", Me.ucRepTelefono1.PhoneNumber.Replace("-", ""), Me.txtRepExt1.Text, Me.ucRepTelefono2.PhoneNumber.Replace("-", ""), Me.txtRepExt2.Text, Me.txtRepEmail.Text, Trim(Me.UsrUserName))

                If Split(ret, "|")(0) = "0" Then

                    Empresas.CRM.insertaRegistroCRM(Me.RegistroPatronal, "Nuevo Representante", 8, 0, String.Empty, "Se agregó el representante " & ucRepresentante.getNombres & " " & ucRepresentante.getApellidos & " cédula Nro. " & ucRepresentante.getDocumento, Me.UsrUserName, Now.Date, String.Empty, String.Empty)
                    Me.lblNuevoClass.Text = "El CLASS del nuevo representante es: " & Split(ret, "|")(1)
                    Me.cargarRepresentante()

                Else
                    Me.lblNuevoClass.Text = String.Empty
                    Me.lblRepMsg.Text = (Split(ret, "|")(1))
                End If

            Else
                Me.lblRepMsg.Text = "Debe seleccionar un individuo."
            End If

        Catch ex As Exception
            Me.lblRepMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub asignarNominas(ByVal rep As Representante)

        For Each i As GridViewRow In Me.dgNominas.Rows

            If CType(i.FindControl("chbSelecciona"), CheckBox).Checked Then
                rep.darAccesoNomina(Integer.Parse(CType(i.FindControl("lblID"), Label).Text), Me.UsrUserName)
            End If

        Next

    End Sub

    Private Sub mostrarNominas()

        Dim dtnom As New DataTable
        dtnom = Nomina.getNomina(Me.RegistroPatronal, -1)
        If dtnom.Rows.Count > 0 Then
            Me.dgNominas.DataSource = dtnom
            Me.dgNominas.DataBind()
        Else
            Me.lblRepMsg.Text = "error al cargar las nóminas"
            Return
        End If

    End Sub

    Private Function marcoAcceso() As Boolean

        For Each i As GridViewRow In Me.dgNominas.Rows
            If CType(i.FindControl("chbSelecciona"), CheckBox).Checked = True Then Return True
        Next

        Return False

    End Function

    Public Function getTipoNom(ByVal codigoTipo As String) As String
        Return IIf(codigoTipo = "N", "Normal", IIf(codigoTipo = "P", "Pensionados", "Contratados"))
    End Function

    Protected Sub btnResetClass_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnResetClass.Click
        If Not String.IsNullOrEmpty(Me.IDRepresentante) Then
            If Not String.IsNullOrEmpty(txtFechaNac.Text) Then
                Try
                    Dim dt As New DataTable
                    dt = Utilitarios.TSS.getConsultaNss(Me.IDRepresentante, String.Empty, String.Empty, String.Empty, String.Empty, 1, 1)

                    If dt.Rows.Count > 0 Then
                        If Not IsDBNull(dt.Rows(0)("FECHA_NACIMIENTO")) Then
                            'Si la fecha es Valida actualizamos el class
                            If CDate(txtFechaNac.Text).ToShortDateString() = CDate(dt.Rows(0)("FECHA_NACIMIENTO")).ToShortDateString() Then
                                Dim usuario As String = Me.RNC + Me.IDRepresentante
                                Dim tmpClass As String = SuirPlus.Seguridad.Usuario.ResetearClass(usuario)

                                If Split(tmpClass, "|")(0) = "0" Then
                                    'Reseteado correctamente
                                    Me.lblMeCorrecto.Text = "El CLASS fue reseteado. Nuevo CLASS: " & Split(tmpClass, "|")(1)
                                    Operaciones.RegistroLogAuditoria.CrearRegistro(Me.RegistroPatronal, usuario, Me.UsrUserName, 2, Request.UserHostAddress, Request.UserHostName, String.Empty, Request.ServerVariables("LOCAL_ADDR"))

                                    Me.fsDatos.Visible = False
                                    Me.fsComplete.Visible = True
                                Else
                                    Me.lblMensajeReset.Text = Split(tmpClass, "|")(1)
                                End If

                                Me.upRepresentantes.Update()
                            Else
                                'Si la fecha no es valida mostramos el error
                                lblMensajeReset.Text = "La fecha de nacimiento no coincide con la que tenemos en el sistema."
                            End If
                        End If
                    Else
                        Me.lblMensajeReset.Text = "Representante no valido."
                    End If
                Catch ex As Exception
                    lblMensajeReset.Text = ex.Message
                End Try
            Else
                Me.lblMensajeReset.Text = "Debe digitar una fecha de nacimiento."
            End If
        End If
    End Sub

    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCerrar.Click
        Me.txtFechaNac.Text = String.Empty
        Me.lblMensajeReset.Text = String.Empty
        Me.lblMeCorrecto.Text = String.Empty

        fsDatos.Visible = True
        fsComplete.Visible = False

        'Script que cierra
        Dim script As String = " $('.dialog').dialog('close');"
        ScriptManager.RegisterClientScriptBlock(Me, GetType(Page), UniqueID, script, True)
    End Sub

    Protected Sub btnCargarInforme_Click(sender As Object, e As EventArgs) Handles btnCargarInforme.Click
        Try

            btnCargarInforme.Enabled = False
            lblMensajeInforme.Text = String.Empty

            If Not Me.RegistroPatronal = Nothing Then

                If String.IsNullOrEmpty(txtDescripcionInforme.Text) Then
                    lblMensajeInforme.Text = "Debe digitar una descripcion."
                    btnCargarInforme.Enabled = True
                    Exit Sub
                Else
                    If txtDescripcionInforme.Text.Length > 150 Then
                        lblMensajeInforme.Text = "La descripcion no debe contener mas de 150 caracteres."
                        btnCargarInforme.Enabled = True
                        Exit Sub
                    End If

                End If

                If Not flInforme.HasFile Then
                    lblMensajeInforme.Text = "Debe elegir un archivo."
                    btnCargarInforme.Enabled = True
                    Exit Sub
                End If


                Dim ImagenMod() As Byte
                Dim imgContentType As String = flInforme.PostedFile.ContentType
                Dim imgFileName As String = flInforme.PostedFile.FileName
                Dim imgLength As Integer = flInforme.PostedFile.ContentLength
                Dim imgStream As System.IO.Stream = flInforme.PostedFile.InputStream

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/tiff") Or (imgContentType = "image/tif") Or (imgContentType = "application/pdf") Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 1500 Then

                        lblMensajeInforme.Text = "El tamaño del archivo no debe superar los 1500 KB."
                        btnCargarInforme.Enabled = True
                        Exit Sub
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If



                    Dim result As String = Empresas.Empleador.GuardarInformeAuditoria(Me.RegistroPatronal, ImagenMod, txtDescripcionInforme.Text, Me.UsrUserName)

                    If result = "0" Then
                        cargarInformes()
                        txtDescripcionInforme.Text = String.Empty
                        btnCargarInforme.Enabled = True
                    Else
                        lblMensajeInforme.Text = "Ha ocurrido un error guardando el informe."
                        btnCargarInforme.Enabled = True
                    End If

                Else
                    lblMensajeInforme.Text = "La imagen debe ser de tipo TIFF,PDF"
                    btnCargarInforme.Enabled = True
                End If
            Else
                lblMensajeInforme.Text = "Debe seleccionar una empresa."
                btnCargarInforme.Enabled = True
            End If

        Catch ex As Exception
            lblMensajeInforme.Text = ex.Message
            btnCargarInforme.Enabled = True

        End Try

    End Sub

    Protected Sub btnLimpiarInforme_Click(sender As Object, e As EventArgs) Handles btnLimpiarInforme.Click
        lblMensajeInforme.Text = String.Empty
        btnCargarInforme.Enabled = True
        txtDescripcionInforme.Text = String.Empty
    End Sub
End Class

