Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Partial Class Novedades_sfsMuerteLactante
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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsMuerteLactante.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        Me.txtCedulaNSS.Focus()
        If Page.IsPostBack = False Then
            Me.bindNovedades()
        End If
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.idCiudadano = Me.txtCedulaNSS.Text
        lblMsg.Text = String.Empty
        Try
            Dim mensaje As String = ValidarMuerteLactante(txtCedulaNSS.Text, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty

                Dim madre As Maternidad = Nothing
                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                    madre = New Maternidad(Convert.ToInt32(idCiudadano))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                    madre = New Maternidad(idCiudadano)
                End If

                ViewState("documento") = empleado.Documento

                Me.errorSexo.Visible = False
                Me.errorSta.Visible = False
                Me.errorG.Visible = False
                Me.divConsulta.Visible = True

                If madre.getLactantes().Rows.Count > 0 Then
                    Me.gvLactantes.DataSource = madre.getLactantesVivos()
                    Me.gvLactantes.DataBind()
                    Me.fiedlsetDatos.Visible = True
                End If

                Me.txtCedulaNSS.ReadOnly = True

                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Empleada"

            Else
                lblMsg.Text = mensaje

                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Visible = True
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
        ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "ML", "R", Me.UsrRNC & Me.UsrCedula)
        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fiedlsetDatos1.Visible = True
        End If
    End Sub
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim fechaDefuncion As DateTime
        Dim nacimientoLactante As DateTime
        Dim selecciono As Boolean = False
        Dim vacio As Boolean = True
        Dim m As String = String.Empty
        
        Try
            For Each gvr As GridViewRow In gvLactantes.Rows
                Dim chk As CheckBox = DirectCast(gvr.FindControl("chkbLactante"), CheckBox)
                Dim tb As TextBox = DirectCast(gvr.FindControl("tbFechaDefLact"), TextBox)

                If chk.Checked Then
                    selecciono = True
                End If

                If (Not tb.Text.Equals(String.Empty)) And (vacio = True) Then
                    vacio = False
                End If

            Next

            If Not selecciono Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Debe seleccionar el o los lactantes que fallecieron para poder continuar con el proceso."
                Exit Sub
            ElseIf vacio Then
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = "Debe especificar la fecha de defunción del o los lactantes seleccionados en la lista."
                Exit Sub
            Else
                Me.lblMsg.Visible = False
                Me.lblMsg.Text = String.Empty
            End If

            For Each gvr As GridViewRow In gvLactantes.Rows
                Dim chk As CheckBox = DirectCast(gvr.FindControl("chkbLactante"), CheckBox)
                Dim tb As TextBox = DirectCast(gvr.FindControl("tbFechaDefLact"), TextBox)

                If chk.Checked And (Not tb.Text.Equals(String.Empty)) Then
                    fechaDefuncion = CDate(tb.Text)
                    nacimientoLactante = CDate(gvr.Cells(3).Text)

                    If fechaDefuncion < nacimientoLactante.ToShortDateString() Then
                        Me.lblMsg.Visible = True
                        Me.lblMsg.Text = "la fecha de defuncion debe ser mayor o igual a la" _
                        & "fecha de nacimiento del lactante. La fecha de nacimiento del lactante es :" + " " + nacimientoLactante
                        Exit Sub
                    End If

                    If fechaDefuncion > DateTime.Now Then
                        Me.lblMsg.Visible = True
                        Me.lblMsg.Text = "la fecha de defuncion no puede ser mayor a la fecha del sistema."
                        Exit Sub
                    End If

                    If gvr.Cells(1).Text = "&nbsp;" Or gvr.Cells(1).Text = String.Empty Then
                        gvr.Cells(1).Text = 0
                    End If
                    m = SuirPlus.Empresas.SubsidiosSFS.Maternidad.ReporteMuerteLactante( _
                               ViewState("documento").ToString(), _
                               Me.UsrRegistroPatronal, _
                               Convert.ToInt32(gvr.Cells(1).Text), _
                               Convert.ToInt32(gvr.Cells(0).Text), _
                               Convert.ToDateTime(tb.Text), _
                               Me.UsrRNC & Me.UsrCedula)
                
                End If

            Next

        Catch ex As Exception
            Me.lblMsg.Visible = True
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try

        Select Case m
            Case "OK"
                Me.errorSexo.Visible = False
                Me.errorSta.Visible = False
                Me.clearControls()
                Me.lblMsg.Visible = True
                ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "ML", "R", Me.UsrRNC & Me.UsrCedula)

                If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                    Me.fiedlsetDatos1.Visible = True
                End If

            Case Else
                Me.lblMsg.Visible = True
                Me.lblMsg.Text = m

        End Select

    End Sub
    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()

    End Sub
    Private Sub clearControls()
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.errorG.Visible = False
        Me.txtCedulaNSS.ReadOnly = False
        Me.txtCedulaNSS.Focus()
        lblMsg.Text = String.Empty
    End Sub

    Protected Sub btnCancelar1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar1.Click
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False

    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
    End Sub
End Class
