Imports System.Data
Imports System.Collections.Generic
Imports SuirPlus.FrameWork
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad
Partial Class Novedades_sfsLactanciaExtraordinario
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
    Private Sub LlenarLactantes(ByVal dt As DataTable)
        'Este metodo se usa para varios casos en el codigo
        ViewState("dtLactantes") = dt
        gvLactantes.DataSource = dt
        gvLactantes.DataBind()

        If gvLactantes.Rows.Count = CInt(ddlLactantes.Text) Then
            btnGuardar.Visible = True
        Else
            btnGuardar.Visible = False
        End If
    End Sub
    Private Sub clearControls()
        lblMsg.Text = String.Empty
        Me.fiedlsetDatos.Visible = False
        Me.txtFechaNacimiento.Text = String.Empty
        txtFechaNacimiento.Text = String.Empty
        tbnssLactante.Text = String.Empty
        lblNombreLact.Text = String.Empty
        lblpApellidoLact.Text = String.Empty
        lblsApellidoLact.Text = String.Empty
        lblNUILact.Text = String.Empty
        divConsulta.Visible = False
        Me.fiedlsetDatos.Visible = False
        txtCedulaNSS.Text = String.Empty
        Me.txtCedulaNSS.Focus()
        ViewState("dtLactantes") = Nothing
        Me.readOnlyControls(True)
        Me.txtCedulaNSS.Enabled = True
    End Sub
    Private Sub readOnlyControls(ByVal con As Boolean)
        lblNombreLact.Enabled = con
        lblNUILact.Enabled = con
        lblpApellidoLact.Enabled = con
        lblsApellidoLact.Enabled = con
        ddlSexoLact.Enabled = con
    End Sub
    Private Function GetLactantes() As Boolean
        If madre Is Nothing Then
            If Me.txtCedulaNSS.Text.Length < 11 Then
                madre = New Maternidad(CInt(Me.txtCedulaNSS.Text))
            ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
                madre = New Maternidad(Me.txtCedulaNSS.Text)
            End If
        End If

        Me.gvLactantesReportados.DataSource = madre.getLactantesVivos()
        Me.gvLactantesReportados.DataBind()

        If Not gvLactantesReportados.DataSource Is Nothing Then
            If gvLactantesReportados.Rows.Count > 0 Then
                Me.divConsulta.Visible = True
                divLactancia.Visible = True
                If String.IsNullOrEmpty(Request.QueryString("NSSconsulta")) Then
                    btnVolver.Visible = False
                Else
                    btnVolver.Visible = True
                End If
                Return True
            Else
                Me.fiedlsetDatos.Visible = False
                btnVolver.Visible = False
                gvLactantesReportados.DataSource = Nothing
                gvLactantesReportados.DataBind()
                Return False
            End If
        Else
            Return True
        End If

    End Function
#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            ViewState("CantidadLactantes") = ddlLactantes.Text

            'Si esta variable de sesion tiene datos, significa que esta pagina se cargo desde la consulta
            'de subsidios extraordinarios, cuando se le da a "ver detalle" para ver los datos de este subsidio en especifico
            If Not (String.IsNullOrEmpty(Request.QueryString("NSSconsulta"))) Then
                txtCedulaNSS.Text = Request.QueryString("NSSconsulta").ToString()
                btnConsultar_Click(sender, e)
                fiedlsetDatos.Visible = False
            Else
                'Si esta variable de sesion tiene datos es porque viene desde la pagina de confirmacion, y desde alla
                'se le dio a "volver" y se deben cargar los mismos datos que tenia previamente
                If Not (String.IsNullOrEmpty(Request.QueryString("NSS"))) Then
                    ucInfoEmpleado1.NombreEmpleado = Request.QueryString("NombreEmpleado").ToString
                    ucInfoEmpleado1.NSS = Request.QueryString("NSS").ToString
                    ucInfoEmpleado1.Cedula = Request.QueryString("Cedula").ToString.Replace("-", "")
                    ucInfoEmpleado1.Sexo = Request.QueryString("Sexo").ToString
                    ucInfoEmpleado1.FechaNacimiento = Request.QueryString("FechaNacimiento").ToString
                    ddlLactantes.Text = Request.QueryString("Cantidad").ToString
                    txtFechaNacimiento.Text = Request.QueryString("FechaNacimientoLactante").ToString
                    txtCedulaNSS.Text = Request.QueryString("Cedula").ToString.Replace("-", "")

                    Try
                        If Not Session("dtLactantes") Is Nothing Then

                            Dim dt As DataTable = CType(Session("dtLactantes"), DataTable)
                            LlenarLactantes(dt)
                            Session("dtLactantes") = Nothing
                        End If

                    Catch ex As Exception
                        lblMsg.Text = "Ocurrió un error cargando los datos, por favor intente nuevamente"
                        Exit Sub
                    End Try

                    Me.divConsulta.Visible = True
                    Me.dinfoLactante.Visible = True
                    Me.fiedlsetDatos.Visible = True
                    divLactancia.Visible = True
                End If
            End If
        End If
    End Sub
    Private Sub PoblarControlEmpleado()
        If Me.txtCedulaNSS.Text.Length < 11 Then
            empleado = New Trabajador(Convert.ToInt32(Me.txtCedulaNSS.Text))
            madre = New Maternidad(CInt(Me.txtCedulaNSS.Text))
        ElseIf Me.txtCedulaNSS.Text.Length = 11 Then
            empleado = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Me.txtCedulaNSS.Text)
            madre = New Maternidad(Me.txtCedulaNSS.Text)
        End If

        ucInfoEmpleado1.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
        ucInfoEmpleado1.NSS = empleado.NSS.ToString
        ucInfoEmpleado1.Cedula = empleado.Documento
        ucInfoEmpleado1.Sexo = empleado.Sexo
        ucInfoEmpleado1.FechaNacimiento = empleado.FechaNacimiento
        ucInfoEmpleado1.SexoEmpleado = "Empleada"
    End Sub

    Protected Sub btnConsultar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnConsultar.Click
        Me.idCiudadano = Me.txtCedulaNSS.Text
        lblMsg.Text = String.Empty
        divConfirmarNombre.Visible = False
        btnVolver.Visible = False
        gvLactantesReportados.DataBind()
        ddlLactantes.Enabled = True
        ddlLactantes.Text = 1

        Dim CantidadLactantes As String = String.Empty
        Try
            Dim mensaje As String = ValidarReporteNacimiento(txtCedulaNSS.Text, 0, CantidadLactantes)

            If mensaje.Equals("No se ha registrado embarazo con anterioridad para esta empleada") Then
                PoblarControlEmpleado()
                divEmbarazo.Visible = True
                divConsulta.Visible = True
                divLactancia.Visible = False
            Else
                If mensaje.Equals("Trabajador no esta activo para esta nómina.") Or mensaje.Equals("Las novedades de esta afiliada estan siendo manejadas por la Sisalril.") Then

                    lblMsg.Text = String.Empty

                    PoblarControlEmpleado()

                    Session("RegistroPatronal") = madre.EmpleadorRegistroEmbarazo

                    If CantidadLactantes = "0" Then
                        ddlLactantes.Enabled = True
                        gvLactantesReportados.DataSource = Nothing
                        gvLactantesReportados.DataBind()
                    Else
                        ddlLactantes.SelectedValue = CantidadLactantes
                        ddlLactantes.Enabled = False

                        If GetLactantes() Then
                            Exit Sub
                        End If

                    End If

                    Me.readOnlyControls(True)
                    Me.txtCedulaNSS.ReadOnly = True

                    Me.divConsulta.Visible = True
                    Me.dinfoLactante.Visible = True
                    Me.fiedlsetDatos.Visible = True
                    divLactancia.Visible = True
                    Me.txtFechaNacimiento.Text = String.Empty

                Else
                    lblMsg.Text = mensaje

                    Me.divConsulta.Visible = False
                    Me.fiedlsetDatos.Visible = False
                    gvLactantesReportados.DataSource = Nothing
                    gvLactantesReportados.DataBind()
                End If
            End If
           
        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            Me.divConsulta.Visible = False
            Me.fiedlsetDatos.Visible = False
            gvLactantesReportados.DataSource = Nothing
            gvLactantesReportados.DataBind()
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())

        End Try

    End Sub

    Protected Sub btnInsertLact_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsertLact.Click
        lblMsg.Text = String.Empty
        Dim cantidad As Integer = 0
        Dim dt As New Data.DataTable

        Dim col As New DataColumn("NSS", GetType(String))
        dt.Columns.Add(col)
        col = New DataColumn("Nombres", GetType(String))
        dt.Columns.Add(col)
        col = New DataColumn("PrimerApellido", GetType(String))
        dt.Columns.Add(col)
        col = New DataColumn("SegundoApellido", GetType(String))
        dt.Columns.Add(col)
        col = New DataColumn("Sexo", GetType(String))
        dt.Columns.Add(col)
        col = New DataColumn("NUI", GetType(String))
        dt.Columns.Add(col)

        If Not ViewState("dtLactantes") Is Nothing Then
            dt = ViewState("dtLactantes")
        End If
        If Not ViewState("CantidadLactantes") Is Nothing Then
            cantidad = CType(ViewState("CantidadLactantes"), Integer)
        End If
        'verificar cantidad de lactantes
        If dt.Rows.Count < cantidad Then
            Try
                For Each dt2 As DataRow In dt.Rows
                    If Not tbnssLactante.Text = String.Empty Then
                        If tbnssLactante.Text = dt2("NSS") Then
                            Throw New Exception("No puede insertar el mismo lactante.")
                        End If
                    End If
                Next

                Dim dr As Data.DataRow
                dr = dt.NewRow

                dr("NSS") = tbnssLactante.Text
                dr("Nombres") = lblNombreLact.Text
                dr("PrimerApellido") = lblpApellidoLact.Text
                dr("SegundoApellido") = lblsApellidoLact.Text
                dr("Sexo") = ddlSexoLact.SelectedValue
                dr("NUI") = lblNUILact.Text

                dt.Rows.Add(dr)
                LlenarLactantes(dt)

                Me.readOnlyControls(True)

                tbnssLactante.Text = String.Empty
                lblNombreLact.Text = String.Empty
                lblpApellidoLact.Text = String.Empty
                lblsApellidoLact.Text = String.Empty
                lblNUILact.Text = String.Empty

                lblNombreLact.Focus()

            Catch ex As Exception
                Dim err As String()
                err = ex.Message.Split("|")
                lblMsg.Text = err(0)
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try
        Else
            lblMsg.Text = "Ha excedido la cantidad de lactantes espedificada"
        End If
    End Sub

    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGuardar.Click
        Session("dtLactantes") = ViewState("dtLactantes")
        Response.Redirect("~/Novedades/sfsConfirmacionLactancia.aspx?NombreEmpleado=" & ucInfoEmpleado1.NombreEmpleado & "&NSS=" & ucInfoEmpleado1.NSS & "&Cedula=" & ucInfoEmpleado1.Cedula & "&Sexo=" & ucInfoEmpleado1.Sexo & "&FechaNacimiento=" & ucInfoEmpleado1.FechaNacimiento & "&Cantidad=" & ddlLactantes.Text & "&FechaNacimientoLactante=" & txtFechaNacimiento.Text)

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        Me.clearControls()
    End Sub

    Protected Sub btnContinuar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnContinuar.Click
        btnInsertLact_Click(sender, e)
    End Sub

    Protected Sub ddlLactantes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlLactantes.SelectedIndexChanged
        ViewState("CantidadLactantes") = ddlLactantes.Text
        If gvLactantes.Rows.Count = CInt(ddlLactantes.Text) Then
            btnGuardar.Visible = True
        Else
            btnGuardar.Visible = False
        End If
    End Sub

    Protected Sub btnCancelar2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar2.Click
        divConfirmarNombre.Visible = False
        Me.clearControls()
    End Sub

    Protected Sub gvLactantes_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles gvLactantes.SelectedIndexChanged
        Try
            Dim dt As New Data.DataTable
            If Not ViewState("dtLactantes") Is Nothing Then
                dt = ViewState("dtLactantes")

                dt.Rows.Remove(dt.Rows(gvLactantes.SelectedIndex))
                LlenarLactantes(dt)

            End If

        Catch ex As Exception

        End Try
    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnVolver.Click
        Try
            Response.Redirect("~/Novedades/sfsConsnovedadesExt.aspx?desde=" & Request.QueryString("desde").ToString & "&hasta=" & Request.QueryString("hasta").ToString & "&tipo=" & Request.QueryString("tipo").ToString & "&NSSconsulta=" & Request.QueryString("NSSconsulta").ToString & "&RNC=" & Request.QueryString("RNC").ToString & "&RegistroPatronal=" & Request.QueryString("RegistroPatronal").ToString)
        Catch
        End Try

    End Sub

    Protected Sub btnEmbarazo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEmbarazo.Click
        'Insertar un embarazo aplicandolo como un chinazo, y si se aplica, ensenar el div de lactancia
        'sino, mostrar error
        Dim m As String = String.Empty
        m = RegistroEmbarazoLactanciaExt(txtCedulaNSS.Text, Convert.ToDateTime(Me.txtFeDiagno.Text), Convert.ToDateTime(Me.txtFeParto.Text), txtCeduNssTutor.Text, txtTelefono.Text, txtCelular.Text, txtEmail.Text, Me.UsrUserName)

            Select m
            Case "OK"
                divEmbarazo.Visible = False
                divLactancia.Visible = True
                Me.divConsulta.Visible = True
                Me.dinfoLactante.Visible = True
                Me.fiedlsetDatos.Visible = True
                divLactancia.Visible = True
            Case Else
                lblMsg.Text = m
        End Select

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

                Me.divInfoTutor.Visible = True
                UcInfoEmpleado2.NombreEmpleado = String.Concat(empleado.Nombres, " ", empleado.PrimerApellido, " ", empleado.SegundoApellido)
                UcInfoEmpleado2.NSS = empleado.NSS.ToString
                UcInfoEmpleado2.Cedula = empleado.Documento
                UcInfoEmpleado2.Sexo = empleado.Sexo
                UcInfoEmpleado2.FechaNacimiento = empleado.FechaNacimiento
                UcInfoEmpleado2.SexoEmpleado = "Nombre Tutor(a)"

            Else
                lblMsg.Text = mensaje
                Me.divInfoTutor.Visible = False

            End If

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

    End Sub
End Class
