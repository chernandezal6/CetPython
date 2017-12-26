Imports System.Data
Imports System.IO
Imports SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun
Imports SuirPlus.Empresas
Imports SuirPlus.Utilitarios.Utils
Partial Class Novedades_sfsEnfConvalidarPadecimiento
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
        lblTerminar.Text = String.Empty
        
        'Paneles
        Me.divInfoEmpleado.Visible = False
        Me.divDatosIniciales.Visible = False
        Me.divConfirmar.Visible = False
        Me.divPadecimientos.Visible = False
        
        'Trabajador
        Me.txtTrabajadorDireccion.Text = String.Empty
        Me.txtTrabajadorCelular.phoneNumber = String.Empty
        Me.txtTrabajadorCorreo.Text = String.Empty
        Me.txtTrabajadorTelefono.phoneNumber = String.Empty

        'Convalidacion
        gvPadecimientos.DataSource = Nothing
        gvPadecimientos.DataBind()

    End Sub
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
    Private Sub LoadPadecimientos(ByVal padecimientos As DataTable, ByVal direccion As String, ByVal celular As String, ByVal correo As String, ByVal telefono As String)

        gvPadecimientos.DataSource = padecimientos
        gvPadecimientos.DataBind()

        divPadecimientos.Visible = True

        'Mostrar datos en los controles de la info inicial
        Me.txtTrabajadorDireccion.Text = direccion
        Me.txtTrabajadorCelular.phoneNumber = IIf(celular.Equals("null"), String.Empty, celular)
        Me.txtTrabajadorCorreo.Text = IIf(correo.Equals("null"), String.Empty, correo)
        Me.txtTrabajadorTelefono.phoneNumber = telefono

        divDatosIniciales.Visible = True

        txtTrabajadorDireccion.Focus()
    End Sub
#End Region

#Region "Eventos General"
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
                Convalidacion(formPendiente)
            End If
        Else
            lblMsg.Text = validaciones
        End If

    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        txtCedula.Text = String.Empty
        Limpiar()
    End Sub
#End Region

#End Region

#Region "Convalidacion"
    Protected Sub gvSolicitudes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvPadecimientos.SelectedIndexChanged

        Dim padecimiento As DataTable
        ViewState("NumeroFormulario") = gvPadecimientos.SelectedRow.Cells(0).Text
        padecimiento = getPadecimiento(gvPadecimientos.SelectedRow.Cells(0).Text)

        If Not IsNothing(padecimiento) Then
            If padecimiento.Rows.Count > 0 Then
                RegistrarDatosConfirmacion(padecimiento)
            End If
        End If

        divPadecimientos.Visible = False

    End Sub
    Sub Convalidacion(ByVal formularioPendiente As DataTable)
        Dim direccion As String = String.Empty
        Dim telefono As String = String.Empty
        Dim celular As String = String.Empty
        Dim correo As String = String.Empty
        Try
            Dim padecimientos As New DataTable()
            padecimientos = PadecimientosRegistrados(ucInfoEmpleado1.NSS.Replace("-", ""), direccion, telefono, celular, correo)

            'Validacion2: Tiene una Solicitud completada?, si la tiene, se muestra el listado de padecimientos aprobados para convalidar, 
            'sino, se le informa al usuario que no tiene padecimientos para convalidar
            If Not IsNothing(padecimientos) Then

                If padecimientos.Rows.Count > 0 Then

                    LoadPadecimientos(padecimientos, direccion, celular, correo, telefono)

                Else
                    lblMsg.Text = "El(la) trabajador(a) no tiene padecimientos para convalidar"
                    Exit Sub
                End If
            Else
                lblMsg.Text = "El(la) trabajador(a) no tiene padecimientos para convalidar"
                Exit Sub
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

    End Sub
#End Region

#Region "Confirmar"
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
        lblTerminar.Text = String.Empty

    End Sub
    Private Sub RegistrarDatosConfirmacion(ByVal padecimiento As DataTable)

        lblConfTrabCelular.Text = txtTrabajadorCelular.phoneNumber
        lblConfTrabCorreo.Text = txtTrabajadorCorreo.Text
        lblConfTrabDireccion.Text = txtTrabajadorDireccion.Text
        lblConfTrabTelefono.Text = txtTrabajadorTelefono.phoneNumber
        lblConfNomina.Text = padecimiento(0)("Nomina").ToString
        ViewState("id_nomina") = padecimiento(0)("ID_Nomina").ToString
        ViewState("NroMedico") = padecimiento(0)("Id_Pss_Med").ToString
        If Not padecimiento(0)("Dias_Cal_Amb").ToString.Equals("0") Then
            divConfAmbulatoria.Visible = True
            lblConfDiscapLicenciaAmb.Text = padecimiento(0)("Fecha_Inicio_Amb").ToString
            lblConfDiscapDiasAmb.Text = padecimiento(0)("Dias_Cal_Amb").ToString
        End If
        If Not padecimiento(0)("Dias_Cal_Hos").ToString.Equals("0") Then
            divConfHospitalaria.Visible = True
            lblConfDiscapLicenciaHosp.Text = padecimiento(0)("Fecha_Inicio_Hos").ToString
            lblConfDiscapDiasHosp.Text = padecimiento(0)("Dias_Cal_Hos").ToString

            divConfPSS.Visible = True
            lblConfPSSCorreo.Text = padecimiento(0)("Nombre_Cen").ToString
            lblConfPSSDireccion.Text = padecimiento(0)("Direccion_Cen").ToString
            lblConfPSSFax.Text = padecimiento(0)("Fax_Cen").ToString
            lblConfPSSNombre.Text = ProperCase(padecimiento(0)("Nombre_Cen").ToString)
            lblConfPSSNumero.Text = padecimiento(0)("Id_Pss_Cen").ToString
            lblConfPSSTelefono.Text = padecimiento(0)("Telefono_Cen").ToString
        End If

        divConfMedico.Visible = True
        lblConfMedicoCedula.Text = padecimiento(0)("No_Documento_Med").ToString
        lblConfMedicoNombre.Text = ProperCase(padecimiento(0)("Nombre_Med").ToString)
        lblConfMedicoCelular.Text = padecimiento(0)("Celular_Med").ToString
        lblConfMedicoCorreo.Text = padecimiento(0)("Email_Med").ToString
        lblConfMedicoDireccion.Text = padecimiento(0)("Direccion_Med").ToString
        lblConfMedicoExequatur.Text = padecimiento(0)("Exequatur").ToString
        lblConfMedicoTelefono.Text = padecimiento(0)("Telefono_Med").ToString

        lblConfDiscapTipo.Text = padecimiento(0)("Tipo_Discapacidad").ToString
        lblConfDiscapCIE10.Text = padecimiento(0)("Codigocie10").ToString
        lblConfDiscapDiagnostico.Text = padecimiento(0)("Diagnostico").ToString
        lblConfDiscapSintomas.Text = padecimiento(0)("Signos_Sintomas").ToString
        lblConfDiscapProcedimientos.Text = padecimiento(0)("Procedimientos").ToString
        lblConfDiscapFechaDiagnostico.Text = padecimiento(0)("Fecha_Diagnostico").ToString

        lblMsg.Text = String.Empty
        divDatosIniciales.Visible = False
        divConfirmar.Visible = True

    End Sub
    Protected Sub btnContinuar_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        divConfirmar.Visible = False

    End Sub
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click

        LimpiarValoresConfirmacion()
        divDatosIniciales.Visible = True
        divPadecimientos.Visible = True
        divConfirmar.Visible = False

    End Sub
    Protected Sub btnProcesar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProcesar.Click

        Dim resp As String = String.Empty
        Dim id_movimiento As String = String.Empty
        Dim id_linea As String = String.Empty

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

        Try

            'Inserta el movimiento, muestra error validacion en caso de, o mensaje proceso exitoso
            resp = RegistroEnfComun(ViewState("NumeroFormulario").ToString, txtTrabajadorDireccion.Text, lblConfTrabTelefono.Text, _
                                                  lblConfTrabCorreo.Text, lblConfTrabCelular.Text, UsrRNC & UsrCedula, NroMedico, _
                                                  lblConfMedicoCedula.Text, lblConfMedicoNombre.Text, lblConfMedicoDireccion.Text, _
                                                  lblConfMedicoTelefono.Text, lblConfMedicoCelular.Text, lblConfMedicoCorreo.Text, _
                                                  NroPSS, lblConfPSSNombre.Text.ToUpper(), lblConfPSSDireccion.Text, _
                                                  lblConfPSSTelefono.Text, lblConfPSSFax.Text, lblConfPSSCorreo.Text, _
                                                  lblConfDiscapTipo.Text.Substring(0, 1), lblConfDiscapDiagnostico.Text, lblConfDiscapSintomas.Text, _
                                                  lblConfDiscapProcedimientos.Text, IIf(lblConfDiscapDiasAmb.Text.Equals(String.Empty), "N", "S"), fechaAmb, _
                                                  diasAmb, IIf(lblConfDiscapDiasHosp.Text.Equals(String.Empty), "N", "S"), fechaHosp, diasHosp, _
                                                  Convert.ToDateTime(lblConfDiscapFechaDiagnostico.Text), Convert.ToInt32(UsrRegistroPatronal), 0, _
                                                  UsrRNC & UsrCedula, lblConfDiscapCIE10.Text, lblConfMedicoExequatur.Text, CInt(ViewState("id_nomina").ToString), _
                                                  id_movimiento, id_linea)

        Catch ex As Exception
            lblTerminar.Text = ex.Message
        End Try


        If resp.Equals("OK") Then

            ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
            If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                divDatosIniciales.Visible = False
                divConfirmar.Visible = False
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


End Class
