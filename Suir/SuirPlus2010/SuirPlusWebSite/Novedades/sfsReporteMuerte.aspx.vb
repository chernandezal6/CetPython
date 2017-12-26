Imports System.Data
Imports SuirPlus
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsReporteMuerte
    Inherits BasePage

    Protected empleado As Trabajador
    Protected cuentaBancaria As CuentaBancaria
    Private madre As Maternidad

    Private Sub novedades()
        Me.ucGridNovPendientes.bindNovedades(Me.UsrRegistroPatronal, "NV", "MM", "R", Me.UsrRNC & Me.UsrCedula)

        If Me.ucGridNovPendientes.CantidadRecords > 0 Then
            btnAplicar.Visible = True
            fiedlsetDatos1.Visible = True
        End If
    End Sub
    Private Sub getMadre()
        If idCiudadano.Length < 11 Then
            madre = New Maternidad(Convert.ToInt32(idCiudadano))
        ElseIf idCiudadano.Length = 11 Then
            madre = New Maternidad(idCiudadano)
        End If
    End Sub

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idCiudadano") = Value
        End Set
    End Property

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.idCiudadano = txtCedulaNSS.Text
        lblMsg.Text = String.Empty
        Try
            Dim mensaje As String = ValidarMuerteMadre(Me.idCiudadano, UsrRegistroPatronal)

            If mensaje.Equals("OK") Then
                lblMsg.Text = String.Empty

                If idCiudadano.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.idCiudadano))
                ElseIf idCiudadano.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.idCiudadano)
                End If

                UcEmpleado.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcEmpleado.NSS = empleado.NSS.ToString
                UcEmpleado.Cedula = empleado.Documento
                UcEmpleado.Sexo = empleado.Sexo
                UcEmpleado.FechaNacimiento = empleado.FechaNacimiento
                UcEmpleado.SexoEmpleado = "Empleada"

                Me.txtCedulaNSS.ReadOnly = True
                Me.errorG.Visible = False
                Me.divConsulta.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.txtFeLi.Text = String.Empty

                getMadre()
                If madre.getLactantesVivos().Count > 0 Then
                    divMurioLactante.Visible = True
                Else
                    divMurioLactante.Visible = False
                End If

            Else
                lblMsg.Text = mensaje

                Me.divConsulta.Visible = False
                Me.fiedlsetDatos.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try

    End Sub
    Private Sub clearControls()
        lblMsg.Text = String.Empty
        Me.divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
        Me.txtCedulaNSS.Text = String.Empty
        Me.txtCedulaNSS.Enabled = True
        Me.txtCedulaNSS.Focus()
    End Sub

    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Me.errorG.InnerText = String.Empty
        Dim m As String = String.Empty
        Dim l As String = String.Empty
        Dim fechaDefuncion As DateTime
        Dim nacimientoLactante As DateTime
        Dim selecciono As Boolean = False
        Dim vacio As Boolean = True

        Try
            If Me.txtFeLi.Text > DateTime.Now Then
                Me.errorG.Visible = True
                Me.errorG.InnerText = "La fecha de defunción no puede ser mayor a la fecha del sistema."
                Exit Sub
            End If

            m = ReporteMuerteMadre(Me.idCiudadano, Me.UsrRegistroPatronal, Convert.ToDateTime(Me.txtFeLi.Text), Me.UsrRNC & Me.UsrCedula)

            If rblLactantes.SelectedValue = "Si" Then
                'Procedimiento para procesar cada uno de los lactantes seleccionados para reportar su muerte
                '===============================================================================================================
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
                    End If

                    If gvr.Cells(1).Text = "&nbsp;" Or gvr.Cells(1).Text = String.Empty Then
                        gvr.Cells(1).Text = 0
                    End If
                    m = SuirPlus.Empresas.SubsidiosSFS.Maternidad.ReporteMuerteLactante( _
                               Me.txtCedulaNSS.Text, _
                               Me.UsrRegistroPatronal, _
                               Convert.ToInt32(gvr.Cells(1).Text), _
                               Convert.ToInt32(gvr.Cells(0).Text), _
                               Convert.ToDateTime(tb.Text), _
                               Me.UsrRNC & Me.UsrCedula)
                Next
                '===============================================================================================================
            End If

            Select Case m
                Case "OK"
                    Me.clearControls()
                    Me.novedades()
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

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()
        Me.novedades()
    End Sub

    Protected Sub btnCancelar1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar1.Click
        Me.errorG.Visible = False
        Me.errorSexo.Visible = False
        Me.errorSta.Visible = False
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
                Session("urlPostConfirmacion") = "~/Novedades/sfsReporteMuerte.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        Me.txtCedulaNSS.Focus()
        If Page.IsPostBack = False Then
            Me.novedades()
        End If

    End Sub

    Protected Sub rblLactantes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles rblLactantes.SelectedIndexChanged
        If rblLactantes.SelectedValue = "Si" Then
            Me.fieldGrid.Visible = True
            Try
                getMadre()
                gvLactantes.DataSource = madre.getLactantesVivos()
                gvLactantes.DataBind()

            Catch ex As Exception
                Me.errorG.Visible = True
                Me.errorG.InnerText = ex.Message
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try
        Else
            Me.fieldGrid.Visible = False
        End If
    End Sub
End Class
