Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Partial Class Novedades_sfsReporteLicencia
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

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        lblMsg.Text = String.Empty
        Me.idCiudadano = Me.txtCedulaNSS.Text
        Try
            Dim mensaje As String = ValidarReporteLicencia(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then

                lblMsg.Text = String.Empty

                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                End If

                Me.divConsulta.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.txtFeLi.Text = String.Empty

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
                Me.errorSta.Visible = False
                Me.errorSexo.Visible = False
                Me.errorG.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            Me.errorSta.Visible = False
            Me.errorSexo.Visible = False
            Me.errorG.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try
    
    End Sub
    Private Sub bindNovedades()
        ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "LM", "R", Me.UsrRNC & Me.UsrCedula)
        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fiedlsetDatos1.Visible = True
        End If
    End Sub
    Private Sub clearControls()
        lblMsg.Text = String.Empty
        Me.divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.errorG.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtFeLi.Text = String.Empty
        Me.txtCedulaNSS.Focus()
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click

        If Me.txtFeLi.Text > DateTime.Now Then
            Me.errorG.InnerText = "La fecha de licencia introducida no debe ser futura."
            Me.errorG.Visible = True
            Exit Sub
        End If

        Dim m = String.Empty

            'Codigo de insercion de la licencia..
            Try
            m = ReporteLicencia(Me.idCiudadano, Me.UsrRegistroPatronal, Convert.ToDateTime(Me.txtFeLi.Text), Me.UsrRNC & Me.UsrCedula)
            Catch ex As Exception
                Me.errorG.Visible = True
            Me.errorG.InnerText = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

            'verifica el valor que retorna el metodo "registrolicencia"
            Select Case m
                Case "OK"
                    Me.errorG.Visible = False
                    Me.errorSexo.Visible = False
                    Me.errorSta.Visible = False
                    Me.clearControls()
                    ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "LM", "R", Me.UsrRNC & Me.UsrCedula)

                    If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                        Me.fiedlsetDatos1.Visible = True
                    End If

                Case Else
                    Me.errorG.Visible = True
                Me.errorG.InnerText = m
        End Select

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        Me.clearControls()
    End Sub

    Protected Sub btnCancelar1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar1.Click
        
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.errorG.Visible = False
        Me.txtFeLi.Text = String.Empty
        Me.txtFeLi.Focus()
    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)

        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsReporteLicencia.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        Me.txtCedulaNSS.Focus()
        If Page.IsPostBack = False Then
            Me.bindNovedades()
        End If

    End Sub
End Class
