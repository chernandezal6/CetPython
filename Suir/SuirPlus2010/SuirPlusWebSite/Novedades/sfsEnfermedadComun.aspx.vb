Imports System.Data
Imports System.IO
Imports SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios.Utils

Partial Class Novedades_sfsEnfermedadComun
    Inherits BasePage

    Protected cuentaBancaria As SuirPlus.Empresas.CuentaBancaria
    Private numeroFormulario As String
    Private tipoSolicitud As String
    Private solicitudRegistrada As String
    Private nombre As String
    Private sexo As String
    Private cedula As String
    Private nss As String
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte
    Dim imagName As String
    Private MostrarHosp As Boolean
    Private MostrarAmb As Boolean

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta(bancaria)
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsEnfermedadComun.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        Me.txtCedula.Focus()
        If Not Page.IsPostBack() Then
            ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
            If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                divNovedades.Visible = True
            Else
                divNovedades.Visible = False
            End If
        End If

        If Not Page.IsPostBack Then

            ViewState("MostrarAmb") = False
            ViewState("MostrarHosp") = False

        End If

    End Sub

#Region "MostrarOcultar"

    Sub PanelesPrimeraSolicitud()

        Me.txtTrabajadorCelular.phoneNumber = String.Empty
        Me.txtTrabajadorDireccion.Text = String.Empty
        Me.txtTrabajadorCorreo.Text = String.Empty
        Me.txtTrabajadorTelefono.phoneNumber = String.Empty

        btnDatosIniciales.Visible = True
        btnCompletar.Visible = False

        Me.divBotonesDatosIniciales.Visible = True
        Me.divDatosIniciales.Visible = True
        Me.divSolicitudRegistrada.Visible = False
        Me.divCompletar.Visible = False
        Me.divConfirmar.Visible = False
        Me.divDatosMedico.Visible = False
        Me.divDiscapacidad.Visible = False
        Me.divFechaDiasAmbulatorio.Visible = False
        Me.divFechaDiasHospitalizacion.Visible = False
        Me.divMedico.Visible = False
        Me.divPadecimientos.Visible = False
        Me.divPSS.Visible = False

    End Sub
    Sub PanelesNuevaSolicitud()

        btnDatosIniciales.Visible = True
        btnCompletar.Visible = False
        btnDatosIniciales.Visible = True

        Me.divBotonesDatosIniciales.Visible = True
        Me.divDatosIniciales.Visible = True
        Me.divSolicitudRegistrada.Visible = False
        Me.divCompletar.Visible = False
        Me.divConfirmar.Visible = False
        Me.divDatosMedico.Visible = False
        Me.divDiscapacidad.Visible = False
        Me.divFechaDiasAmbulatorio.Visible = False
        Me.divFechaDiasHospitalizacion.Visible = False
        Me.divMedico.Visible = False
        Me.divPadecimientos.Visible = False
        Me.divPSS.Visible = False

    End Sub

    Sub PanelesReimprimir()

        btnDatosIniciales.Visible = False
        btnCompletar.Visible = True

        Me.divBotonesDatosIniciales.Visible = True
        Me.divDatosIniciales.Visible = True
        Me.divSolicitudRegistrada.Visible = True
        Me.divCompletar.Visible = False
        Me.divConfirmar.Visible = False
        Me.divDatosMedico.Visible = False
        Me.divDiscapacidad.Visible = False
        Me.divFechaDiasAmbulatorio.Visible = False
        Me.divFechaDiasHospitalizacion.Visible = False
        Me.divMedico.Visible = False
        Me.divPadecimientos.Visible = False
        Me.divPSS.Visible = False


    End Sub

    Private Sub PanelesModalidad()

        If CBool(ViewState("MostrarAmb")) = False Then

            lblPSS.Text = String.Empty

            divDatosMedico.Visible = False
            txtPSSNombre.Enabled = True

            txtMedicoCedula.Enabled = True
            txtMedicoCedula.Text = String.Empty
            txtMedicoCelular.phoneNumber = String.Empty
            txtMedicoCorreo.Text = String.Empty
            txtMedicoDireccion.Text = String.Empty
            txtMedicoExequatur.Text = String.Empty

        End If

        If CBool(ViewState("MostrarHosp")) = False Then

            divDatosPSS.Visible = False
            divFechaDiasHospitalizacion.Visible = False

            lblMedico.Text = String.Empty
            txtMedicoCedula.Enabled = True

            txtPSSNombre.Enabled = True
            txtPSSNombre.Text = String.Empty
            txtPssFax.phoneNumber = String.Empty
            txtPSSCorreo.Text = String.Empty
            txtPSSDireccion.Text = String.Empty
            txtPSSNumero.Text = String.Empty
            txtPssTelefono.phoneNumber = String.Empty
            txtMedicoTelefono.phoneNumber = String.Empty
            txtDiscapFechaLicenciaHosp.Text = String.Empty
            txtDiscapDiasHosp.Text = String.Empty

        End If

        If (Not (CBool(ViewState("MostrarAmb")))) And (Not (CBool(ViewState("MostrarHosp")))) Then

            lblCompletar.Text = String.Empty
            divDiscapacidad.Visible = False
            txtDiscapDiagnostico.Text = String.Empty
            txtDiscapProcedimientos.Text = String.Empty
            txtDiscapSintomas.Text = String.Empty
            txtDiscapFechaDiagnostico.Text = String.Empty
            rdAccidente.Checked = False
            rdEmbarazo.Checked = False
            rdEnfermedadComun.Checked = False

        End If


    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        txtCedula.Text = String.Empty
        Limpiar()

    End Sub
    Private Sub Limpiar()

        'Limpiar todo
        lblMsg.Text = String.Empty
        lblSolicitudRegistrada.Visible = False
        lblPin.Text = String.Empty
        lblTerminar.Text = String.Empty

        'Paneles
        Me.divInfoEmpleado.Visible = False
        Me.divDatosIniciales.Visible = False
        Me.divSolicitudRegistrada.Visible = False
        Me.divCompletar.Visible = False
        Me.divConfirmar.Visible = False
        Me.divDatosMedico.Visible = False
        Me.divDiscapacidad.Visible = False
        Me.divFechaDiasAmbulatorio.Visible = False
        Me.divFechaDiasHospitalizacion.Visible = False
        Me.divMedico.Visible = False
        Me.divPadecimientos.Visible = False
        Me.divPSS.Visible = False
        Me.divDatosPSS.Visible = False
        Me.divImagen.Visible = False

        'Trabajador
        Me.txtTrabajadorCelular.phoneNumber = String.Empty
        Me.txtTrabajadorDireccion.Text = String.Empty
        Me.txtTrabajadorCorreo.Text = String.Empty
        Me.txtTrabajadorTelefono.phoneNumber = String.Empty

        'Modalidad
        ckAmbulatoria.Checked = False
        ckHospitalaria.Checked = False
        ViewState("MostrarAmb") = False
        ViewState("MostrarHosp") = False

        'Medico
        lblMedico.Text = String.Empty
        txtMedicoCedula.Enabled = True
        txtMedicoCedula.Text = String.Empty
        txtMedicoCelular.phoneNumber = String.Empty
        txtMedicoCorreo.Text = String.Empty
        txtMedicoDireccion.Text = String.Empty
        txtMedicoExequatur.Text = String.Empty
        txtMedicoTelefono.phoneNumber = String.Empty

        'PSS
        lblPSS.Text = String.Empty
        txtPSSNombre.Enabled = True
        txtPSSNombre.Text = String.Empty
        txtPssFax.phoneNumber = String.Empty
        txtPSSCorreo.Text = String.Empty
        txtPSSDireccion.Text = String.Empty
        txtPSSNumero.Text = String.Empty
        txtPssTelefono.phoneNumber = String.Empty

        'Discapacidad
        lblCompletar.Text = String.Empty
        divDiscapacidad.Visible = False
        txtDiscapCIE10.Text = String.Empty
        txtDiscapDiagnostico.Text = String.Empty
        txtDiscapProcedimientos.Text = String.Empty
        txtDiscapSintomas.Text = String.Empty
        txtDiscapFechaDiagnostico.Text = String.Empty
        txtDiscapFechaLicenciaHosp.Text = String.Empty
        txtDiscapDiasHosp.Text = String.Empty
        txtDiscapFechaLicenciaAmb.Text = String.Empty
        txtDiscapDiasAmb.Text = String.Empty
        rdAccidente.Checked = False
        rdEmbarazo.Checked = False
        rdEnfermedadComun.Checked = False
        ckImagen.Checked = False

        'TODO: resetear todas las variables
        ViewState("direccion") = Nothing
        ViewState("celular") = Nothing
        ViewState("email") = Nothing
        ViewState("telefono") = Nothing
        ViewState("NumeroFormulario") = Nothing
        ViewState("tipoSolicitud") = Nothing
        ViewState("NroMedico") = Nothing
        ViewState("RNCPSS") = Nothing
        ViewState("ImagenMod") = Nothing

    End Sub
    Sub LimpiarValoresConfirmacion()

        lblConfDiscapDiagnostico.Text = String.Empty
        lblConfDiscapDiasAmb.Text = String.Empty
        lblConfDiscapDiasHosp.Text = String.Empty
        lblConfDiscapFechaDiagnostico.Text = String.Empty
        lblConfDiscapLicenciaAmb.Text = String.Empty
        lblConfDiscapLicenciaHosp.Text = String.Empty
        lblConfDiscapProcedimientos.Text = String.Empty
        lblConfDiscapSintomas.Text = String.Empty
        lblConfDiscapTipo.Text = String.Empty
        lblConfMedicoCedula.Text = String.Empty
        lblConfMedicoNombre.Text = String.Empty
        lblConfMedicoCelular.Text = String.Empty
        lblConfMedicoCorreo.Text = String.Empty
        lblConfMedicoDireccion.Text = String.Empty
        lblConfMedicoExequatur.Text = String.Empty
        lblConfModalidad.Text = String.Empty
        lblConfMedicoTelefono.Text = String.Empty
        lblConfNomina.Text = String.Empty
        lblConfPSSCorreo.Text = String.Empty
        lblConfPSSDireccion.Text = String.Empty
        lblConfPSSFax.Text = String.Empty
        lblConfPSSNombre.Text = String.Empty
        lblConfPSSNumero.Text = String.Empty
        lblConfPSSTelefono.Text = String.Empty
        lblConfTrabCelular.Text = String.Empty
        lblConfTrabCorreo.Text = String.Empty
        lblConfTrabDireccion.Text = String.Empty
        lblConfTrabTelefono.Text = String.Empty

        lblConfirmar.Text = String.Empty

    End Sub

#End Region

#Region "Datos Iniciales"

    Protected Sub btnDatosIniciales_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDatosIniciales.Click

        divPadecimientos.Visible = False
        lblPin.Text = String.Empty
        Dim respuesta As String = String.Empty
        Dim pin As String = String.Empty

        'Guardar Info datos iniciales
        Try
            If txtTrabajadorTelefono.phoneNumber.Equals(String.Empty) Then
                lblMsg.Text = "El teléfono del empleado es requerido"
                Exit Sub
            End If
            If Left(txtTrabajadorTelefono.phoneNumber, 3) <> "809" and Left(txtTrabajadorTelefono.phoneNumber, 3) <> "829" Then
                lblMsg.Text = "Teléfono incorrecto, favor verificar"
                Exit Sub
            End If

            Dim nroFormulario As String = String.Empty
            If Not IsNothing(ViewState("NumeroFormulario")) Then
                nroFormulario = ViewState("NumeroFormulario").ToString
            End If

            RegistrarDatosIniciales(ucInfoEmpleado1.NSS.Replace("-", ""), ViewState("tipoSolicitud").ToString, nroFormulario, _
                                    txtTrabajadorDireccion.Text, txtTrabajadorTelefono.phoneNumber, txtTrabajadorCorreo.Text, _
                                    txtTrabajadorCelular.phoneNumber, Me.UsrRNC & Me.UsrCedula, respuesta, Me.numeroFormulario, pin)

            If respuesta.Equals("OK") Then

                ViewState("NumeroFormulario") = Me.numeroFormulario
                lblSolicitudRegistrada.Visible = True
                lblPin.Text = pin

                'Habilitar boton imprimir para traer formulario fisico
                divSolicitudRegistrada.Visible = True
                btnCompletar.Visible = False
                btnDatosIniciales.Visible = False

            Else
                lblMsg.Text = respuesta
                divSolicitudRegistrada.Visible = False
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click

        Limpiar()

        'Buscar info empleado, prevalidar, llenar control info empleado
        If txtCedula.Text.Length < 11 Then
            lblMsg.Text = "Cédula incorrecta"
        Else
            'Devuelve resultset y resultnumber, si resultnumber es cero (valido correctamente)
            'y resultset no tiene datos (no tiene padecimientos pendientes),
            'ejecutar proc y verificar existencia de registros estatus 'CP' o 'AC'
            Dim validaciones As String = String.Empty
            Dim enfPendientes As DataTable = Nothing
            ValidarRegEnfermedadComun(txtCedula.Text, UsrRegistroPatronal, validaciones, enfPendientes)

            If validaciones.Equals("OK") Then
                'mostrar info empleado
                Dim empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, txtCedula.Text)
                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento

                If Not ucInfoEmpleado1.NombreEmpleado.Equals(String.Empty) Then
                    divInfoEmpleado.Visible = True
                Else
                    lblMsg.Text = "Ha ocurrido un error, por favor intente nuevamente"
                    Exit Sub
                End If

                'Si el cursor trae datos, el trabajador tiene una solicitud pendiende y se muestran sus datos
                'sino, se pregunta si tiene registros completados o activos para renovar o hacer una nueva solicitud
                If Not IsNothing(enfPendientes) Then

                    If enfPendientes.Rows.Count > 0 Then

                        'Mostrar datos en los controles de la info inicial
                        Me.txtTrabajadorDireccion.Text = enfPendientes.Rows(0)("Direccion").ToString
                        Me.txtTrabajadorCelular.phoneNumber = enfPendientes.Rows(0)("Celular").ToString
                        Me.txtTrabajadorCorreo.Text = enfPendientes.Rows(0)("Email").ToString
                        Me.txtTrabajadorTelefono.phoneNumber = enfPendientes.Rows(0)("Telefono").ToString
                        Me.numeroFormulario = enfPendientes.Rows(0)("NroSolicitud").ToString

                        'Llenar ViewStates con datos iniciales para verificar que no se hayan cambiado
                        'antes de imprimir el formulario, en dicho caso, se hace un update con los cambios
                        ViewState("direccion") = enfPendientes.Rows(0)("Direccion").ToString
                        ViewState("celular") = enfPendientes.Rows(0)("Celular").ToString
                        ViewState("email") = enfPendientes.Rows(0)("Email").ToString
                        ViewState("telefono") = enfPendientes.Rows(0)("Telefono").ToString
                        ViewState("NumeroFormulario") = enfPendientes.Rows(0)("NroSolicitud").ToString
                        ViewState("tipoSolicitud") = "Nueva"

                        PanelesReimprimir()
                    Else
                        NuevaSolicitudORenovacion()
                    End If
                Else
                    NuevaSolicitudORenovacion()
                End If
            Else
                lblMsg.Text = validaciones
            End If

        End If
    End Sub
    Sub NuevaSolicitudORenovacion()

        Try
            'Preguntar si tiene registros CP,AC para renovacion o crear una nueva solicitud
            Dim padecimientos As New DataTable()
            Dim direccion As String = String.Empty
            Dim telefono As String = String.Empty
            Dim celular As String = String.Empty
            Dim correo As String = String.Empty
            padecimientos = PadecimientosRegistrados(ucInfoEmpleado1.NSS.Replace("-", ""), direccion, telefono, celular, correo)

            If Not IsNothing(padecimientos) Then
                'Si tiene registros, mostrar panel de Padecimientos
                If padecimientos.Rows.Count > 0 Then

                    gvPadecimientos.DataSource = padecimientos
                    gvPadecimientos.DataBind()

                    btnDatosIniciales.Visible = True
                    divPadecimientos.Visible = True
                    divSolicitudRegistrada.Visible = False

                    'Mostrar datos en los controles de la info inicial
                    Me.txtTrabajadorDireccion.Text = direccion
                    Me.txtTrabajadorCelular.phoneNumber = IIf(celular.Equals("null"), String.Empty, celular)
                    Me.txtTrabajadorCorreo.Text = IIf(correo.Equals("null"), String.Empty, correo)
                    Me.txtTrabajadorTelefono.phoneNumber = telefono

                    ViewState("tipoSolicitud") = "Renovacion"

                    txtTrabajadorDireccion.Focus()
                Else
                    'Si no contiene registros, crear nueva solicitud
                    NuevaSolicitud()
                End If
            Else
                NuevaSolicitud()
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub
    Sub NuevaSolicitud()

        ViewState("tipoSolicitud") = "Nueva"
        PanelesPrimeraSolicitud()

    End Sub

    Protected Sub btnNuevaSolicitud_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNuevaSolicitud.Click

        ViewState("tipoSolicitud") = "Nueva"
        PanelesNuevaSolicitud()

    End Sub

    Protected Sub gvSolicitudes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvPadecimientos.SelectedIndexChanged

        If Not divDatosIniciales.Visible Then
            If Not txtTrabajadorDireccion.Text.Equals(String.Empty) Then
                divDatosIniciales.Visible = True
                divBotonesDatosIniciales.Visible = True
                divSolicitudRegistrada.Visible = False
                divPadecimientos.Visible = False
            End If
        End If

        ViewState("NumeroFormulario") = gvPadecimientos.SelectedRow.Cells(0).Text

    End Sub
    Protected Sub btnVerFormulatio_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerFormulario.Click

        Dim respuesta As String = "OK"

        Try
            If txtTrabajadorTelefono.phoneNumber.Equals(String.Empty) Then
                lblMsg.Text = "El teléfono del empleado es requerido"
                Exit Sub
            End If

            'verificar valores actuales con viewstates para no cambiar si no se han alterado
            If Not (ViewState("direccion") = txtTrabajadorDireccion.Text And ViewState("celular") = txtTrabajadorCelular.phoneNumber And _
                ViewState("email") = txtTrabajadorCorreo.Text And ViewState("telefono") = txtTrabajadorTelefono.phoneNumber) Then

                respuesta = CambiarDatosIniciales(ViewState("NumeroFormulario").ToString, txtTrabajadorDireccion.Text, _
                                                                            txtTrabajadorTelefono.phoneNumber, txtTrabajadorCorreo.Text, _
                                                                            txtTrabajadorCelular.phoneNumber, Me.UsrRNC & Me.UsrCedula)
            End If

            If respuesta.Equals("OK") Then

                'Llenar valores para pasar al formulario de impresion
                Me.nombre = ucInfoEmpleado1.NombreEmpleado
                Me.sexo = ucInfoEmpleado1.Sexo
                Me.cedula = ucInfoEmpleado1.Cedula.Replace("-", "")
                Me.nss = ucInfoEmpleado1.NSS.Replace("-", "")
                Me.numeroFormulario = ViewState("NumeroFormulario").ToString
                Me.tipoSolicitud = ViewState("tipoSolicitud").ToString
                Dim hash As String = hashValores(Me.numeroFormulario, Me.cedula)

                Me.ClientScript.RegisterStartupScript(Me.GetType, "_cerrar", "<script language='javascript'> modelesswin('sfsFormularioEnfermedadComun.aspx?numero=" & _
                                                      hashValores(Me.numeroFormulario, String.Empty) & "&nombre=" & HttpUtility.UrlEncode(Me.nombre) & "&cedula=" & Me.cedula & "&nss=" & Me.nss & _
                                                      "&sexo=" & Me.sexo & "&tipoSolicitud=" & Me.tipoSolicitud & "&hash=" & hash & "');</script>")

            Else
                lblMsg.Text = respuesta

            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try
    End Sub
#End Region

#Region "Completar"
    Protected Sub btnCompletar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCompletar.Click

        Me.divBotonesDatosIniciales.Visible = False
        Me.divCompletar.Visible = True

        Try
            'traer nominas empleador para el ddl
            Dim nominaEmpleado As New DataTable
            nominaEmpleado = Nomina.GetNominaDiscapacitados(ucInfoEmpleado1.NSS.Replace("-", ""), UsrRegistroPatronal)
            If nominaEmpleado.Rows.Count > 0 Then
                ddlNomina.DataSource = nominaEmpleado
                ddlNomina.DataTextField = "nomina_des"
                ddlNomina.DataValueField = "id_nomina"
                ddlNomina.DataBind()

            End If
        Catch ex As Exception
            lblMsg.Text = ex.Message
            divCompletar.Visible = False
        End Try


    End Sub

    Protected Sub ckAmbulatoria_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckAmbulatoria.CheckedChanged

        'mostrar/ocultar div medico y Discapacidad
        divFechaDiasAmbulatorio.Visible = ckAmbulatoria.Checked

        If Not ckAmbulatoria.Checked Then
            If ckHospitalaria.Checked Then
                Me.MostrarAmb = True
                ViewState("MostrarAmb") = True
                divMedico.Visible = True
            Else
                Me.MostrarAmb = False
                ViewState("MostrarAmb") = False
                divMedico.Visible = False

                lblPSS.Text = String.Empty

                divDatosMedico.Visible = False
                txtPSSNombre.Enabled = True

                txtMedicoCedula.Enabled = True
                txtMedicoCedula.Text = String.Empty
                txtMedicoCelular.phoneNumber = String.Empty
                txtMedicoCorreo.Text = String.Empty
                txtMedicoDireccion.Text = String.Empty
                txtMedicoExequatur.Text = String.Empty
            End If
        Else
            Me.MostrarAmb = True
            ViewState("MostrarAmb") = True
            divMedico.Visible = True
        End If

        If Not divFechaDiasAmbulatorio.Visible Then
            txtDiscapFechaLicenciaAmb.Text = String.Empty
            txtDiscapDiasAmb.Text = String.Empty
        End If

        Me.MostrarAmb = Me.ckAmbulatoria.Checked
        ViewState("MostrarAmb") = MostrarAmb

        If CBool(ViewState("MostrarAmb")) Then ViewState("MostrarHosp") = False

        'PanelesModalidad()

    End Sub

    Protected Sub ckHospitalaria_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckHospitalaria.CheckedChanged
        'mostrar/ocultar div PSS y Discapacidad
        divPSS.Visible = ckHospitalaria.Checked
        divFechaDiasHospitalizacion.Visible = ckHospitalaria.Checked

        If Not ckHospitalaria.Checked Then
            If ckAmbulatoria.Checked Then
                Me.MostrarAmb = True
                ViewState("MostrarAmb") = True
                divMedico.Visible = True
            Else
                Me.MostrarAmb = False
                ViewState("MostrarAmb") = False
                divMedico.Visible = False

                divDatosPSS.Visible = False
                divFechaDiasHospitalizacion.Visible = False

                lblMedico.Text = String.Empty
                txtMedicoCedula.Enabled = True

                txtPSSNombre.Enabled = True
                txtPSSNombre.Text = String.Empty
                txtPssFax.phoneNumber = String.Empty
                txtPSSCorreo.Text = String.Empty
                txtPSSDireccion.Text = String.Empty
                txtPSSNumero.Text = String.Empty
                txtPssTelefono.phoneNumber = String.Empty
                txtMedicoTelefono.phoneNumber = String.Empty
                txtDiscapFechaLicenciaHosp.Text = String.Empty
                txtDiscapDiasHosp.Text = String.Empty
            End If
        Else
            Me.MostrarAmb = True
            ViewState("MostrarAmb") = True
            divMedico.Visible = True
        End If

        Me.MostrarHosp = ckHospitalaria.Checked
        ViewState("MostrarHosp") = MostrarHosp

        'PanelesModalidad()

    End Sub

    Protected Sub btnBuscarMedico_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscarMedico.Click

        'buscar tambien datos de la PSS si se suplio el nombre pero no se ha buscado
        If ((Not txtPSSNombre.Text.Equals(String.Empty)) And (Not divDatosPSS.Visible)) Then
            btnBuscarPSS_Click(sender, e)
        End If

        'buscar info medico y poblar campos, luego mostrar panel datos medico
        txtMedicoCedula.Enabled = False
        lblMedico.Text = String.Empty

        txtMedicoCelular.phoneNumber = String.Empty
        txtMedicoCorreo.Text = String.Empty
        txtMedicoDireccion.Text = String.Empty
        txtMedicoExequatur.Text = String.Empty
        txtMedicoNombre.Text = String.Empty
        txtMedicoTelefono.phoneNumber = String.Empty
        ViewState("NroMedico") = Nothing

        Dim datosMedico As New DataTable()

        Try

            datosMedico = getMedico(txtMedicoCedula.Text)

            If Not IsNothing(datosMedico) Then
                If datosMedico.Rows.Count > 0 Then

                    txtMedicoCelular.phoneNumber = datosMedico.Rows(0)("Cel_Med").ToString
                    txtMedicoDireccion.Text = datosMedico.Rows(0)("Dir_Med").ToString
                    txtMedicoNombre.Text = datosMedico.Rows(0)("Nombres_Med").ToString
                    txtMedicoTelefono.phoneNumber = datosMedico.Rows(0)("Tel_Med").ToString
                    ViewState("NroMedico") = IIf(datosMedico.Rows(0)("Nro_Medico").ToString.Equals(String.Empty), Nothing, datosMedico.Rows(0)("Nro_Medico").ToString)

                Else
                    lblMedico.Text = "No se encontró médico con la cédula suministrada"
                    Exit Sub
                End If
            Else
                lblMedico.Text = "No se encontró médico con la cédula suministrada"
                Exit Sub
            End If

            divDatosMedico.Visible = True
            divDiscapacidad.Visible = True

        Catch ex As Exception
            lblMedico.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnCancelarMedico_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarMedico.Click

        txtMedicoCedula.Enabled = True
        lblMedico.Text = String.Empty

        txtMedicoCedula.Text = String.Empty
        txtMedicoCedula.Focus()

        txtMedicoCelular.phoneNumber = String.Empty
        txtMedicoCorreo.Text = String.Empty
        txtMedicoDireccion.Text = String.Empty
        txtMedicoExequatur.Text = String.Empty
        txtMedicoTelefono.phoneNumber = String.Empty

        divDatosMedico.Visible = False

    End Sub

    Protected Sub btnBuscarPSS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscarPSS.Click

        'Para buscar los datos del medico tambien si no se ha buscado pero se suplio la cedula
        If ((Not txtMedicoCedula.Text.Equals(String.Empty)) And (Not divDatosMedico.Visible)) Then
            btnBuscarMedico_Click(sender, e)
        End If

        'buscar info PSS y poblar campos, luego mostrar panel datos PSS
        txtPSSNombre.Enabled = False
        lblPSS.Text = String.Empty

        txtPssFax.phoneNumber = String.Empty
        txtPSSCorreo.Text = String.Empty
        txtPSSDireccion.Text = String.Empty
        txtPSSNumero.Text = String.Empty
        txtPssTelefono.phoneNumber = String.Empty
        ViewState("RNCPSS") = Nothing

        Dim datosPSS As New DataTable()

        Try

            datosPSS = getPss(txtPSSNombre.Text)

            If Not IsNothing(datosPSS) Then
                If datosPSS.Rows.Count > 0 Then

                    txtPSSDireccion.Text = datosPSS.Rows(0)("direccion").ToString
                    txtPSSNumero.Text = datosPSS.Rows(0)("prestadora_numero").ToString
                    txtPssTelefono.phoneNumber = datosPSS.Rows(0)("telefono").ToString
                    txtPSSNombre.Text = datosPSS.Rows(0)("prestadora_nombre").ToString
                    ViewState("RNCPSS") = datosPSS.Rows(0)("rnccedula").ToString

                    'Puesto aqui a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
                    divDatosPSS.Visible = True
                    divDiscapacidad.Visible = True
                Else
                    'Puesto aqui a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
                    divDatosPSS.Visible = False
                    divDiscapacidad.Visible = False
                    lblCompletar.Text = String.Empty
                    lblPSS.Text = "Esta PSS no se encuentra registrada en nuestra base de datos, favor comunicarse con la SISALRIL para más información."
                    'Comentado a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
                    'lblPSS.Text = "No se encontró Prestadora de Servicio de Salud con el nombre suministrado, por favor complete los datos de la PSS"
                End If
            Else
                'Puesto aqui a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
                divDatosPSS.Visible = False
                divDiscapacidad.Visible = False
                lblCompletar.Text = String.Empty
                lblPSS.Text = "Esta PSS no se encuentra registrada en nuestra base de datos, favor comunicarse con la SISALRIL para más información."
                'Comentado a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
                'lblPSS.Text = "No se encontró Prestadora de Servicio de Salud con el nombre suministrado, por favor complete los datos de la PSS"
            End If

            'Comentado a solicitud SISALRIL de no dejar pasar si no existe la PSS digitada Oct 13 2009
            'divDatosPSS.Visible = True
            'divDiscapacidad.Visible = True

        Catch ex As Exception
            lblPSS.Text = ex.Message
        End Try

    End Sub

    Protected Sub btnCancelarPSS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarPSS.Click

        txtPSSNombre.Enabled = True
        lblPSS.Text = String.Empty

        txtPSSNombre.Text = String.Empty
        txtPSSNombre.Focus()

        txtPSSNombre.Text = String.Empty
        txtPssFax.phoneNumber = String.Empty
        txtPSSCorreo.Text = String.Empty
        txtPSSDireccion.Text = String.Empty
        txtPSSNumero.Text = String.Empty
        txtPssTelefono.phoneNumber = String.Empty

        divDatosPSS.Visible = False

    End Sub

#Region "Imagen Documento"
    Public Function ThumbnailCallBack() As Boolean
        Return False
    End Function
    Private Sub RehacerImagen()
        'Lee La primera imagen
        Dim intImageSize As Int64 = Me.upLImagenCiudadano.PostedFile.ContentLength
        Dim ImageStream As Stream = Me.upLImagenCiudadano.PostedFile.InputStream
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
        ' ViewState("ImagenMod") = ms.GetBuffer
        ImagenMod = ms.GetBuffer

    End Sub
    Protected Function ValidarImagen() As Boolean
        'validacion imagen cargando(TIF o JPG )
        Try
            If Me.upLImagenCiudadano.HasFile() Then
                imgStream = upLImagenCiudadano.PostedFile.InputStream
                imgLength = upLImagenCiudadano.PostedFile.ContentLength
                imagName = upLImagenCiudadano.FileName
                Dim imgContentType As String = upLImagenCiudadano.PostedFile.ContentType

                'validamos los tipos de archivos que deseamos aceptar
                If imgContentType = "image/JPG" Or imgContentType = "image/JPEG" Or imgContentType = "image/TIFF" Or imgContentType = "image/TIF" Or imgContentType = "image/BMP" Then

                    Dim imgSize As String = (imgLength / 1024)
                    If imgSize > 600 Then
                        'Throw New Exception("Esta imagen no debe superar los 600KB")
                        RehacerImagen()
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        'ViewState("ImagenMod") = imageContent
                        ImagenMod = imageContent
                    End If

                    Return True
                Else
                    Dim imageContent(imgLength) As Byte
                    imgStream.Read(imageContent, 0, imgLength)
                    'ViewState("ImagenMod") = imageContent
                    ImagenMod = imageContent

                    Return True
                End If
            Else
                Return False
            End If
        Catch ex As Exception
            Me.lblCompletar.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return False
        End Try
    End Function
#End Region

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click

        'Muestra panel de confirmacion de datos con los datos editados
        LimpiarValoresConfirmacion()

        'Validacion telefono Datos Generales
        If txtTrabajadorTelefono.phoneNumber.Equals(String.Empty) Then
            lblCompletar.Text = "El número de teléfono del empleado(a) médico es obligatorio"
            Exit Sub
        End If
        If Left(txtTrabajadorTelefono.phoneNumber, 3) <> "809" And Left(txtTrabajadorTelefono.phoneNumber, 3) <> "829" Then
            lblCompletar.Text = "Teléfono del empleado(a) inválido"
            Exit Sub
        End If

        'Validaciones de completado de informacion PSS y Medico
        If ((Not txtPSSNombre.Text.Equals(String.Empty)) And (Not divDatosPSS.Visible)) Then
            btnBuscarPSS_Click(sender, e)
            If txtPSSDireccion.Text.Equals(String.Empty) Or txtPssTelefono.phoneNumber.Equals(String.Empty) Then
                lblCompletar.Text = "Por favor completar los campos obligatorios de la PSS (Nombre, Teléfono y Dirección)"
                Exit Sub
            End If
        End If
        If ((Not txtMedicoCedula.Text.Equals(String.Empty)) And (Not divDatosMedico.Visible)) Then
            btnBuscarMedico_Click(sender, e)
            If txtMedicoDireccion.Text.Equals(String.Empty) Or txtMedicoExequatur.Text.Equals(String.Empty) Or txtMedicoTelefono.phoneNumber.Equals(String.Empty) Then
                lblCompletar.Text = "Por favor completar los campos obligatorios del Médico (Cédula, Teléfono, Dirección y Exequatur)"
                Exit Sub
            End If
        End If

        'Validar que no falten telefonos obligatorios
        If CBool(ViewState("MostrarAmb")) Then
            If txtMedicoTelefono.phoneNumber.Equals(String.Empty) Then
                lblCompletar.Text = "El número de teléfono del consultorio médico es obligatorio"
                Exit Sub
            End If
            If Left(txtMedicoTelefono.phoneNumber, 3) <> "809" And Left(txtMedicoTelefono.phoneNumber, 3) <> "829" Then
                lblCompletar.Text = "Teléfono del consultorio inválido"
                Exit Sub
            End If
        End If

        If CBool(ViewState("MostrarHosp")) Then
            If txtPssTelefono.phoneNumber.Equals(String.Empty) Then
                lblCompletar.Text = "El número de teléfono de la PSS es obligatorio"
                Exit Sub
            End If
            If Left(txtPssTelefono.phoneNumber, 3) <> "809" And Left(txtPssTelefono.phoneNumber, 3) <> "829" Then
                lblCompletar.Text = "Teléfono de la PSS inválido"
                Exit Sub
            End If
        End If

        'Validar que no falte el tipo de discapacidad
        If (Not rdAccidente.Checked) And (Not rdEmbarazo.Checked) And (Not rdEnfermedadComun.Checked) Then
            lblCompletar.Text = "Debe seleccionar el tipo de Discapacidad"
            Exit Sub
        End If

        'Validar codigo CIE-10 si fue suplido
        If Not txtDiscapCIE10.Text.Equals(String.Empty) Then
            Try
                Dim isCIE10 As Boolean = ExisteCodigoCie10(txtDiscapCIE10.Text)
                If Not isCIE10 Then
                    lblCompletar.Text = "El código CIE-10 suplido no es válido"
                    Exit Sub
                End If
            Catch ex As Exception
                lblCompletar.Text = "El código CIE-10 suplido no es válido"
            End Try
        End If

        'Validar fecha inicio licencia no sea menor fecha diagnostico, o fecha diagnostico futura, o telefono invalido
        If Not DateTimeError("de diagnóstico", txtDiscapFechaDiagnostico) Then
            Exit Sub
        End If

        If ckAmbulatoria.Checked Then
            If Not DateTimeError("ambulatoria", txtDiscapFechaLicenciaAmb) Then
                Exit Sub
            End If

            If ckHospitalaria.Checked Then
                If Not DateTimeError("hospitalaria", txtDiscapFechaLicenciaHosp) Then
                    Exit Sub
                End If
                If Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) = Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                    lblCompletar.Text = "La fecha de inicio de licencias no deben coincidir"
                    Exit Sub
                End If
                If Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) < Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                    If DateAdd(DateInterval.Day, CInt(txtDiscapDiasAmb.Text), Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text)) > Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                        lblCompletar.Text = "La fecha de inicio de licencias no deben coincidir"
                        Exit Sub
                    End If
                End If
            End If

            If Convert.ToDateTime(txtDiscapFechaDiagnostico.Text) > Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) Then

                lblCompletar.Text = "La fecha de inicio de licencia Ambulatoria debe ser mayor que la fecha de Diagnóstico"
                Exit Sub
            End If

            If txtDiscapDiasAmb.Text <= 0 Then
                lblCompletar.Text = "Cantidad de días calendario ambulatoria inválida"
                Exit Sub
            End If
        End If
        If ckHospitalaria.Checked Then
            If Not DateTimeError("hospitalaria", txtDiscapFechaLicenciaHosp) Then
                Exit Sub
            End If
            If ckAmbulatoria.Checked Then
                If Not DateTimeError("ambulatoria", txtDiscapFechaLicenciaAmb) Then
                    Exit Sub
                End If
                If Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) < Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) Then
                    If DateAdd(DateInterval.Day, CInt(txtDiscapDiasHosp.Text), Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text)) > Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) Then
                        lblCompletar.Text = "La fecha de inicio de licencias no deben coincidir"
                        lblCompletar.Focus()
                        Exit Sub
                    End If
                End If
            End If
            If Convert.ToDateTime(txtDiscapFechaDiagnostico.Text) > Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                lblCompletar.Text = "La fecha de inicio de licencia Hospitalaria debe ser mayor que la fecha de Diagnóstico"
                Exit Sub
            End If
            If txtDiscapDiasHosp.Text <= 0 Then
                lblCompletar.Text = "Cantidad de días calendario hospitalaria inválida"
                Exit Sub
            End If
        End If

        'Validar fecha diagnostico futura
        If txtDiscapFechaDiagnostico.Text > Now Then
            lblCompletar.Text = "La fecha de Diagnóstico no debe ser futura"
            Exit Sub
        End If

        lblPSS.Text = String.Empty

        RegistrarDatosConfirmacion()


    End Sub
    Private Function DateTimeError(ByVal fecha As String, ByVal fechaControl As TextBox) As Boolean

        Dim dtm As System.DateTime
        If Not System.DateTime.TryParse(fechaControl.Text, dtm) Then

            SuirPlus.Exepciones.Log.LogToDB("Enfermedad Comun: Error en fecha: " & fechaControl.Text)
            Me.lblCompletar.Text = "Error en la fecha " & fecha
            Return False

        End If

        Return True

    End Function

    Private Sub RegistrarDatosConfirmacion()

        lblConfTrabCelular.Text = txtTrabajadorCelular.phoneNumber
        lblConfTrabCorreo.Text = txtTrabajadorCorreo.Text
        lblConfTrabDireccion.Text = txtTrabajadorDireccion.Text
        lblConfTrabTelefono.Text = txtTrabajadorTelefono.phoneNumber
        lblConfNomina.Text = ProperCase(ddlNomina.SelectedItem.Text)
        If ckAmbulatoria.Checked Then
            divConfAmbulatoria.Visible = True
            lblConfDiscapLicenciaAmb.Text = txtDiscapFechaLicenciaAmb.Text
            lblConfDiscapDiasAmb.Text = txtDiscapDiasAmb.Text
        End If
        If ckHospitalaria.Checked Then
            divConfHospitalaria.Visible = True
            lblConfDiscapLicenciaHosp.Text = txtDiscapFechaLicenciaHosp.Text
            lblConfDiscapDiasHosp.Text = txtDiscapDiasHosp.Text
        End If
        If CBool(ViewState("MostrarHosp")) Then
            divConfPSS.Visible = True
            lblConfPSSCorreo.Text = txtPSSCorreo.Text
            lblConfPSSDireccion.Text = txtPSSDireccion.Text
            lblConfPSSFax.Text = txtPssFax.phoneNumber
            lblConfPSSNombre.Text = ProperCase(txtPSSNombre.Text)
            lblConfPSSNumero.Text = txtPSSNumero.Text
            lblConfPSSTelefono.Text = txtPssTelefono.phoneNumber
        End If
        If CBool(ViewState("MostrarAmb")) Then
            divConfMedico.Visible = True
            lblConfMedicoCedula.Text = txtMedicoCedula.Text
            lblConfMedicoNombre.Text = ProperCase(txtMedicoNombre.Text)
            lblConfMedicoCelular.Text = txtMedicoCelular.phoneNumber
            lblConfMedicoCorreo.Text = txtMedicoCorreo.Text
            lblConfMedicoDireccion.Text = txtMedicoDireccion.Text
            lblConfMedicoExequatur.Text = txtMedicoExequatur.Text
            lblConfMedicoTelefono.Text = txtMedicoTelefono.phoneNumber
        End If
        If rdAccidente.Checked Then
            lblConfDiscapTipo.Text = rdAccidente.Text
        ElseIf rdEmbarazo.Checked Then
            lblConfDiscapTipo.Text = rdEmbarazo.Text
        Else
            lblConfDiscapTipo.Text = rdEnfermedadComun.Text
        End If
        lblConfDiscapCIE10.Text = txtDiscapCIE10.Text
        lblConfDiscapDiagnostico.Text = txtDiscapDiagnostico.Text
        lblConfDiscapSintomas.Text = txtDiscapSintomas.Text
        lblConfDiscapProcedimientos.Text = txtDiscapProcedimientos.Text
        lblConfDiscapFechaDiagnostico.Text = txtDiscapFechaDiagnostico.Text

        lblCompletar.Text = String.Empty
        divCompletar.Visible = False
        divDatosIniciales.Visible = False
        divConfirmar.Visible = True

    End Sub

    Protected Sub btnCancelarCompletado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarCompletado.Click

        Limpiar()

    End Sub

    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContinuar.Click

        divConfirmar.Visible = False
        divImagen.Visible = True

    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click

        LimpiarValoresConfirmacion()
        divCompletar.Visible = True
        divDatosIniciales.Visible = True
        divConfirmar.Visible = False

    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click

        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        If ret.Equals("Cambio Realizado") Then
            Limpiar()
            Response.Redirect("NovedadesAplicadas.aspx?msg=Novedad aplicada satisfactoriamente.")
        Else
            lblTerminar.Text = ret
        End If

    End Sub

    Protected Sub btnConfirmar_Click1(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirmar.Click

        Dim resp As String = String.Empty
        Dim id_movimiento As String = String.Empty
        Dim id_linea As String = String.Empty

        lblConfirmar.Text = String.Empty
        lblTerminar.Text = String.Empty

        'TODO: medico que no existe no tiene numero
        Dim NroMedico As String = Nothing
        If Not IsNothing(ViewState("NroMedico")) Then
            NroMedico = Convert.ToInt32(ViewState("NroMedico"))
        End If

        Dim NroPSS As Integer = Nothing
        If Not lblConfPSSNumero.Text.Equals(String.Empty) Then
            NroPSS = Convert.ToInt32(lblConfPSSNumero.Text)
        End If

        Dim fechaAmb As Date = Nothing
        If Not lblConfDiscapLicenciaAmb.Text.Equals(String.Empty) Then
            fechaAmb = lblConfDiscapLicenciaAmb.Text
        End If

        Dim fechaHosp As Date = Nothing
        If Not lblConfDiscapLicenciaHosp.Text.Equals(String.Empty) Then
            fechaHosp = lblConfDiscapLicenciaHosp.Text
        End If

        Dim diasAmb As Integer = Nothing
        If Not lblConfDiscapDiasAmb.Text.Equals(String.Empty) Or Not lblConfDiscapDiasAmb.Text.Equals("&nbsp;") Then
            If Not System.Int32.TryParse(lblConfDiscapDiasAmb.Text, diasAmb) Then

                SuirPlus.Exepciones.Log.LogToDB("Enfermedad Comun: Error en numero amb: " & lblConfDiscapDiasAmb.Text)
            Else
                diasAmb = Convert.ToInt32(lblConfDiscapDiasAmb.Text)
            End If

        End If

        Dim diasHosp As Integer = Nothing
        If Not lblConfDiscapDiasHosp.Text.Equals(String.Empty) Then
            diasHosp = Convert.ToInt32(lblConfDiscapDiasHosp.Text)
        End If

        'Validar imagen si subio imagen
        If ckImagen.Checked Then
            If upLImagenCiudadano.HasFile Then

                If upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/jpg" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/pjpeg" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/jpeg" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/tiff" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/tif" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "image/bmp" Or upLImagenCiudadano.PostedFile.ContentType.ToLower = "application/pdf" Then
                    If Not ValidarImagen() Then
                        lblTerminar.Text = "Ocurrió un error registrando la imagen, por favor intente nuevamente"
                        Exit Sub
                    End If
                Else
                    lblTerminar.Text = "Formato de archivo incorrecto, por favor verifique e intente nuevamente"
                    Exit Sub
                End If

            Else
                lblTerminar.Text = "Debe seleccionar una imagen de documento para anexar"
                Exit Sub
            End If
            End If

        Try
            
            'inserta el movimiento, muestra error validacion en caso de, o mensaje proceso exitoso
            resp = RegistroEnfComun(ViewState("NumeroFormulario").ToString, txtTrabajadorDireccion.Text, lblConfTrabTelefono.Text, _
                                                  lblConfTrabCorreo.Text, lblConfTrabCelular.Text, UsrRNC & UsrCedula, NroMedico, _
                                                  lblConfMedicoCedula.Text, lblConfMedicoNombre.Text, lblConfMedicoDireccion.Text, _
                                                  lblConfMedicoTelefono.Text, lblConfMedicoCelular.Text, lblConfMedicoCorreo.Text, _
                                                  NroPSS, txtPSSNombre.Text.ToUpper(), lblConfPSSDireccion.Text, _
                                                  lblConfPSSTelefono.Text, lblConfPSSFax.Text, lblConfPSSCorreo.Text, _
                                                  lblConfDiscapTipo.Text.Substring(0, 1), lblConfDiscapDiagnostico.Text, lblConfDiscapSintomas.Text, _
                                                  lblConfDiscapProcedimientos.Text, IIf(ckAmbulatoria.Checked, "S", "N"), fechaAmb, _
                                                  diasAmb, IIf(ckHospitalaria.Checked, "S", "N"), fechaHosp, diasHosp, _
                                                  Convert.ToDateTime(lblConfDiscapFechaDiagnostico.Text), Convert.ToInt32(UsrRegistroPatronal), 0, _
                                                  UsrRNC & UsrCedula, lblConfDiscapCIE10.Text, lblConfMedicoExequatur.Text, Convert.ToInt32(ddlNomina.Text), _
                                                  id_movimiento, id_linea)

        Catch ex As Exception
            lblTerminar.Text = ex.Message
        End Try


        If resp.Equals("OK") Then
            Try
                If ckImagen.Checked Then
                    'Subir imagen si se grabo el registro exitosamente
                    Dim cargaImagen As String = CargaImagenFormulario(CInt(id_movimiento), CInt(id_linea), imagName, ImagenMod)

                    If Not cargaImagen.Equals("OK") Then
                        lblTerminar.Text = "Ocurrió un error cargando la imagen, por favor remitirla via fax"
                    End If
                End If
            Catch ex As Exception
                lblTerminar.Text = ex.Message
            End Try


            ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
            If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                'lblTerminar.Text = String.Empty
                divDatosIniciales.Visible = False
                divCompletar.Visible = False
                divConfirmar.Visible = False
                divImagen.Visible = False
                divNovedades.Visible = True
            End If

        Else
            lblTerminar.Text = resp
        End If

    End Sub

    Protected Sub btnCancelarConfirmacion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarConfirmacion.Click
        divImagen.Visible = False
        divConfirmar.Visible = True
        lblTerminar.Text = True
    End Sub
#End Region

End Class
