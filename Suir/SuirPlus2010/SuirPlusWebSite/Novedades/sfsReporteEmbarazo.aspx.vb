
Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsReporteEmbarazo
    Inherits BasePage

    Protected empleado As Trabajador
    Protected cuentaBancaria As SuirPlus.Empresas.CuentaBancaria

    Private Property idCiudadano() As String
        Get
            Return CType(viewstate("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            viewstate("idCiudadano") = Value
        End Set
    End Property
    Private Property idTutor() As String
        Get
            Return CType(ViewState("idTutor"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idTutor") = Value
        End Set
    End Property

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtCeduNssTutor.ReadOnly = False
        Me.txtCeduNssTutor.Text = String.Empty
        txtCelular.Text = String.Empty
        txtTelefono.Text = String.Empty
        txtEmail.Text = String.Empty
        Me.divInfoTutor.Visible = False
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False

        Try
            Dim mensaje As String = ValidarRegistroEmbarazo(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then

                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                End If

                lblMsg.Text = String.Empty

                Me.divConsulta.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.tblTutor.Visible = True
                Me.tutor.Visible = True
                Me.txtFeDiagno.Text = String.Empty
                Me.txtFeParto.Text = String.Empty

                Me.txtCedulaNSS.ReadOnly = True

                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Empleada"

                ViewState("documento") = empleado.Documento

            Else
                lblMsg.Text = mensaje
                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False
                Me.fiedlsetDatosTutor.Visible = False
                Me.tblTutor.Visible = False
                Me.errorSta.Visible = False
                Me.errorSexo.Visible = False
            End If

        Catch ex As Exception

            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            Me.fiedlsetDatosTutor.Visible = False
            Me.tblTutor.Visible = False
            Me.errorSta.Visible = False
            Me.errorSexo.Visible = False
            Me.errorG.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Private Sub bindNovedades()
        ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fiedlsetDatos1.Visible = True
        End If
    End Sub

    Private Sub clearControls()
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.mensageFecha.Visible = False
        Me.mensajeFecha1.Visible = False
        Me.txtFeDiagno.Text = String.Empty
        Me.txtFeParto.Text = String.Empty
        Me.fiedlsetDatos.Visible = False
        Me.errorG.Visible = False
        Me.txtCedulaNSS.ReadOnly = False
    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()
        Me.divInfoTutor.Visible = False
        Me.txtCeduNssTutor.Text = String.Empty
        Me.divInfoTutor.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.divConsulta.Visible = False
        Me.tblAfiliada.Visible = True
        Me.tblTutor.Visible = False
        Me.tutor.Visible = False
        Me.fiedlsetDatosTutor.Visible = False

        Me.txtCedulaNSS.Focus()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsReporteEmbarazo.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        If Page.IsPostBack = False Then
            Me.bindNovedades()
        End If
        Me.txtCedulaNSS.Focus()

    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")

    End Sub

    Protected Sub btnTutor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTutor.Click
        Me.idTutor = Me.txtCeduNssTutor.Text
        lblMsg.Text = String.Empty
        Try

            Dim mensaje As String = ValidarRegistroTutor(txtCedulaNSS.Text)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty
                If idTutor.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(idTutor))
                ElseIf idTutor.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, idTutor)
                End If

                Me.txtCeduNssTutor.ReadOnly = True

                Me.divInfoTutor.Visible = True
                Me.fiedlsetDatosTutor.Visible = True
                Me.errorG.Visible = False
                Me.lblErrorTutor.Visible = False
                UcInfoEmpleado2.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcInfoEmpleado2.NSS = empleado.NSS.ToString
                UcInfoEmpleado2.Cedula = empleado.Documento
                UcInfoEmpleado2.Sexo = empleado.Sexo
                UcInfoEmpleado2.FechaNacimiento = empleado.FechaNacimiento
                UcInfoEmpleado2.SexoEmpleado = "Nombre Tutor(a)"

            Else
                lblMsg.Text = mensaje
                Me.fiedlsetDatosTutor.Visible = False

            End If

        Catch ex As Exception
            Me.lblErrorTutor.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

    End Sub
    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click
        lblMsg.Text = String.Empty
        ucGridNovPendientes1.Mensaje = String.Empty
        Me.mensajeFecha1.Visible = False
        Me.mensageFecha.Visible = False
        Me.errorG.Visible = False
        Dim documento As String = ViewState("documento").ToString()
        Dim m As String = String.Empty
      
        Try
        
            m = RegistroEmbarazo(documento, Me.UsrRegistroPatronal, Convert.ToDateTime(Me.txtFeDiagno.Text), Convert.ToDateTime(Me.txtFeParto.Text), idTutor, txtTelefono.Text, txtCelular.Text, txtEmail.Text, Me.UsrRNC & Me.UsrCedula)

            Select Case m
                Case "OK"
                    ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
                    If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                        Me.clearControls()
                        Me.divConsulta.Visible = False
                        Me.txtCedulaNSS.Text = String.Empty
                        Me.txtCedulaNSS.Focus()
                        Me.fiedlsetDatos1.Visible = True
                        Me.divInfoTutor.Visible = False
                        Me.tutor.Visible = False
                        Me.divConsulta.Visible = False
                        Me.tblTutor.Visible = False
                        Me.tblAfiliada.Visible = True
                        Me.fiedlsetDatosTutor.Visible = False
                    Else
                        ucGridNovPendientes1.Mensaje = "Ha ocurrido un error, por favor intente nuevamente."
                        ucGridNovPendientes1.Visible = True
                    End If

                Case Else
                    Me.errorG.Visible = True
                    Me.errorG.InnerText = m

            End Select
        Catch ex As Exception
            Me.errorG.Visible = True
            Me.errorG.InnerText = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelarGeneral.Click
        btnCancel_Click(Nothing, e)
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.mensageFecha.Visible = False
        Me.mensajeFecha1.Visible = False
        Me.errorG.Visible = False
        Me.txtCeduNssTutor.ReadOnly = False
        Me.fiedlsetDatosTutor.Visible = False

        Me.divInfoTutor.Visible = False
        Me.txtCeduNssTutor.Text = String.Empty
        Me.txtCeduNssTutor.Focus()
    End Sub

End Class
