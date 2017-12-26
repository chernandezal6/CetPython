Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios
Imports System.Data
Imports System.IO

Partial Class Certificaciones_CrearCertificacion
    Inherits BasePage
    Dim ImagenMod() As Byte
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean

    Dim tipoCert As Certificaciones.CertificacionType
    Public myCert As Certificaciones
    Dim script As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load

        Me.lblMsg.Text = String.Empty

        Me.drpTipoCert.Attributes.Add("onChange", "showField(this.options[selectedIndex].value )")

        If Not Page.IsPostBack Then
            'binTiposCertificaciones()
            CargarTipoCertificaciones("", "")
            cargarfirmas()

        End If


        ClientScript.RegisterStartupScript(Me.GetType, "OnLoad", "<script>test();</script>")



    End Sub

    Private Sub binTiposCertificaciones()
        'Dim dtTipos As DataTable = Certificaciones.getTipoCertificacion(False)
        'Me.drpTipoCert.DataSource = dtTipos
        'Me.drpTipoCert.DataValueField = "ID_TIPO_CERTIFICACION"
        'Me.drpTipoCert.DataTextField = "TIPO_CERTIFICACION_DES"
        'Me.drpTipoCert.DataBind()
    End Sub
    Sub CargarTipoCertificaciones(ByVal RNC As String, ByVal Usuario As String)
        If RNC = String.Empty Then
            RNC = UsrRNC
        End If

        If Usuario = String.Empty Then
            Usuario = UsrUserName

        End If

        Dim dtTipos As DataTable = SuirPlus.Empresas.Certificaciones.GetInfoSolicitud(RNC, Usuario)
        Me.drpTipoCert.DataSource = dtTipos
        Me.drpTipoCert.DataValueField = "ID_TIPO_CERTIFICACION"
        Me.drpTipoCert.DataTextField = "TIPO_CERTIFICACION_DES"
        Me.drpTipoCert.DataBind()
    End Sub
    Protected Sub cargarfirmas()
        Try
            Me.dlFirmaResponsable.DataSource = Empresas.Certificaciones.getFirmasOficinas()
            Me.dlFirmaResponsable.DataTextField = "DESCRIPCION"
            Me.dlFirmaResponsable.DataValueField = "ID"
            Me.dlFirmaResponsable.DataBind()
            Me.dlFirmaResponsable.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Catch ex As Exception
            Throw New Exception(ex.ToString)
        End Try
    End Sub
    Private Sub btnValidar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnValidar.Click

        Dim msg As String = String.Empty
        Me.lblMsg.Text = String.Empty
        Try
            Session("firma") = dlFirmaResponsable.SelectedValue
            If dlFirmaResponsable.SelectedValue = "-1" Then

                Me.lblMsg.Text = "Debe seleccionar la firma responsable"
                Exit Sub
            Else
                Me.lblMsg.Text = String.Empty
            End If

            tipoCert = Certificaciones.setTipoCertificacion(Me.drpTipoCert.SelectedValue.ToString())
            myCert = New Certificaciones(tipoCert)
            Session("myCert") = myCert

            'Para el unico caso que pasamos la cedula como un RNC
            If tipoCert = Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina Then
                myCert.RNC = Trim(Me.txtCedula.Text).PadLeft(11)
            Else
                myCert.Cedula = Trim(Me.txtCedula.Text).PadLeft(11)
                myCert.RNC = Trim(Me.txtRnc.Text).PadLeft(11)
            End If

            'Asignando las fechas
            If Me.txtFechaDesde.Text <> String.Empty Then myCert.FechaDesde = Me.txtFechaDesde.Text
            If Me.txtFechaHasta.Text <> String.Empty Then myCert.FechaHasta = Me.txtFechaHasta.Text

            'Validaciones de campos requeridos
            Select Case tipoCert
                Case Certificaciones.CertificacionType.AporteEmpleadoPorEmpleador
                    If Me.txtCedula.Text = "" Or Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El RNC y la cédula del empleado son requerido."
                        Me.txtRnc.Text = String.Empty
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtRnc.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.AportePersonal
                    If Me.txtCedula.Text.Trim() = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        'Veriricamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.BalanceAlDia
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    Else
                        'Si el rnc es una cedula verificamos que sea valido.
                        If txtRnc.Text.Length = 11 Then
                            If Not myCert.esEmpleador(msg) Then
                                Me.lblMsg.Text = msg
                                Me.txtRnc.Text = String.Empty
                                Exit Sub
                            End If
                        End If
                    End If

                    Dim emp As New Empleador(Me.txtRnc.Text)
                    If Not emp.StatusCobro = StatusCobrosType.Normal Then
                        Me.lblMsg.Text = "El estatus del empleador no permite que se realice este tipo de certificación.<br/> Se encuentra en Legal."
                        Exit Sub
                    End If

                Case Certificaciones.CertificacionType.NoOperaciones
                    Try


                        If Me.txtRnc.Text = "" Then
                            Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                            Me.txtRnc.Text = String.Empty
                            Exit Sub
                        ElseIf Me.txtFechaDesde.Text = "" Then
                            Me.lblMsg.Text = "La fecha desde, debe ser especificada."
                            Me.txtFechaDesde.Text = String.Empty
                            Exit Sub
                        ElseIf Me.txtFechaHasta.Text = "" Then
                            Me.lblMsg.Text = "La fecha hasta, debe ser especificada."
                            Me.txtFechaHasta.Text = String.Empty
                            Exit Sub

                        ElseIf (CDate(Me.txtFechaHasta.Text)) < (CDate(Me.txtFechaDesde.Text)) Then
                            Me.lblMsg.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                            Me.txtFechaHasta.Text = String.Empty
                            Me.txtFechaDesde.Text = String.Empty
                            Exit Sub
                        ElseIf (CDate(Me.txtFechaDesde.Text)) > (CDate(Me.txtFechaHasta.Text)) Then
                            Me.lblMsg.Text = "La fecha desde, debe ser menor que la fecha hasta."
                            Me.txtFechaHasta.Text = String.Empty
                            Me.txtFechaDesde.Text = String.Empty
                            Exit Sub
                        Else
                            If Not myCert.esEmpleador(msg) Then
                                Me.lblMsg.Text = msg
                                Me.txtCedula.Text = String.Empty
                                Exit Sub
                            End If
                        End If
                    Catch ex As Exception
                        Me.lblMsg.Text = ex.Message
                        SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    End Try
                Case Certificaciones.CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina
                    If Me.txtCedula.Text = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.RegistroEmpleadorSinNomina
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtRnc.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.CiudadanoSinAporte
                    If Me.txtCedula.Text = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.UltimoAporteCiudadano
                    If Me.txtCedula.Text = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.ReporteNoPagosEmpleadoAlEmpleador
                    If Me.txtCedula.Text = "" Or Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El RNC y la cédula del empleado son requerido."
                        Me.txtRnc.Text = String.Empty
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtRnc.Text = String.Empty
                            Exit Sub
                        End If

                        'Validamos que el empleador no haya hecho aporte.
                        If myCert.tieneAporteEmpleador Then
                            myCert.CargarDatos()
                            Me.lblMsg.Text = "** El empleador: " & myCert.RazonSocial & " ha realizado aportes al trabajador: " & myCert.Nombre
                            Me.txtRnc.Text = String.Empty
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If

                    'Validamos que sea un ciudadano valido
                Case Certificaciones.CertificacionType.IngresoTardio
                    If Me.txtCedula.Text = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            binTiposCertificaciones()
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If

                    'Validamos que sea un ciudadano valido
                Case Certificaciones.CertificacionType.Discapidad
                    If Me.txtCedula.Text = "" Then
                        Me.lblMsg.Text = "La cédula es requerida para realizar esta certificación"
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                    'Validando el AcuerdoPagoCuotasRequeridas
                Case Certificaciones.CertificacionType.AcuerdoPagoCuotasRequeridas
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If

                    'Validando si tiene acuerdo de pago
                    If myCert.tieneEmpleadorAcuerdodePago = False Then
                        Me.lblMsg.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        Exit Sub
                    End If

                    'Validando si tiene cuotas vencidas
                    If myCert.IsAcuerdoVencido = True Then
                        Me.lblMsg.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        Exit Sub
                    End If
                Case Certificaciones.CertificacionType.CiudadanoSinAportePorEmpleador

                    If Me.txtCedula.Text = "" Or Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El RNC y la cédula del empleado son requerido."
                        Me.txtRnc.Text = String.Empty
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    ElseIf Me.txtFechaDesde.Text = "" Then
                        Me.lblMsg.Text = "La fecha desde, debe ser especificada."
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    ElseIf Me.txtFechaHasta.Text = "" Then
                        Me.lblMsg.Text = "La fecha hasta, debe ser especificada."
                        Me.txtFechaHasta.Text = String.Empty
                        Exit Sub

                    ElseIf (CDate(Me.txtFechaHasta.Text)) < (CDate(Me.txtFechaDesde.Text)) Then
                        Me.lblMsg.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    ElseIf (CDate(Me.txtFechaDesde.Text)) > (CDate(Me.txtFechaHasta.Text)) Then
                        Me.lblMsg.Text = "La fecha desde, debe ser menor que la fecha hasta."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    Else
                        'Verificamos que sea un ciudadano valido.
                        If Not myCert.esCiudadano(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                        'Verificamos que sea un empleador valido.
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtRnc.Text = String.Empty
                            Exit Sub
                        End If


                        'Validamos que el empleador no haya hecho aporte.
                        If myCert.tieneAporteCiudadanoEmpleador Then
                            myCert.CargarDatos()
                            Me.lblMsg.Text = "** El empleador: " & myCert.RazonSocial & " ha realizado aportes al trabajador: " & myCert.Nombre
                            Me.txtRnc.Text = String.Empty
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                Case Certificaciones.CertificacionType.AcuerdoPagoSinAtraso
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If

                    'Validando si tiene acuerdo de pago
                    If myCert.tieneAcuerdodePagoVigente = False Then
                        Me.lblMsg.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        Exit Sub
                    End If

                    'Validando si tiene cuotas vencidas
                    Dim result As String = String.Empty
                    Dim dt As DataTable = myCert.getCuotasPagadasAcuerdo(result)

                    If result <> "0" Then
                        Me.lblMsg.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                        Exit Sub
                    Else
                        If dt.Rows.Count = 0 Then
                            Me.lblMsg.Text = "Este empleador no cumple con los requisitos para realizarle esta certificacion."
                            Exit Sub
                        End If
                    End If

                Case Certificaciones.CertificacionType.EstatusGeneral
                    If Me.txtRnc.Text = "" Then
                        Me.lblMsg.Text = "El rnc del empleador es requerido para realizar esta certificación."
                        Me.txtRnc.Text = String.Empty
                        Exit Sub
                    ElseIf Me.txtFechaDesde.Text = "" Then
                        Me.lblMsg.Text = "La fecha desde, debe ser especificada."
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    ElseIf Me.txtFechaHasta.Text = "" Then
                        Me.lblMsg.Text = "La fecha hasta, debe ser especificada."
                        Me.txtFechaHasta.Text = String.Empty
                        Exit Sub

                    ElseIf (CDate(Me.txtFechaHasta.Text)) < (CDate(Me.txtFechaDesde.Text)) Then
                        Me.lblMsg.Text = "La fecha hasta, debe ser mayor que la fecha desde."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    ElseIf (CDate(Me.txtFechaDesde.Text)) > (CDate(Me.txtFechaHasta.Text)) Then
                        Me.lblMsg.Text = "La fecha desde, debe ser menor que la fecha hasta."
                        Me.txtFechaHasta.Text = String.Empty
                        Me.txtFechaDesde.Text = String.Empty
                        Exit Sub
                    Else
                        If Not myCert.esEmpleador(msg) Then
                            Me.lblMsg.Text = msg
                            Me.txtCedula.Text = String.Empty
                            Exit Sub
                        End If
                    End If
                    'Validamos que el empleador no haya hecho aporte.
                    If myCert.tieneAporteGeneral = False Then
                        myCert.CargarDatos()
                        Me.lblMsg.Text = "** El empleador: " & myCert.RazonSocial & " no ha realizado aportes al SDSS entre las fechas especificadas"
                        Me.txtRnc.Text = String.Empty
                        Me.txtCedula.Text = String.Empty
                        Exit Sub
                    End If
            End Select

            myCert.CargarDatos()
            showPanelConfirmacion()
            Me.txtRnc.Text = String.Empty
            Me.txtCedula.Text = String.Empty

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Sub showPanelConfirmacion()
        'Mostramos los datos
        Me.lblTipoCert.Text = Me.drpTipoCert.SelectedItem.Text.ToString()
        Me.lblRazonSocial.Text = myCert.RazonSocial()
        Me.lblRncCedula.Text = myCert.RNC
        Me.lblNombre.Text = myCert.Nombre
        Me.lblNSS.Text = myCert.NSS

        'verificamos si hay una razon social para mostrar el panel de informacion del empleador.
        If myCert.RazonSocial <> String.Empty Then
            Me.pnlDatosEmpleador.Visible = True
        End If
        If myCert.NSS <> String.Empty Then
            Me.pnlDatosCiudadanos.Visible = True
        End If

        If myCert.NSS <> "" Or myCert.NSS <> String.Empty Then
            Me.lblNSS.Text = Utilitarios.Utils.FormatearNSS(myCert.NSS)
        End If
        If myCert.Cedula <> "" Or myCert.Cedula <> String.Empty Then
            Me.lblCedula.Text = Utilitarios.Utils.FormatearCedula(myCert.Cedula)
        End If

        If myCert.Tipo = Certificaciones.CertificacionType.NoOperaciones Then
            Me.lblFechaDesde.Text = myCert.FechaDesde
            Me.lblFechaHasta.Text = myCert.FechaHasta
            Me.pnlFechas.Visible = True
        End If

        'Mostramos las observaciones.
        MostrarObservaciones()

        'Mostramos y ocultamos los paneles.
        Me.pnlCreacion.Visible = False
        pnlConfirmacion.Visible = True
        Me.pnlBotonCrear.Visible = True

    End Sub

    'A traves de este procedimiento validamos lo necesario para crear una certificacion.
    Sub MostrarObservaciones()

        Select Case tipoCert

            Case Certificaciones.CertificacionType.EstatusPagoDetalle
            Case Certificaciones.CertificacionType.AporteEmpleadoPorEmpleador
            Case Certificaciones.CertificacionType.AportePersonal
            Case Certificaciones.CertificacionType.NoOperaciones
                MuestraInicioActividades()
                MuestraRegistroOperaciones()
            Case Certificaciones.CertificacionType.BalanceAlDia
                MuestraInicioActividades()
                MuestraFacturasVencidas()
            Case Certificaciones.CertificacionType.BalanceAlDiaCon3FacturasOMenosPagadas
                MuestraInicioActividades()
                MuestraFacturasVencidas()
            Case Certificaciones.CertificacionType.RegistroPersonaFisicaSinNomina
                MuestraNominas()
                MuestraFacturasPeriodoActual()
            Case Certificaciones.CertificacionType.RegistroEmpleadorSinNomina
                MuestraInicioActividades()
                MuestraNominas()
                MuestraFacturasPeriodoActual()
            Case Certificaciones.CertificacionType.CiudadanoSinAporte
            Case Certificaciones.CertificacionType.UltimoAporteCiudadano
                MuestraObservacionUltimoAporte()
            Case Certificaciones.CertificacionType.ReporteNoPagosEmpleadoAlEmpleador
            Case Certificaciones.CertificacionType.IngresoTardio
                If Not myCert.esIngresoTardio Then
                    Me.lblObservacion.Text = Utilitarios.TSS.getErrorDescripcion(185)
                    Me.pnlObservacion.Visible = True
                    Me.pnlOperaciones.Visible = True
                    Me.btnCrear.Enabled = False
                End If

            Case Certificaciones.CertificacionType.Discapidad
                If Not myCert.tieneAporteTrabajador() Then
                    Me.lblObservacion.Text = Utilitarios.TSS.getErrorDescripcion(185)
                    Me.pnlObservacion.Visible = True
                    Me.pnlOperaciones.Visible = True
                    Me.btnCrear.Enabled = False
                End If
        End Select

    End Sub

    Private Sub btnCrear_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCrear.Click

        'validamos que haya una firma seleccionada
        Dim firma = CType(Session("firma"), String)

        myCert = CType(Session("myCert"), Certificaciones)
        Try
            myCert.Firma = CInt(firma)
            myCert.Crear(Me.UsrUserName)
            'borramos la firmas seleccionaca de session
            Session.Remove("firma")
        Catch ex As Exception

            Me.lblMsg.Text = ex.Message()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        Try
            'validamos el contenidos de los documentos recientemente scaneados para atachar en la certificación recietemente creada
            ValidarImagen()

            Dim result As String = Empresas.Certificaciones.SubirImagenCertificacion(myCert.Numero, 0, ImagenMod, UsrUserName)

        Catch ex As Exception
            Me.lblMsg.Text = ex.ToString()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
        ' End If
        Me.pnlConfirmacion.Visible = False
        Me.pnlDatosEmpleador.Visible = False
        Me.pnlFechas.Visible = False

        Me.pnlDatosCiudadanos.Visible = False
        Me.pnlBotonCrear.Visible = False

        MuestraPanelFinal()

    End Sub

    Private Sub btnNuevaCert_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevaCert.Click
        Response.Redirect("CrearCertificacion.aspx")
    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Response.Redirect("CrearCertificacion.aspx")
    End Sub

#Region "Metodos para la carga de imagenes scaneadas"

    Protected Sub ValidarImagen()
        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.flCargarImagenCert.HasFile() Then
                imgStream = flCargarImagenCert.PostedFile.InputStream
                imgLength = flCargarImagenCert.PostedFile.ContentLength
                Dim imgContentType As String = flCargarImagenCert.PostedFile.ContentType
                'Dim imgFileName As String = upLImagenCiudadano.PostedFile.FileName

                'validamos los tipos de archivos que deseamos aceptar
                If (imgContentType = "image/tif") Or (imgContentType = "image/tiff") Then

                    Dim imgSize As String = (imgLength / 1024)

                    If imgSize > 600 Then
                        Throw New Exception("El tamaño del archivo de imagen no debe superar los 500 KB, por favor contacte a mesa de ayuda.")
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If

                Else
                    Throw New Exception("La imagen debe ser de tipo TIF")
                    Exit Sub
                End If

            End If
        Catch ex As Exception

            Me.lblMsg.Text = ex.Message

            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.flCargarImagenCert.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.flCargarImagenCert.PostedFile.InputStream
        Dim imageContent(intImageSize) As Byte

        ImageStream.Read(imageContent, 0, intImageSize)


        'Esto es para leer
        Dim memStream As New MemoryStream(imageContent)

        Dim fullSizeImg As System.Drawing.Image = System.Drawing.Image.FromStream(memStream)

        height = Math.Round(fullSizeImg.Height / 2)
        width = Math.Round(fullSizeImg.Width / 2)


        Dim thumbNailImg As System.Drawing.Image
        Dim dummyCallBack As New System.Drawing.Image.GetThumbnailImageAbort(AddressOf ThumbnailCallBack)

        Dim ms As New MemoryStream()


        thumbNailImg = fullSizeImg.GetThumbnailImage(width, height, dummyCallBack, IntPtr.Zero)
        thumbNailImg.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg)

        'Lee las segunda imagen
        ImagenMod = ms.GetBuffer

    End Sub

    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function

#End Region

#Region "Metodos Privados y Configuracion de paneles"

    Private Sub MuestraInicioActividades()

        Dim fecha As String = myCert.InicioActividades.ToString()
        If fecha <> String.Empty Or fecha <> "" Then
            Me.pnlOperaciones.Visible = True
            Me.lblFechaInicioActividad.Text = Convert.ToDateTime(fecha).ToShortDateString()
        End If

    End Sub

    Private Sub MuestraFacturasVencidas()
        Dim dtFacturas As DataTable = myCert.getFactVencidas()
        If dtFacturas.Rows.Count > 0 Then
            Me.gvFacturas.DataSource = dtFacturas
            Me.gvFacturas.DataBind()
            Me.gvFacturas.Visible = True
            Me.pnlFactVencidas.Visible = True
            Me.btnCrear.Enabled = False
        End If
    End Sub

    Private Sub MuestraNominas()
        Dim dtNominas As DataTable = myCert.getNominas()
        If dtNominas.Rows.Count > 0 Then
            Me.gvNominas.DataSource = dtNominas
            Me.gvNominas.DataBind()
            Me.gvNominas.Visible = True
            Me.pnlNominas.Visible = True
            Me.btnCrear.Enabled = False
        End If
    End Sub

    Private Sub MuestraFacturasPeriodoActual()

        Dim dtFacturas As New DataTable

        If myCert.tieneFacturasPeriodoActual(dtFacturas) Then
            Me.pnlFacturaPeriodoActual.Visible = True
            Me.gvFacturaActual.DataSource = dtFacturas
            Me.gvFacturaActual.DataBind()
            Me.gvFacturaActual.Visible = True
            Me.btnCrear.Enabled = False
        End If

    End Sub

    Private Sub MuestraObservacionUltimoAporte()

        Dim dtUltimoAporte As New DataTable

        'Verificamos si el trabajador realmente ha realizado su ultimo aporte.
        If Not myCert.validoUltimoAporte(dtUltimoAporte) Then
            Me.pnlInfoUltimoAporte.Visible = True
            Dim myColumn As New BoundField

            'Verificamos si se encontro el trabajador en alguna nomina o en alguna factura.
            If dtUltimoAporte.Columns(2).ColumnName = "NOMINA_DES" Then
                Me.lblUltimoAporte.Text = "Trabajador activo en nómina(s)."
                myColumn.DataField = "NOMINA_DES"
                myColumn.HeaderText = "Nómina"
            Else
                Me.lblUltimoAporte.Text = "Trabajador incluido en factura(s)."
                myColumn.DataField = "ID_REFERENCIA"
                myColumn.HeaderText = "Referencia"
            End If

            'Agregamos la columna en el datagrid.
            Me.gvUltimoAporte.Columns.Add(myColumn)
            Me.gvUltimoAporte.DataSource = dtUltimoAporte
            Me.gvUltimoAporte.DataBind()
            Me.gvUltimoAporte.Visible = True
            Me.btnCrear.Enabled = False
        End If

    End Sub

    Private Sub MuestraRegistroOperaciones()

        Dim DtRegistros As DataTable = myCert.getDetalleOperaciones()
        If DtRegistros.Rows.Count > 0 Then
            Me.btnCrear.Enabled = False
            Me.gvRegistroOperaciones.DataSource = DtRegistros
            Me.gvRegistroOperaciones.DataBind()
            Me.gvRegistroOperaciones.Visible = True
            Me.pnlRegisroOperaciones.Visible = True
        End If

    End Sub

    Private Sub MuestraPanelFinal()

        Me.pnlFinal.Visible = True
        Me.lblNoCert.Text = myCert.Numero.ToString()
        Me.lblTipoCert2.Text = Me.lblTipoCert.Text

        If myCert.RazonSocial <> "" Then
            Me.lblRncCedula2.Text = myCert.RNC
            Me.lblRazonSocial2.Text = myCert.RazonSocial
            Me.pnlDatosEmpleador2.Visible = True
        Else
            Me.pnlDatosEmpleador2.Visible = False
        End If

        If myCert.NSS <> "" Then
            Me.lblNombre2.Text = myCert.Nombre
            If myCert.Cedula <> String.Empty Then
                Me.lblCedula2.Text = Utilitarios.Utils.FormatearCedula(myCert.Cedula)
            End If
            Me.lblNSS2.Text = myCert.NSS
            Me.pnlDatosCiudadanos2.Visible = True
        Else
            Me.pnlDatosCiudadanos2.Visible = False
        End If

    End Sub

#End Region

    Protected Sub btnVerCertificacion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerCertificacion.Click

        'Dim script As String = "<script Language=JavaScript>" + "window.open('verCertificacion.aspx?codCert=" & Session("IdCert") & "&tipo=NoPrint" & "')</script>"

        'Me.ClientScript.RegisterStartupScript(Me.GetType, "popup", script)
    End Sub
End Class
