Imports System.Data
Imports System.IO
Imports SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios.Utils
Partial Class Novedades_sfsEnfRenovarPadecimiento
    Inherits BasePage

    Protected cuentaBancaria As SuirPlus.Empresas.CuentaBancaria
    Dim numeroFormulario As String = String.Empty
    Private tipoSolicitud As String
    Private solicitudRegistrada As String
    Private nombre As String
    Private sexo As String
    Private cedula As String
    Private nss As String


#Region "DatosIniciales"

#Region "SubsDatosIniciales"
    Private Sub Limpiar()
        'Limpiar todo
        lblMsg.Text = String.Empty
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
        LimpiarDatosIniciales()

        'Modalidad
        ckAmbulatoria.Checked = False
        ckHospitalaria.Checked = False

        'Medico
        txtMedicoCedula.Text = String.Empty
        LimpiarDatosMedico()

        'PSS
        txtPSSNombre.Text = String.Empty
        LimpiarDatosPSS()

        'Renovacion
        gvPadecimientos.DataSource = Nothing
        gvPadecimientos.DataBind()

        'Discapacidad
        LimpiarDatosDiscapacidad()
        ckImagen.Checked = False

        'resetear todas las variables
        ViewState("direccion") = Nothing
        ViewState("celular") = Nothing
        ViewState("email") = Nothing
        ViewState("telefono") = Nothing
        ViewState("NumeroFormulario") = Nothing
        ViewState("NroMedico") = Nothing

    End Sub
    Private Function ValidarTelefonos(ByVal telefono As Controles_ucTelefono2, ByVal labelControl As Label, ByVal sujeto As String) As Boolean
        If telefono.phoneNumber.Equals(String.Empty) Then
            labelControl.Text = "El teléfono " & sujeto & " es requerido"
            Return False
        End If
        If Left(telefono.phoneNumber, 3) <> "809" And Left(telefono.phoneNumber, 3) <> "829" Then
            labelControl.Text = "El formato de teléfono " & sujeto & " es incorrecto, favor verificar"
            Return False
        End If
        Return True
    End Function
    Private Function CargarInfoEmpleado() As Boolean
        'mostrar info empleado
        Dim empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, txtCedula.Text)
        ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
        ucInfoEmpleado1.NSS = empleado.NSS.ToString
        ucInfoEmpleado1.Cedula = empleado.Documento
        ucInfoEmpleado1.Sexo = empleado.Sexo
        ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento

        If Not ucInfoEmpleado1.NombreEmpleado.Equals(String.Empty) Then
            divInfoEmpleado.Visible = True
            Return True
        Else
            divInfoEmpleado.Visible = False
            Return False
        End If
    End Function
    Private Sub LoadDatosIniciales(ByVal formulario As DataTable)
        LimpiarDatosIniciales()
        CargarDatosIniciales(formulario)
        MostrarDatosIniciales()
    End Sub
    Private Sub LoadNuevoFormulario()
        LimpiarDatosIniciales()
        MostrarDatosIniciales()
        OcultarDatosCompletado()

        btnRegistrarDatosIniciales.Visible = True
        btnCompletar.Visible = False
        Me.divSolicitudRegistrada.Visible = False
    End Sub
    Private Sub OcultarDatosCompletado()
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
    Private Sub MostrarDatosIniciales()
        btnRegistrarDatosIniciales.Visible = False
        btnCompletar.Visible = True

        Me.divBotonesDatosIniciales.Visible = True
        Me.divDatosIniciales.Visible = True
        Me.divSolicitudRegistrada.Visible = False
    End Sub
    Private Sub LimpiarDatosIniciales()
        Me.txtTrabajadorDireccion.Text = String.Empty
        Me.txtTrabajadorCelular.phoneNumber = String.Empty
        Me.txtTrabajadorCorreo.Text = String.Empty
        Me.txtTrabajadorTelefono.phoneNumber = String.Empty
    End Sub
    Private Sub CargarDatosIniciales(ByVal formulario As DataTable)
        'Mostrar datos en los controles de la info inicial
        Me.txtTrabajadorDireccion.Text = formulario.Rows(0)("Direccion").ToString
        Me.txtTrabajadorCelular.phoneNumber = formulario.Rows(0)("Celular").ToString
        Me.txtTrabajadorCorreo.Text = formulario.Rows(0)("Email").ToString
        Me.txtTrabajadorTelefono.phoneNumber = formulario.Rows(0)("Telefono").ToString
        Me.numeroFormulario = formulario.Rows(0)("NroSolicitud").ToString

        'Llenar ViewStates con datos iniciales para verificar que no se hayan cambiado
        'antes de imprimir el formulario, en dicho caso, se hace un update con los cambios
        ViewState("direccion") = formulario.Rows(0)("Direccion").ToString
        ViewState("celular") = formulario.Rows(0)("Celular").ToString
        ViewState("email") = formulario.Rows(0)("Email").ToString
        ViewState("telefono") = formulario.Rows(0)("Telefono").ToString
        ViewState("NumeroFormulario") = formulario.Rows(0)("NroSolicitud").ToString
    End Sub
#End Region

#Region "Eventos"
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

    End Sub
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        'TODO: arreglar el grid
        Limpiar()

        'Validaciones:DocumentoValido, ActivoEnNomina, MovPendientes, ElegiblePendiente
        'Si alguna de estas validaciones se dispara, se muestra el mensaje, sino, se corre Validacion2
        Dim validaciones As String = String.Empty
        Dim formPendiente As DataTable = Nothing
        ValidarRegEnfermedadComun(txtCedula.Text, UsrRegistroPatronal, validaciones, formPendiente)

        If validaciones.Equals("OK") Then
            If CargarInfoEmpleado() Then
                Renovacion(formPendiente)
            End If
        Else
            lblMsg.Text = validaciones
        End If

    End Sub
    Sub Renovacion(ByVal formularioPendiente As DataTable)
        Dim direccion As String = String.Empty
        Dim telefono As String = String.Empty
        Dim celular As String = String.Empty
        Dim correo As String = String.Empty
        Try
            Dim padecimientos As New DataTable()
            padecimientos = PadecimientosRegistrados(ucInfoEmpleado1.NSS.Replace("-", ""), direccion, telefono, celular, correo)

            'Validacion2: Tiene una Solicitud completada?, si la tiene, vamos a la Validacion3, sino
            'se le informa al usuario que no tiene padecimientos para renovar
            If Not IsNothing(padecimientos) Then

                If padecimientos.Rows.Count > 0 Then

                    'Validacion3: Tiene un formulario pendiente de completar?, si la funcion trae datos, tiene opcion de completar los datos,
                    'sino, se presenta el listado de padecimientos para renovar
                    If Not IsNothing(formularioPendiente) Then

                        If formularioPendiente.Rows.Count > 0 Then
                            LoadDatosIniciales(formularioPendiente)
                            ViewState("NumeroFormulario") = formularioPendiente.Rows(0)("NroSolicitud").ToString
                        Else
                            LoadPadecimientos(padecimientos, direccion, celular, correo, telefono)

                        End If
                End If

            Else
                lblMsg.Text = "El(la) trabajador(a) no tiene padecimientos para renovar"
                Exit Sub
            End If
            Else
            lblMsg.Text = "El(la) trabajador(a) no tiene padecimientos para renovar"
            Exit Sub
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub
    Private Sub LoadPadecimientos(ByVal padecimientos As DataTable, ByVal direccion As String, ByVal celular As String, ByVal correo As String, ByVal telefono As String)


        gvPadecimientos.DataSource = padecimientos
        gvPadecimientos.DataBind()

        btnRegistrarDatosIniciales.Visible = True
        divPadecimientos.Visible = True
        divSolicitudRegistrada.Visible = False

        'Mostrar datos en los controles de la info inicial
        Me.txtTrabajadorDireccion.Text = direccion
        Me.txtTrabajadorCelular.phoneNumber = IIf(celular.Equals("null"), String.Empty, celular)
        Me.txtTrabajadorCorreo.Text = IIf(correo.Equals("null"), String.Empty, correo)
        Me.txtTrabajadorTelefono.phoneNumber = telefono

        txtTrabajadorDireccion.Focus()
    End Sub
    Protected Sub btnRegistrarDatosIniciales_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrarDatosIniciales.Click

        Me.lblPin.Text = String.Empty
        Dim respuesta As String = String.Empty
        Dim pin As String = String.Empty

        Try

            If Not ValidarTelefonos(txtTrabajadorTelefono, lblMsg, "del trabajador") Then
                Exit Sub
            End If

            Dim nroFormulario As String = String.Empty
            If Not IsNothing(ViewState("NumeroFormulario")) Then
                nroFormulario = ViewState("NumeroFormulario").ToString
            End If

            'Guardar Info datos iniciales
            RegistrarDatosIniciales(CInt(ucInfoEmpleado1.NSS.Replace("-", "")), "Renovacion", nroFormulario, _
            txtTrabajadorDireccion.Text, txtTrabajadorTelefono.phoneNumber, txtTrabajadorCorreo.Text, _
            txtTrabajadorCelular.phoneNumber, Me.UsrRNC & Me.UsrCedula, respuesta, nroFormulario, pin)

            If respuesta.Equals("OK") Then
                'Habilitar boton imprimir para traer formulario fisico
                ViewState("NumeroFormulario") = nroFormulario
                divSolicitudRegistrada.Visible = True
                lblPin.Text = pin

                btnCompletar.Visible = False
                btnRegistrarDatosIniciales.Visible = False
            Else
                lblMsg.Text = respuesta
                divSolicitudRegistrada.Visible = False
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try
    End Sub
    Protected Sub btnVerFormulario_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVerFormulario.Click

        Dim respuesta As String = "OK"

        Try
            If Not ValidarTelefonos(txtTrabajadorTelefono, lblMsg, "del trabajador") Then
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
                Me.numeroFormulario = ViewState("NumeroFormulario").ToString
                Dim tipo = "Renovacion"
                Dim hash As String = hashValores(Me.numeroFormulario, ucInfoEmpleado1.Cedula.Replace("-", ""))

                Me.ClientScript.RegisterStartupScript(Me.GetType, "_cerrar", "<script language='javascript'> modelesswin('sfsFormularioEnfermedadComun.aspx?numero=" & _
                hashValores(Me.numeroFormulario, String.Empty) & "&nombre=" & Server.UrlEncode(ucInfoEmpleado1.NombreEmpleado) & "&cedula=" & ucInfoEmpleado1.Cedula.Replace("-", "") & "&nss=" & ucInfoEmpleado1.NSS.Replace("-", "") & _
                "&sexo=" & ucInfoEmpleado1.Sexo & "&tipoSolicitud=" & tipo & "&hash=" & hash & "');</script>")

            Else
                lblMsg.Text = respuesta
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub
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
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        txtCedula.Text = String.Empty
        Limpiar()
    End Sub
#End Region

#End Region


#Region "Renovacion"
    Protected Sub gvSolicitudes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvPadecimientos.SelectedIndexChanged

        If Not divDatosIniciales.Visible Then
            If Not txtTrabajadorDireccion.Text.Equals(String.Empty) Then
                divDatosIniciales.Visible = True
                divBotonesDatosIniciales.Visible = True
                divSolicitudRegistrada.Visible = False
                divPadecimientos.Visible = False

                btnCompletar.Visible = False
            End If
        End If

        ViewState("NumeroFormulario") = gvPadecimientos.SelectedRow.Cells(0).Text

    End Sub
#End Region


#Region "Completar"

#Region "Ambulatoria"
    Protected Sub ckAmbulatoria_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckAmbulatoria.CheckedChanged

        If ckAmbulatoria.Checked Then
            MostrarMedico()
        Else
            divFechaDiasAmbulatorio.Visible = False
            'No ocultar datos medico si mod hospitalaria esta seleccionada
            If Not ckHospitalaria.Checked Then
                OcultarMedico()
            End If
        End If

        MostrarOcultarDatosDiscapacidad()

    End Sub
    Protected Sub btnBuscarMedico_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscarMedico.Click

        LimpiarDatosMedico()
        txtMedicoCedula.Enabled = False
        ViewState("NroMedico") = Nothing

        Dim datosMedico As New DataTable()
        Try
            datosMedico = getMedico(txtMedicoCedula.Text)

            If Not IsNothing(datosMedico) Then
                If datosMedico.Rows.Count > 0 Then
                    LlenarDatosMedico(datosMedico)
                Else
                    lblMedico.Text = "No se encontró médico con la cédula suministrada"
                    Exit Sub
                End If
            Else
                lblMedico.Text = "No se encontró médico con la cédula suministrada"
                Exit Sub
            End If

            divDatosMedico.Visible = True
            MostrarOcultarDatosDiscapacidad()

        Catch ex As Exception
            lblMedico.Text = ex.Message
        End Try

    End Sub
    Private Sub MostrarMedico()

        divMedico.Visible = True
        divFechaDiasAmbulatorio.Visible = True

    End Sub
    Private Sub LimpiarDatosMedico()

        lblMedico.Text = String.Empty

        txtMedicoCedula.Enabled = True
        txtMedicoCelular.phoneNumber = String.Empty
        txtMedicoTelefono.phoneNumber = String.Empty
        txtMedicoCorreo.Text = String.Empty
        txtMedicoDireccion.Text = String.Empty
        txtMedicoExequatur.Text = String.Empty

    End Sub
    Private Sub LlenarDatosMedico(ByVal datosMedico As DataTable)

        txtMedicoCelular.phoneNumber = datosMedico.Rows(0)("Cel_Med").ToString
        txtMedicoDireccion.Text = datosMedico.Rows(0)("Dir_Med").ToString
        txtMedicoNombre.Text = datosMedico.Rows(0)("Nombres_Med").ToString
        txtMedicoTelefono.phoneNumber = datosMedico.Rows(0)("Tel_Med").ToString
        ViewState("NroMedico") = IIf(datosMedico.Rows(0)("Nro_Medico").ToString.Equals(String.Empty), Nothing, datosMedico.Rows(0)("Nro_Medico").ToString)

    End Sub
    Private Sub OcultarMedico()

        divMedico.Visible = False
        divDatosMedico.Visible = False

        txtMedicoCedula.Enabled = True

        lblMedico.Text = String.Empty
        txtMedicoCedula.Text = String.Empty
        LimpiarDatosMedico()

        divFechaDiasAmbulatorio.Visible = False
        txtDiscapDiasAmb.Text = String.Empty
        txtDiscapFechaLicenciaAmb.Text = String.Empty

    End Sub
    Protected Sub btnCancelarMedico_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarMedico.Click

        LimpiarDatosMedico()
        divDatosMedico.Visible = False

        txtMedicoCedula.Text = String.Empty
        txtMedicoCedula.Focus()

        MostrarOcultarDatosDiscapacidad()

    End Sub
    Private Function ValidarRegistroAmbulatorio() As Boolean

        'Validacion datos Obligatorios Medico
        If divDatosMedico.Visible Then
            If txtMedicoDireccion.Text.Equals(String.Empty) Then
                lblMsg.Text = "La direccón del consultorio Médico es obligatoria"
                Return False
            End If

            'Validacion telefono Medico
            If Not ValidarTelefonos(txtMedicoTelefono, lblMsg, "del consultorio médico") Then
                Return False
            End If
        End If

        'Validacion Fechas
        If ckAmbulatoria.Checked Then
            If Not ValidarFechas(txtDiscapFechaLicenciaAmb, txtDiscapDiasAmb.Text, "ambulatoria") Then
                Return False
            End If
        End If
        lblMsg.Text = String.Empty
        Return True

    End Function
#End Region

#Region "Hospitalaria"
    Protected Sub ckHospitalaria_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ckHospitalaria.CheckedChanged

        If ckHospitalaria.Checked Then
            MostrarPSS()
        Else
            If ckAmbulatoria.Checked Then
                OcultarPSS()
            Else
                OcultarPSS()
                OcultarMedico()
            End If
        End If

        MostrarOcultarDatosDiscapacidad()

    End Sub
    Private Sub LlenarDatosPSS(ByVal datosPSS As DataTable)
        txtPSSDireccion.Text = datosPSS.Rows(0)("direccion").ToString
        txtPSSNumero.Text = datosPSS.Rows(0)("prestadora_numero").ToString
        txtPssTelefono.phoneNumber = datosPSS.Rows(0)("telefono").ToString
        txtPSSNombre.Text = datosPSS.Rows(0)("prestadora_nombre").ToString
    End Sub
    Protected Sub btnBuscarPSS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBuscarPSS.Click

        LimpiarDatosPSS()
        txtPSSNombre.Enabled = False

        Dim datosPSS As New DataTable()
        Try
            datosPSS = getPss(txtPSSNombre.Text)

            If Not IsNothing(datosPSS) Then
                If datosPSS.Rows.Count > 0 Then
                    LlenarDatosPSS(datosPSS)
                Else
                    lblPSS.Text = "Esta PSS no se encuentra registrada en nuestra base de datos, favor comunicarse con la SISALRIL para más información."
                    Exit Sub
                End If
            Else
                lblPSS.Text = "Esta PSS no se encuentra registrada en nuestra base de datos, favor comunicarse con la SISALRIL para más información."
                Exit Sub
            End If

            divDatosPSS.Visible = True
            MostrarOcultarDatosDiscapacidad()

        Catch ex As Exception
            lblPSS.Text = ex.Message
        End Try

    End Sub
    Private Sub MostrarPSS()
        divPSS.Visible = True
        divFechaDiasHospitalizacion.Visible = True

        MostrarMedico()
        If Not ckAmbulatoria.Checked Then
            divFechaDiasAmbulatorio.Visible = False
        End If
    End Sub
    Private Sub LimpiarDatosPSS()
        lblPSS.Text = String.Empty

        txtPSSNombre.Enabled = True
        txtPssFax.phoneNumber = String.Empty
        txtPSSCorreo.Text = String.Empty
        txtPSSDireccion.Text = String.Empty
        txtPSSNumero.Text = String.Empty
        txtPssTelefono.phoneNumber = String.Empty
    End Sub
    Private Sub OcultarPSS()
        divPSS.Visible = False
        divDatosPSS.Visible = False

        txtPSSNombre.Enabled = True

        lblPSS.Text = String.Empty
        txtPSSNombre.Text = String.Empty
        LimpiarDatosPSS()

        divFechaDiasHospitalizacion.Visible = False
        txtDiscapFechaLicenciaHosp.Text = String.Empty
        txtDiscapDiasHosp.Text = String.Empty
    End Sub
    Protected Sub btnCancelarPSS_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarPSS.Click
        LimpiarDatosPSS()
        divDatosPSS.Visible = False

        txtPSSNombre.Text = String.Empty
        txtPSSNombre.Focus()

        MostrarOcultarDatosDiscapacidad()
    End Sub
    Private Function ValidarRegistroHospitalario() As Boolean

        'Validar datos Medico
        If Not ValidarRegistroAmbulatorio() Then
            Return False
        End If

        'Validacion datos obligatorios PSS
        If divDatosPSS.Visible Then
            If txtPSSDireccion.Text.Equals(String.Empty) Then
                lblMsg.Text = "La direccón de la PSS es obligatoria"
                Return False
            End If

            'Validacion telefono PSS
            If Not ValidarTelefonos(txtPssTelefono, lblMsg, "de la PSS") Then
                Return False
            End If
        End If

        'Validacion Fechas
        If ckHospitalaria.Checked Then
            If Not ValidarFechas(txtDiscapFechaLicenciaHosp, txtDiscapDiasHosp.Text, "hospitalaria") Then
                Return False
            End If
        End If

        lblMsg.Text = String.Empty
        Return True

    End Function
#End Region

#Region "Discapacidad"
    Private Sub MostrarOcultarDatosDiscapacidad()

        If ((ckAmbulatoria.Checked) And (Not ckHospitalaria.Checked) And (divDatosMedico.Visible)) _
            Or ((Not ckAmbulatoria.Checked) And (ckHospitalaria.Checked) And (divDatosPSS.Visible) And (divDatosMedico.Visible)) _
            Or ((ckAmbulatoria.Checked) And (ckHospitalaria.Checked) And (divDatosMedico.Visible) And (divDatosPSS.Visible)) Then

            divDiscapacidad.Visible = True
        Else
            divDiscapacidad.Visible = False
            LimpiarDatosDiscapacidad()
        End If

    End Sub
    Private Sub LimpiarDatosDiscapacidad()
        lblMsg.Text = String.Empty
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
    End Sub
    Private Function ValidarRegistroDiscapacidad() As Boolean

        'Validar que no falte el tipo de discapacidad
        If (Not rdAccidente.Checked) And (Not rdEmbarazo.Checked) And (Not rdEnfermedadComun.Checked) Then
            lblMsg.Text = "Debe seleccionar el tipo de Discapacidad"
            Return False
        End If

        'Validar codigo CIE-10 si fue suplido
        If Not txtDiscapCIE10.Text.Equals(String.Empty) Then
            Try
                Dim isCIE10 As Boolean = ExisteCodigoCie10(txtDiscapCIE10.Text)
                If Not isCIE10 Then
                    lblMsg.Text = "El código CIE-10 suplido no es válido"
                    Return False
                End If
            Catch ex As Exception
                lblMsg.Text = "El código CIE-10 suplido no es válido"
                Return False
            End Try
        End If

        'Validar fecha diagnostico futura
        If txtDiscapFechaDiagnostico.Text > Now Then
            lblMsg.Text = "La fecha de Diagnóstico no debe ser futura"
            Return False
        End If

        lblMsg.Text = String.Empty
        Return True

    End Function
    Protected Sub btnCancelarCompletado_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarCompletado.Click
        Limpiar()
    End Sub
#End Region

#Region "General"
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click

        LimpiarValoresConfirmacion()

        'Validacion telefono Datos Generales
        If Not ValidarTelefonos(txtTrabajadorTelefono, lblMsg, "del trabajador") Then
            Exit Sub
        End If

        'Validar datos modalidad Ambulatoria
        If Not ValidarRegistroAmbulatorio() Then
            Exit Sub
        End If

        'Validar datos modalidad Hospitalaria
        If Not ValidarRegistroHospitalario() Then
            Exit Sub
        End If

        'Validar datos Discapacidad
        If Not ValidarRegistroDiscapacidad() Then
            Exit Sub
        End If

        RegistrarDatosConfirmacion()

    End Sub
    Private Sub LimpiarValoresConfirmacion()

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

        lblMsg.Text = String.Empty

    End Sub
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

            divConfPSS.Visible = True
            lblConfPSSCorreo.Text = txtPSSCorreo.Text
            lblConfPSSDireccion.Text = txtPSSDireccion.Text
            lblConfPSSFax.Text = txtPssFax.phoneNumber
            lblConfPSSNombre.Text = ProperCase(txtPSSNombre.Text)
            lblConfPSSNumero.Text = txtPSSNumero.Text
            lblConfPSSTelefono.Text = txtPssTelefono.phoneNumber
        End If
        If divDatosMedico.Visible Then
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

        lblMsg.Text = String.Empty
        divCompletar.Visible = False
        divDatosIniciales.Visible = False
        divConfirmar.Visible = True

    End Sub
    Private Function ValidarFechas(ByVal fechaTextBox As TextBox, ByVal dias As String, ByVal modalidad As String) As Boolean

        If Not DateTimeError(modalidad, fechaTextBox) Then
            Return False
        End If

        If ckAmbulatoria.Checked And ckHospitalaria.Checked Then
            If Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) = Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                lblMsg.Text = "La fecha de inicio de licencias no deben coincidir"
                Return False
            End If
            If Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) < Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                If DateAdd(DateInterval.Day, CInt(txtDiscapDiasAmb.Text), Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text)) > Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) Then
                    lblMsg.Text = "La fecha de inicio de licencias no deben coincidir"
                    Return False
                End If
            End If
            If Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text) < Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) Then
                If DateAdd(DateInterval.Day, CInt(txtDiscapDiasHosp.Text), Convert.ToDateTime(txtDiscapFechaLicenciaHosp.Text)) > Convert.ToDateTime(txtDiscapFechaLicenciaAmb.Text) Then
                    lblMsg.Text = "La fecha de inicio de licencias no deben coincidir"
                    lblMsg.Focus()
                    Return False
                End If
            End If
        End If

        If Convert.ToDateTime(txtDiscapFechaDiagnostico.Text) > Convert.ToDateTime(fechaTextBox.Text) Then
            lblMsg.Text = "La fecha de inicio de licencia " & modalidad & " debe ser mayor que la fecha de Diagnóstico"
            Return False
        End If
        If dias <= 0 Then
            lblMsg.Text = "Cantidad de días calendario " & modalidad & " inválida"
            Return False
        End If

        lblMsg.Text = String.Empty
        Return True

    End Function
    Private Function DateTimeError(ByVal fecha As String, ByVal fechaControl As TextBox) As Boolean

        Dim dtm As System.DateTime
        If Not System.DateTime.TryParse(fechaControl.Text, dtm) Then

            Me.lblCompletar.Text = "Error en la fecha de licencia " & fecha
            Return False

        End If
        Return True

    End Function
#End Region

#Region "Confirmar"
    Protected Sub btnContinuar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContinuar.Click

        divConfirmar.Visible = False
        divImagen.Visible = True

    End Sub
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click

        LimpiarValoresConfirmacion()
        divCompletar.Visible = True
        divDatosIniciales.Visible = True
        divConfirmar.Visible = False

    End Sub
#End Region

#Region "Imagen"
#Region "variables"
    Protected imgStream As System.IO.Stream
    Protected imgLength As Integer
    Private height As Integer
    Private width As Integer
    Private thumbnail As Boolean
    Dim ImagenMod() As Byte
    Dim imagName As String
#End Region
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
                        RehacerImagen()
                    Else
                        Dim imageContent(imgLength) As Byte
                        imgStream.Read(imageContent, 0, imgLength)
                        ImagenMod = imageContent
                    End If

                    Return True
                Else
                    Dim imageContent(imgLength) As Byte
                    imgStream.Read(imageContent, 0, imgLength)
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
    Protected Sub btnCancelarConfirmacion_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarConfirmacion.Click
        divImagen.Visible = False
        divConfirmar.Visible = True
        lblTerminar.Text = True
    End Sub
    Protected Sub btnConfirmar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConfirmar.Click

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
        If Not lblConfDiscapDiasAmb.Text.Equals(String.Empty) Then
            diasAmb = Convert.ToInt32(lblConfDiscapDiasAmb.Text)
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
#End Region

#Region "AplicarNovedades"
    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click

        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        If ret.Equals("Cambio Realizado") Then
            Limpiar()
            Response.Redirect("NovedadesAplicadas.aspx?msg=Novedad aplicada satisfactoriamente.")
        Else
            lblTerminar.Text = ret
        End If

    End Sub
#End Region

#End Region



End Class
