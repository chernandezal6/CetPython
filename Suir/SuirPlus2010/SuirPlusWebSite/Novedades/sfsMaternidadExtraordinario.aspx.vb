Imports System.Data
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Utilitarios.TSS
Imports SuirPlus.Utilitarios.Utils
Imports System.Collections.Generic
Imports SuirPlus.Exepciones
Imports SuirPlus.Empresas
Imports SuirPlus.FrameWork
Imports SuirPlus.Bancos.EntidadRecaudadora
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsMaternidadExtraordinario
    Inherits BasePage
    Protected empleado As Trabajador
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            Try
                'Poblar los campos para ver el "Detalle de consulta de subsidios extraordinario"
                If Not (String.IsNullOrEmpty(Request.QueryString("NSSconsulta"))) And Not (String.IsNullOrEmpty(Request.QueryString("RNC"))) Then
                    txtCedulaNSS.Text = Request.QueryString("NSSconsulta").ToString()
                    btnConsultar_Click(sender, e)
                    fiedlsetDatos.Visible = False
                    btnVolver.Visible = True
                    txtRNCLicencia.Text = Request.QueryString("RNC").ToString()
                    btnLicencia_Click(sender, e)
                    btnVolver.Visible = True
                Else
                    'Cargar dropdown de entidades recaudadoras
                    Dim entidadesRecaudadoras As New DataTable
                    entidadesRecaudadoras = getEntidadesParaSFS()
                    ddlEntidadRecaudadora.DataSource = entidadesRecaudadoras
                    ddlEntidadRecaudadora.DataTextField = "ENTIDAD_RECAUDADORA_DES"
                    ddlEntidadRecaudadora.DataValueField = "ID_ENTIDAD_RECAUDADORA"
                    ddlEntidadRecaudadora.DataBind()
                    ddlEntidadRecaudadora.Items.Insert(0, New ListItem("Seleccione", "0"))

                    'Si la variable de querystring maternidad tiene datos significa que la pagina se esta cargando
                    'devolviendose de la pagina de Confirmacion, y debe cargar los datos que tenia previamente
                    If Not (String.IsNullOrEmpty(Request.QueryString("confirmacion"))) Then
                        If Not Session("Maternidad") Is Nothing Then

                            Dim maternidad As ConfirmarMaternidad = CType(Session("Maternidad"), ConfirmarMaternidad)

                            If maternidad.DatosMaternidad.Equals("Completo") Then

                                txtCedulaNSS.Text = maternidad.CedulaMadre
                                txtCeduNssTutor.Text = maternidad.NoDocumentoTutor
                                ucInfoEmpleado1.NombreEmpleado = maternidad.NombreMadre
                                ucInfoEmpleado1.NSS = maternidad.NSSMadre
                                ucInfoEmpleado1.Cedula = maternidad.CedulaMadre.Replace("-", "")
                                ucInfoEmpleado1.FechaNacimiento = String.Format("{0:d}", maternidad.FechaNacimientoMadre)
                                ucInfoEmpleado1.Sexo = maternidad.SexoMare
                                ucInfoEmpleado1.SexoEmpleado = maternidad.SexoEmpleadoMadre
                                btnTutor_Click(sender, e)
                                lblCelular.Text = maternidad.Celular
                                lblEmail.Text = maternidad.Email
                                lblEmprezaReporteEmbarazo.Text = ProperCase(IIf(maternidad.EmprezaReporteEmbarazo Is Nothing, String.Empty, maternidad.EmprezaReporteEmbarazo))
                                txtFeDiagno.Text = maternidad.FechaDiagnostico
                                txtFeParto.Text = maternidad.FechaEstimadaParto
                                txtFeLi.Text = maternidad.FechaLicencia
                                ddlEntidadRecaudadora.Text = maternidad.EntidadRecaudadora

                                If maternidad.EntidadRecaudadora.Equals("1") Then
                                    lblPrefijo.Text = Left(maternidad.NoCuenta, 7)
                                    lblPrefijo0.Text = Left(maternidad.NoCuenta, 7)
                                    txtNumeroCuenta.Text = maternidad.NoCuenta.Replace(Left(maternidad.NoCuenta, 7), "")
                                    txtNumeroCuenta0.Text = txtNumeroCuenta.Text
                                Else
                                    txtNumeroCuenta.Text = maternidad.NoCuenta
                                    txtNumeroCuenta0.Text = maternidad.NoCuenta
                                End If

                                txtRNCLicencia.Text = maternidad.RNCLicencia
                                txtTelefono.Text = maternidad.Telefono
                                txtCelular.Text = maternidad.Celular
                                txtEmail.Text = maternidad.Email
                                ddTipo_Cuentas.Text = maternidad.TipoCuenta
                                ddlDestinatario.Text = maternidad.Destinatario
                                ViewState("DatosMaternidad") = maternidad.DatosMaternidad
                                tblNuevaLicencia.Visible = True
                                Me.divConsulta.Visible = True
                                Me.fiedlsetDatosNuevosMadre.Visible = True
                                Me.tblTutor.Visible = True
                                Me.divInfoTutor.Visible = True
                                Me.tblNuevaLicencia.Visible = True
                                Me.divDatosLicencia.Visible = True
                            Else
                                'Si la variable de querystring maternidad no tiene datos significa que la pagina NO se esta cargando
                                'devolviendose de la pagina de Confirmacion, sino que se esta cargando por primera vez
                                txtCedulaNSS.Text = maternidad.CedulaMadre
                                ucInfoEmpleado1.NombreEmpleado = maternidad.NombreMadre
                                ucInfoEmpleado1.NSS = maternidad.NSSMadre
                                ucInfoEmpleado1.Cedula = maternidad.CedulaMadre.Replace("-", "")
                                ucInfoEmpleado1.FechaNacimiento = maternidad.FechaNacimientoMadre
                                ucInfoEmpleado1.Sexo = maternidad.SexoMare
                                ucInfoEmpleado1.SexoEmpleado = maternidad.SexoEmpleadoMadre
                                lblApellidoTutor.Text = ProperCase(maternidad.ApellidoTutor)
                                lblCelular.Text = maternidad.Celular
                                lblEmail.Text = maternidad.Email
                                lblEmprezaReporteEmbarazo.Text = ProperCase(IIf(maternidad.EmprezaReporteEmbarazo Is Nothing, String.Empty, maternidad.EmprezaReporteEmbarazo))
                                lblFechaDiagnostico.Text = maternidad.FechaDiagnostico
                                lblFechaEstimadaParto.Text = maternidad.FechaEstimadaParto
                                txtFeLi.Text = maternidad.FechaLicencia
                                ddlEntidadRecaudadora.Text = maternidad.EntidadRecaudadora
                                lblNoDocumentoTutor.Text = maternidad.NoDocumentoTutor
                                lblNombreTutor.Text = ProperCase(maternidad.NombreTutor)

                                If maternidad.EntidadRecaudadora.Equals("1") Then
                                    lblPrefijo.Text = Left(maternidad.NoCuenta, 7)
                                    lblPrefijo0.Text = Left(maternidad.NoCuenta, 7)
                                    txtNumeroCuenta.Text = maternidad.NoCuenta.Replace(Left(maternidad.NoCuenta, 7), "")
                                    txtNumeroCuenta0.Text = txtNumeroCuenta.Text
                                Else
                                    txtNumeroCuenta.Text = maternidad.NoCuenta
                                    txtNumeroCuenta0.Text = maternidad.NoCuenta
                                End If

                                lblRNC.Text = maternidad.RNC
                                txtRNCLicencia.Text = maternidad.RNCLicencia
                                lblTelefono.Text = maternidad.Telefono
                                ddTipo_Cuentas.Text = maternidad.TipoCuenta
                                ddlDestinatario.Text = maternidad.Destinatario
                                ViewState("DatosMaternidad") = maternidad.DatosMaternidad
                                tblNuevaLicencia.Visible = True
                                Me.divConsulta.Visible = True
                                Me.fiedlsetDatosMadre.Visible = True
                                Me.fiedlsetDatos.Visible = True
                                Me.divInfoTutorActivo.Visible = True
                                Me.tblNuevaLicencia.Visible = True
                                Me.divDatosLicencia.Visible = True
                            End If
                            Session("Maternidad") = Nothing
                        End If
                    End If
                    End If
            Catch ex As Exception
                Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click

        If ValidarTipoCuenta() Then

            'Establecer valores a pasar por sesion a la pagina de confirmacion
            Dim maternidad As New ConfirmarMaternidad
            maternidad.NombreMadre = ucInfoEmpleado1.NombreEmpleado
            maternidad.NSSMadre = ucInfoEmpleado1.NSS
            maternidad.CedulaMadre = ucInfoEmpleado1.Cedula.Replace("-", "")
            maternidad.SexoMare = ucInfoEmpleado1.Sexo
            maternidad.FechaNacimientoMadre = ucInfoEmpleado1.FechaNacimiento
            maternidad.SexoEmpleadoMadre = "Afiliada"
            maternidad.Celular = IIf(Me.lblCelular.Text.Equals(String.Empty), txtCelular.Text, lblCelular.Text)
            maternidad.Email = IIf(Me.lblEmail.Text.Equals(String.Empty), txtEmail.Text, Me.lblEmail.Text)
            maternidad.FechaDiagnostico = IIf(Me.lblFechaDiagnostico.Text.Equals(String.Empty), txtFeDiagno.Text, Me.lblFechaDiagnostico.Text)
            maternidad.FechaEstimadaParto = IIf(Me.lblFechaEstimadaParto.Text.Equals(String.Empty), txtFeParto.Text, Me.lblFechaEstimadaParto.Text)
            maternidad.Telefono = IIf(Me.lblTelefono.Text.Equals(String.Empty), txtTelefono.Text, Me.lblTelefono.Text)
            maternidad.RNC = IIf(Me.lblRNC.Text.Equals(String.Empty), txtRNCLicencia.Text, Me.lblRNC.Text)
            maternidad.ApellidoTutor = lblApellidoTutor.Text
            maternidad.NombreTutor = IIf(Me.lblNombreTutor.Text.Equals(String.Empty), UcInfoEmpleado2.NombreEmpleado, Me.lblNombreTutor.Text)
            maternidad.NoDocumentoTutor = IIf(Me.lblNoDocumentoTutor.Text.Equals(String.Empty), txtCeduNssTutor.Text, Me.lblNoDocumentoTutor.Text)
            maternidad.RNCLicencia = txtRNCLicencia.Text
            maternidad.FechaLicencia = txtFeLi.Text
            maternidad.Destinatario = ddlDestinatario.Text
            maternidad.DisplayDestinatario = ddlDestinatario.SelectedItem.Text
            maternidad.EntidadRecaudadora = ddlEntidadRecaudadora.Text
            maternidad.DisplayEntidadRecaudadora = ddlEntidadRecaudadora.SelectedItem.Text
            maternidad.NoCuenta = lblPrefijo0.Text & txtNumeroCuenta0.Text
            maternidad.TipoCuenta = ddTipo_Cuentas.Text
            maternidad.DisplayTipoCuenta = ddTipo_Cuentas.SelectedItem.Text
            maternidad.DatosMaternidad = ViewState("DatosMaternidad").ToString()
            maternidad.Usuario = UsrUserName

            If Not txtRNCLicencia.Text.Equals(String.Empty) Then
                Dim empleadorLicencia As New Empleador(Convert.ToInt32(getRegistroPatronal(txtRNCLicencia.Text)))
                maternidad.EmpresaReportoLicencia = empleadorLicencia.RazonSocial
            End If

            If Not lblRNC.Text.Equals(String.Empty) Then
                Dim empleadorEmbarazo As New Empleador(Convert.ToInt32(getRegistroPatronal(Me.lblRNC.Text)))
                maternidad.EmprezaReporteEmbarazo = empleadorEmbarazo.RazonSocial
            End If

            Session("Maternidad") = maternidad
            Response.Redirect("~/Novedades/sfsConfirmacionMaternidad.aspx?")

        End If

    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        txtRNCLicencia.Text = String.Empty
        txtCelular.Text = String.Empty
        txtTelefono.Text = String.Empty
        txtEmail.Text = String.Empty
        txtFeLi.Text = String.Empty
        txtNumeroCuenta.Text = String.Empty
        txtNumeroCuenta0.Text = String.Empty
        btnCancel_Click(sender, e)
        btnVolver.Visible = False
        tblNuevaLicencia.Visible = False

        Try

            Dim mensaje As String = ValidarRegistroEmbarazo(txtCedulaNSS.Text, 0)

            'Como se esta usando la misma prevalidacion para un registro de embarazo normal, 
            'se verifica que si la prevalidacion devuelve este error, entonces para nuestro
            'caso esta todo bien, pues este error no aplica para subsidios extraordinarios
            If mensaje.Equals("Trabajador no esta activo para esta nómina.") Or mensaje.Equals("Las novedades de esta afiliada estan siendo manejadas por la Sisalril") Then


                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                End If

                lblMsg.Text = String.Empty

                Me.divConsulta.Visible = True
                Me.txtCedulaNSS.ReadOnly = True

                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Afiliada"

                MostrarDatos()

            Else
                lblMsg.Text = mensaje
                Me.divConsulta.Visible = False
                Me.fiedlsetDatosNuevosMadre.Visible = False
                Me.fiedlsetDatos.Visible = False
                Me.tblTutor.Visible = False
                Me.divInfoTutor.Visible = False
                Me.divDatosLicencia.Visible = False
            End If

        Catch ex As Exception

            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatosNuevosMadre.Visible = False
            Me.fiedlsetDatos.Visible = False
            Me.tblTutor.Visible = False
            Me.divInfoTutor.Visible = False
            Me.divLicencia.Visible = False
            Me.divDatosLicencia.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub
    Private Sub MostrarDatos()

        Dim madre As Maternidad = Nothing
        Try
            If Me.txtCedulaNSS.Text.Length < 11 Then
                madre = New Maternidad(Convert.ToInt32(Me.txtCedulaNSS.Text))
            ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                madre = New Maternidad(Me.txtCedulaNSS.Text)
            End If

        Catch ex As Exception
            madre = Nothing
        End Try

        Cargar(madre)

    End Sub
    Private Sub Cargar(ByVal madre As Maternidad)
        'Si tiene una maternidad activa registrada, poblar campos con los detalles de la misma
        'para que luego se registre la licencia y completar el subsidio de maternidad extraordinario
        If Not madre Is Nothing Then

            If madre.Status.Equals("Activo") Then
                ViewState("DatosMaternidad") = "Licencia"

                If Not madre.EmpleadorRegistroEmbarazo.Equals(String.Empty) Then
                    Dim empleadorMadre As New Empleador(Convert.ToInt32(madre.EmpleadorRegistroEmbarazo))
                    Me.lblRNC.Text = empleadorMadre.RNCCedula
                    Me.lblEmprezaReporteEmbarazo.Text = ProperCase(empleadorMadre.RazonSocial)
                End If

                Me.lblCelular.Text = madre.Celular
                Me.lblEmail.Text = madre.Email
                Me.lblFechaDiagnostico.Text = madre.FechaDiagnostico
                Me.lblFechaEstimadaParto.Text = madre.FechaEstimadaParto
                Me.lblTelefono.Text = madre.Telefono
                fiedlsetDatosMadre.Visible = True
                fiedlsetDatosNuevosMadre.Visible = False
                divDatosLicencia.Visible = True
                divLicencia.Visible = False

                'Cargar datos del tutor
                CargarDetalleTutor()
            Else
                'Si no tiene maternidad activa, se va a a registrar el subsidio completo
                Completo()
            End If

        Else
            'Si ni siquiera tiene un registro de maternidad, se va a a registrar el subsidio completo
            Completo()
        End If
    End Sub
    Private Sub Completo()
        ViewState("DatosMaternidad") = "Completo"

        fiedlsetDatosMadre.Visible = False
        fiedlsetDatosNuevosMadre.Visible = True

        Me.txtFeDiagno.Text = String.Empty
        Me.txtFeParto.Text = String.Empty

        'Cargar datos tutor
        Me.tblTutor.Visible = True
        Me.tutor.Visible = True

        'Cargar datos licencia
        divDatosLicencia.Visible = True
    End Sub
    Private Sub CargarDetalleTutor()
        Dim madre As Maternidad = Nothing
        Try
            If Me.txtCedulaNSS.Text.Length < 11 Then
                madre = New Maternidad(Convert.ToInt32(Me.txtCedulaNSS.Text))
            ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                madre = New Maternidad(Me.txtCedulaNSS.Text)
            End If
        Catch ex As Exception
            madre = Nothing
        End Try
        Try
            If Not madre Is Nothing Then
                If Not madre.TutorActivo.NroDocumento.Equals(String.Empty) Then
                    Me.lblApellidoTutor.Text = ProperCase(madre.TutorActivo.PrimerApellido & " " & madre.TutorActivo.SegundoApellido)
                    Me.lblNombreTutor.Text = ProperCase(madre.TutorActivo.Nombres)
                    Me.lblNoDocumentoTutor.Text = ProperCase(madre.TutorActivo.NroDocumento)
                    Me.divInfoTutorActivo.Visible = True
                    Me.fiedlsetDatos.Visible = True
                Else
                    Me.divInfoTutorActivo.Visible = False
                End If
            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.fiedlsetDatos.Visible = False
        End Try

    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()

    End Sub
    Private Sub clearControls()
        Me.divConsulta.Visible = False
        Me.fiedlsetDatosMadre.Visible = False
        Me.fiedlsetDatosNuevosMadre.Visible = False
        Me.divInfoTutor.Visible = False
        divInfoTutorActivo.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.tblTutor.Visible = False
        Me.divLicencia.Visible = False
        Me.divDatosLicencia.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtCedulaNSS.Focus()
        lblMsg.Text = String.Empty
    End Sub

    Protected Sub btnTutor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTutor.Click

        lblMsg.Text = String.Empty
        Try

            Dim mensaje As String = ValidarRegistroTutor(txtCedulaNSS.Text)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty
                If Me.txtCeduNssTutor.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCeduNssTutor.Text))
                ElseIf Me.txtCeduNssTutor.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCeduNssTutor.Text)
                End If

                Me.txtCeduNssTutor.ReadOnly = True
                Me.fiedlsetDatos.Visible = Not (divLicencia.Visible)
                Me.divInfoTutor.Visible = True
                Me.lblErrorTutor.Visible = False
                UcInfoEmpleado2.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcInfoEmpleado2.NSS = empleado.NSS.ToString
                UcInfoEmpleado2.Cedula = empleado.Documento
                UcInfoEmpleado2.Sexo = empleado.Sexo
                UcInfoEmpleado2.FechaNacimiento = empleado.FechaNacimiento
                UcInfoEmpleado2.SexoEmpleado = "Nombre Tutor(a)"

            Else
                lblMsg.Text = mensaje
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblErrorTutor.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

    End Sub

    Protected Sub ddlEntidadRecaudadora_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlEntidadRecaudadora.SelectedIndexChanged
        ValidarCuentaBanco()
    End Sub
    Private Sub ValidarCuentaBanco()
        lblPrefijo.Text = String.Empty
        lblPrefijo0.Text = String.Empty
        'Banco del Reservas
        If ddlEntidadRecaudadora.SelectedValue = 1 Then
            If ddTipo_Cuentas.SelectedValue = 1 Then
                lblPrefijo.Text = "100-01-"
                lblPrefijo0.Text = "100-01-"
            Else
                lblPrefijo.Text = "200-01-"
                lblPrefijo0.Text = "200-01-"
            End If
            regexNumber.ValidationExpression = "[0-9]{10}"
            regexNumber.ErrorMessage = "Formato incorrecto, debe contener 10 caracteres numericos!!"
            'Banco CITIBank or Banco del Progreso or Banco BDI
        ElseIf ddlEntidadRecaudadora.SelectedValue = 40 Or ddlEntidadRecaudadora.SelectedValue = 11 Or _
        ddlEntidadRecaudadora.SelectedValue = 44 Then
            regexNumber.ValidationExpression = "[0-9]{10}"
            regexNumber.ErrorMessage = "Formato incorrecto, debe contener 10 caracteres numericos!!"
            'Banco BHD
        ElseIf ddlEntidadRecaudadora.SelectedValue = 23 Then
            regexNumber.ValidationExpression = "[0-9]{11}"
            regexNumber.ErrorMessage = "Formato incorrecto, debe contener 11 caracteres numericos!!"
            'Banco Santa Cruz
        ElseIf ddlEntidadRecaudadora.SelectedValue = 34 Then
            regexNumber.ValidationExpression = "[0-9]{14}"
            regexNumber.ErrorMessage = "Formato incorrecto, debe contener 14 caracteres numericos!!"
        End If
    End Sub
    Private Function ValidarTipoCuenta() As Boolean
        lblMensaje.Text = String.Empty

        'Banco CITIBank
        If ddlEntidadRecaudadora.SelectedValue = 40 Then
            If ddTipo_Cuentas.SelectedValue = 2 Then
                If Not txtNumeroCuenta0.Text.Substring(0, 1) = 5 Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen el dígito '5' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(0, 1) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(0, 1) & "</span>" & txtNumeroCuenta0.Text.Substring(1, 9) & "</div>"
                    Return False
                End If
            End If

            'Banco del Progreso
        ElseIf ddlEntidadRecaudadora.SelectedValue = 11 Then
            If ddTipo_Cuentas.SelectedValue = 1 Then
                If Not txtNumeroCuenta0.Text.Substring(2, 1) = 1 Then
                    If Not txtNumeroCuenta0.Text.Substring(2, 1) = 2 Then
                        lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen  el dígito  '1' o '2' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(2, 1) & "'"
                        lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 2) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(2, 1) & "</span>" & txtNumeroCuenta0.Text.Substring(3, 7) & "</div>"
                        Return False
                    End If
                End If
            Else
                If Not txtNumeroCuenta0.Text.Substring(2, 1) = 3 Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen el dígito '3' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(2, 1) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 2) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(2, 1) & "</span>" & txtNumeroCuenta0.Text.Substring(3, 7) & "</div>"
                    Return False
                End If
            End If

            'Banco BHD
        ElseIf ddlEntidadRecaudadora.SelectedValue = 23 Then
            If ddTipo_Cuentas.SelectedValue = 1 Then
                If Not txtNumeroCuenta0.Text.Substring(7, 3) = "001" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '001' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(7, 3) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 6) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(7, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(10, 1) & "</div>"
                    Return False
                End If
            Else
                If Not txtNumeroCuenta0.Text.Substring(7, 3) = "004" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos  '004' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(7, 3) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 6) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(7, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(10, 1) & "</div>"
                    Return False
                End If
            End If

            'Banco Santa Cruz
        ElseIf ddlEntidadRecaudadora.SelectedValue = 34 Then
            If ddTipo_Cuentas.SelectedValue = 1 Then
                If Not txtNumeroCuenta0.Text.Substring(4, 3) = "101" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '101' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(4, 3) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 4) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(4, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(7, 7) & "</div>"
                    Return False
                End If
            Else
                If Not txtNumeroCuenta0.Text.Substring(4, 3) = "200" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos  '200' en la posición resaltada, en lugar de " & txtNumeroCuenta0.Text.Substring(4, 3)
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= " & txtNumeroCuenta0.Text.Substring(0, 4) & "<span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(4, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(7, 7) & "</div>"
                    Return False
                End If
            End If

            'Banco BDI
        ElseIf ddlEntidadRecaudadora.SelectedValue = 44 Then
            If ddTipo_Cuentas.SelectedValue = 1 Then
                If Not txtNumeroCuenta0.Text.Substring(0, 3) = "410" And Not txtNumeroCuenta0.Text.Substring(0, 3) = "404" _
                And Not txtNumeroCuenta0.Text.Substring(0, 3) = "406" And Not txtNumeroCuenta0.Text.Substring(0, 3) = "409" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas corriente contienen los dígitos '410' o '404' o '406' o '409' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(0, 3) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(0, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(3, 7) & "</div>"
                    Return False
                End If
            Else
                If Not txtNumeroCuenta0.Text.Substring(0, 3) = "401" And Not txtNumeroCuenta0.Text.Substring(0, 3) = "407" Then
                    lblMensaje.Text = "Formato incorrecto, Las cuentas de ahorro contienen los dígitos '401' o '407' en la posición resaltada, en lugar de '" & txtNumeroCuenta0.Text.Substring(0, 3) & "'"
                    lblMensaje.Text += "<br><div style='text-align:center'>No. Cuenta= <span style='background-color:Yellow;color:Black'>" & txtNumeroCuenta0.Text.Substring(0, 3) & "</span>" & txtNumeroCuenta0.Text.Substring(3, 7) & "</div>"
                    Return False
                End If
            End If

            'Banco Leon
        ElseIf ddlEntidadRecaudadora.SelectedValue = 37 Then
            If Me.txtNumeroCuenta0.Text.Length < 7 Then
                ddTipo_Cuentas.SelectedValue = 1
            Else
                ddTipo_Cuentas.SelectedValue = 2
            End If
        End If

        Return True

    End Function

    Protected Sub ddTipo_Cuentas_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddTipo_Cuentas.SelectedIndexChanged
        ValidarCuentaBanco()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.txtCeduNssTutor.ReadOnly = False
        Me.divInfoTutor.Visible = False
        Me.txtCeduNssTutor.Text = String.Empty
        Me.txtCeduNssTutor.Focus()
    End Sub

    Protected Sub btnCancelarGeneral_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarGeneral.Click
        clearControls()
    End Sub

    Protected Sub btnLicencia_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLicencia.Click
        txtFeLi.Text = String.Empty
        ddlDestinatario.Text = "M"
        ddlEntidadRecaudadora.Text = "0"
        txtNumeroCuenta.Text = String.Empty
        txtNumeroCuenta0.Text = String.Empty
        ddTipo_Cuentas.Text = "2"
        Dim madre As Maternidad = Nothing
        Try
            If Me.txtCedulaNSS.Text.Length < 11 Then
                madre = New Maternidad(Convert.ToInt32(Me.txtCedulaNSS.Text))
            ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                madre = New Maternidad(Me.txtCedulaNSS.Text)
            End If
        Catch ex As Exception
            madre = Nothing
        End Try

        If Not madre Is Nothing Then
            'Obtener la licencia reportada por esta empresa
            Dim empleadorMadre As New Empleador(Convert.ToInt32(getRegistroPatronal(txtRNCLicencia.Text.Trim())))
            gvLicencias.DataSource = getLicenciaActivaEmpleador(madre.Cedula, empleadorMadre.RazonSocial)
            gvLicencias.DataBind()
        Else
            gvLicencias.DataSource = Nothing
            gvLicencias.DataBind()
        End If

        'Cargar datos de la licencia y terminar el proceso
        'lo cual significa que ya se registro completo el subsidio previamente
        If gvLicencias.Rows.Count > 0 Then
            divLicencia.Visible = True
            tblNuevaLicencia.Visible = False
            fiedlsetDatos.Visible = False
            divDatosLicencia.Visible = False
        Else
            divDatosLicencia.Visible = True
            divLicencia.Visible = False
            tblNuevaLicencia.Visible = True
            fiedlsetDatos.Visible = True
        End If

    End Sub

    Protected Sub btnCancelLicencia_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelLicencia.Click
        tblNuevaLicencia.Visible = False
        divLicencia.Visible = False
        Me.txtRNCLicencia.Text = String.Empty
        gvLicencias.DataSource = Nothing
        gvLicencias.DataBind()
    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Try
            Response.Redirect("~/Novedades/sfsConsnovedadesExt.aspx?desde=" & Request.QueryString("desde").ToString & "&hasta=" & Request.QueryString("hasta").ToString & "&tipo=" & Request.QueryString("tipo").ToString & "&NSSconsulta=" & Request.QueryString("NSSconsulta").ToString & "&RNC=" & Request.QueryString("RNC").ToString & "&RegistroPatronal=" & Request.QueryString("RegistroPatronal").ToString)
        Catch 
        End Try

    End Sub
End Class
