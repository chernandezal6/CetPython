Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsReporteNacimiento
    Inherits BasePage

#Region "Variables"
    Protected empleado As Trabajador
    Protected cuentaBancaria As CuentaBancaria
    Delegate Sub DelPostConfirmacion()
    Dim madre As Maternidad

    Private Property idCiudadano() As String
        Get
            Return CType(ViewState("idCiudadano"), String)
        End Get
        Set(ByVal Value As String)
            ViewState("idCiudadano") = Value
        End Set
    End Property
#End Region

#Region "Funciones"
    Private Sub clearControls()
        lblMsg.Text = String.Empty
        Me.fiedlsetDatos.Visible = False
        Me.txtFeNac.Text = String.Empty
        txtFeNac.Text = String.Empty
        tbnssLactante.Text = String.Empty
        lblNombreLact.Text = String.Empty
        lblpApellidoLact.Text = String.Empty
        lblsApellidoLact.Text = String.Empty
        lblNUILact.Text = String.Empty
        divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        fiedlsetDatos1.Visible = False
        txtCedulaNSS.Text = String.Empty
        Me.txtCedulaNSS.Focus()
        Me.txtCedulaNSS.Enabled = True
        ViewState("dtLactantes") = Nothing
        Me.readOnlyControls(True)
    End Sub

    Private Sub novedades()
        Me.ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "NC", "R", Me.UsrRNC & Me.UsrCedula)

        If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
            Me.fsNovedades.Visible = True
            btnAplicar.Visible = True
            tbnssLactante.Text = String.Empty
            lblNombreLact.Text = String.Empty
            lblpApellidoLact.Text = String.Empty
            lblsApellidoLact.Text = String.Empty
            lblNUILact.Text = String.Empty
            lblMsg.Text = String.Empty
        Else
            ucGridNovPendientes1.Mensaje = "Ha ocurrido un error, por favor intente nuevamente."
            Me.fsNovedades.Visible = False
            btnAplicar.Visible = False
        End If
    End Sub

    ''' <summary>
    ''' Funcion para poner enable/disable los controles del lactante.
    ''' </summary>
    ''' <param name="con">true para enable, false para disable</param>
    ''' <remarks></remarks>
    Private Sub readOnlyControls(ByVal con As Boolean)
        lblNombreLact.Enabled = con
        lblNUILact.Enabled = con
        lblpApellidoLact.Enabled = con
        lblsApellidoLact.Enabled = con
        ddlSexoLact.Enabled = con
    End Sub
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Si la empresa no tiene una cuenta bancaria asignada, se redirecciona a la pagina de nueva
        'cuenta bancaria
        If Not UsrRegistroPatronal Is Nothing Then
            cuentaBancaria = New SuirPlus.Empresas.CuentaBancaria(CType(UsrRegistroPatronal, Integer))
            If cuentaBancaria.NroCuenta Is Nothing Then

                'Se especifica la pagina desde donde se redireccionó
                Session("urlPostConfirmacion") = "~/Novedades/sfsReporteNacimiento.aspx"
                Response.Redirect("~/Empleador/CtaBancariaNueva.aspx?Novedad=true")

            End If
        End If

        If Not Page.IsPostBack Then
            Me.novedades()

        End If
    End Sub
    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.idCiudadano = Me.txtCedulaNSS.Text
        lblMsg.Text = String.Empty
        divConfirmarNombre.Visible = False
        Dim CantidadLactantes As Int32 = 0
       Try
            Dim mensaje As String = ValidarReporteNacimiento(txtCedulaNSS.Text, UsrRegistroPatronal, CantidadLactantes)

            If mensaje.Equals("OK") Then

                lblMsg.Text = String.Empty

                If Me.txtCedulaNSS.Text.Length < 11 Then
                    empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
                    madre = New Maternidad(CInt(Me.txtCedulaNSS.Text))
                ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                    empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
                    madre = New Maternidad(Me.txtCedulaNSS.Text)
                End If

                If CantidadLactantes = 0 Then
                    ddlLactantes.Enabled = True
                Else
                    ddlLactantes.SelectedValue = CantidadLactantes
                    ddlLactantes.Enabled = False

                    GetLactantes()
                End If

                ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                ucInfoEmpleado1.NSS = empleado.NSS.ToString
                ucInfoEmpleado1.Cedula = empleado.Documento
                ucInfoEmpleado1.Sexo = empleado.Sexo
                ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
                ucInfoEmpleado1.SexoEmpleado = "Empleada"

                Me.readOnlyControls(True)
                Me.novedades()
                Me.txtCedulaNSS.ReadOnly = True

                Me.divConsulta.Visible = True
                Me.dinfoLactante.Visible = True
                Me.fiedlsetDatos.Visible = True
                Me.txtFeNac.Text = String.Empty

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
    Private Sub GetLactantes()

        If madre Is Nothing Then
            If Me.txtCedulaNSS.Text.Length < 11 Then
                madre = New Maternidad(CInt(Me.txtCedulaNSS.Text))
            ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                madre = New Maternidad(Me.txtCedulaNSS.Text)
            End If
        End If

        Me.gvLactantes.DataSource = madre.getLactantesVivos()
        Me.gvLactantes.DataBind()

        If gvLactantes.Rows.Count > 0 Then
            fiedlsetDatos1.Visible = True
        End If

    End Sub
    Private Function CheckNombres() As Boolean

        Dim nombre As String = lblNombreLact.Text.ToUpper + " " + lblpApellidoLact.Text.ToUpper + " " + lblsApellidoLact.Text.ToUpper

        For Each row As GridViewRow In gvLactantes.Rows

            If nombre = row.Cells(0).Text Then

                divConfirmarNombre.Visible = True
                btnInsertLact.Enabled = False
                btnCancelar0.Enabled = False
                Return False

            End If

        Next

        Return True

    End Function

    Protected Sub btnLactante_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLactante.Click
        Dim li As New ListItem
        lblMsg.Text = ""
        divConfirmarNombre.Visible = False
        Try
            Dim tMenor As New Trabajador(Convert.ToInt32(Me.tbnssLactante.Text))

            If tMenor Is Nothing Then
                Throw New Exception("Este lactante no existe.")
            ElseIf tMenor.FechaNacimiento >= Date.Now.AddMonths(3) Then
                Throw New Exception("El lactante digitado no es un recien nacido.")
            Else
                Me.dinfoLactante.Visible = True
                Me.lblNombreLact.Text = tMenor.Nombres
                Me.lblpApellidoLact.Text = tMenor.PrimerApellido
                Me.lblsApellidoLact.Text = tMenor.SegundoApellido

                li = ddlSexoLact.Items.FindByValue(tMenor.Sexo)
                If Not li Is Nothing Then
                    ddlSexoLact.ClearSelection()
                    li.Selected = True
                End If

                Me.readOnlyControls(False)
            End If
        Catch ex As Exception
            Me.readOnlyControls(True)

            lblNombreLact.Text = String.Empty
            lblNUILact.Text = String.Empty
            lblpApellidoLact.Text = String.Empty
            lblsApellidoLact.Text = String.Empty

            lblMsg.Text = ex.Message
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()
    End Sub

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click
        Dim ret As String = Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        Me.lblMsg.ForeColor = Drawing.Color.Blue
        Me.clearControls()
        Me.novedades()

        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")
    End Sub

    Protected Sub btnCancelar0_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar0.Click
        ViewState("dtLactantes") = Nothing
        tbnssLactante.Text = String.Empty
        lblNombreLact.Text = String.Empty
        lblpApellidoLact.Text = String.Empty
        lblsApellidoLact.Text = String.Empty
        lblNUILact.Text = String.Empty
        txtFeNac.Text = String.Empty
    End Sub

    Protected Sub btnInsertLact_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertLact.Click
        lblMsg.Text = ""

        Try

            GetLactantes()

            If CheckNombres() Then
                InsertarLactante()
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
            btnAplicar.Visible = False
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try

    End Sub

    Private Sub InsertarLactante()
        Dim m As String = ""
        Dim nss As Nullable(Of Integer)

        'verificacion de fecha 
        If Convert.ToDateTime(txtFeNac.Text) > DateTime.Now Then
            lblMsg.Text = "La fecha de nacimiento no puede ser mayor a la fecha del sistema."
            btnAplicar.Visible = False
            Exit Sub
        End If

        Dim fecha As DateTime
        If gvLactantes.Rows.Count > 0 Then
            fecha = gvLactantes.Rows(0).Cells(1).Text
        Else
            fecha = txtFeNac.Text
        End If

        If tbnssLactante.Text = String.Empty Then
            nss = 0
        Else
            nss = Convert.ToInt32(tbnssLactante.Text)
        End If

        Dim lactantes As Integer
        If ddlLactantes.Enabled Then
            lactantes = CInt(ddlLactantes.Text)
        Else
            lactantes = 0
        End If

        m = SuirPlus.Empresas.SubsidiosSFS.Maternidad.ReporteNacimiento(txtCedulaNSS.Text, _
                                              Me.UsrRegistroPatronal, _
                                              Convert.ToDateTime(fecha), _
                                              nss, _
                                              lblNombreLact.Text, _
                                              lblpApellidoLact.Text, _
                                              lblsApellidoLact.Text, _
                                              ddlSexoLact.SelectedValue, _
                                              lblNUILact.Text, _
                                              Me.UsrRNC & Me.UsrCedula, _
                                              lactantes)
        Select Case m
            Case "OK"
                Me.novedades()
                fiedlsetDatos.Visible = False
                divConfirmarNombre.Visible = False
                fiedlsetDatos1.Visible = False
            Case Else
                Me.lblMsg.Text = m

        End Select

    End Sub

    Protected Sub btnContinuar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        divConfirmarNombre.Visible = False
        InsertarLactante()
    End Sub

    Protected Sub btnCancelar2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar2.Click
        divConfirmarNombre.Visible = False
        btnCancelar0_Click(sender, e)
        GetLactantes()
        btnInsertLact.Enabled = True
        btnCancelar0.Enabled = True
    End Sub
End Class
