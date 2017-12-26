Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Partial Class Novedades_sfsRegistroTutor
    Inherits BasePage
    Protected empleado As Trabajador
    Protected cuentaBancaria As SuirPlus.Empresas.CuentaBancaria

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsRegistroTutor.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        Me.txtCedulaNSS.Focus()
        Me.bindNovedades()
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        lblMsg2.Text = String.Empty
        Me.idCiudadano = Me.txtCedulaNSS.Text
        btnRegistrar.Enabled = True

        Try
            Dim mensaje As String = ValidarMadreRegistroTutor(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty

                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                End If

                ViewState("documento") = empleado.Documento

                Me.divConsulta.Visible = True
                Me.Table2.Visible = True
                Me.spanInfo.Visible = True
                Me.txtCeduNssTutor.Focus()

                Me.txtCedulaNSS.ReadOnly = True

                UcEmpleado.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcEmpleado.NSS = empleado.NSS.ToString
                UcEmpleado.Cedula = empleado.Documento
                UcEmpleado.Sexo = empleado.Sexo
                UcEmpleado.FechaNacimiento = empleado.FechaNacimiento
                UcEmpleado.SexoEmpleado = "Empleada"

            Else
                lblMsg.Text = mensaje

                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.Table2.Visible = False
            Me.divInfoTutor.Visible = False
            Me.fiedlsetDatos.Visible = False
            Me.spanInfo.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub
    Private Sub bindNovedades()
        ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RT", "R", Me.UsrRNC & Me.UsrCedula)
        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fiedlsetDatos1.Visible = True
        End If
    End Sub
    Protected Sub btnTutor_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTutor.Click
        Try
            Dim mensaje As String = ValidarRegistroTutor(txtCeduNssTutor.Text)

            If mensaje.Equals("OK") Then

                lblMsg.Text = String.Empty

                If txtCeduNssTutor.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(txtCeduNssTutor.Text))
                ElseIf txtCeduNssTutor.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCeduNssTutor.Text)
                End If

                Me.txtCeduNssTutor.ReadOnly = True

                Me.divInfoTutor.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.lblMsg.Text = String.Empty
                Me.lblErrorTutor.Visible = False

                UcInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcInfoEmpleado1.NSS = empleado.NSS.ToString
                UcInfoEmpleado1.Cedula = empleado.Documento
                UcInfoEmpleado1.Sexo = empleado.Sexo
                UcInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                UcInfoEmpleado1.SexoEmpleado = "Nombre Tutor(a)"

            Else
                lblErrorTutor.Text = mensaje

                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False
            End If

        Catch ex As Exception
            Me.lblErrorTutor.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

    End Sub

    Protected Sub btnRegistrar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRegistrar.Click
        Dim m As String = String.Empty
        Me.lblMsg.Text = String.Empty

        Try

            m = RegistroTutor(ViewState("documento").ToString(), Me.UsrRegistroPatronal, Me.txtCeduNssTutor.Text, Me.UsrRNC & Me.UsrCedula)

            Select Case m
                Case "OK"
                    lblMsg2.Text = "Tutor actualizado exitosamente"
                    btnRegistrar.Enabled = False

                    Me.clearControls()

                Case Else
                    Me.lblMsg.Text = m
                    lblMsg2.Text = String.Empty
                    btnRegistrar.Enabled = True

            End Select

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.txtCeduNssTutor.Text = String.Empty
        Me.divInfoTutor.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.txtCeduNssTutor.ReadOnly = False
        Me.txtCeduNssTutor.Focus()
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()

    End Sub
    Private Sub clearControls()
        lblMsg.Text = String.Empty
        Me.txtCedulaNSS.Text = String.Empty
        Me.txtCeduNssTutor.Text = String.Empty
        Me.Table2.Visible = False
        Me.divInfoTutor.Visible = False
        Me.divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.spanInfo.Visible = False
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtCeduNssTutor.ReadOnly = False
        Me.txtCedulaNSS.Focus()
    End Sub
    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
    End Sub
End Class
