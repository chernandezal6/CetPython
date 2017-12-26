Imports System.Data
Imports SuirPlus.Empresas
Imports SuirPlus.Empresas.SubsidiosSFS
Imports SuirPlus.Utilitarios.Utils
Imports SuirPlus.Empresas.SubsidiosSFS.Maternidad

Partial Class Novedades_sfsCambioNovedad
    Inherits BasePage

    Dim panelActivo As String
    Dim empleada As Trabajador
    Dim madre As Maternidad

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            lblMsg.Text = String.Empty

            pnlEmbarazo.Visible = False
            pnlLicencia.Visible = False
            pnlMuerteMadre.Visible = False
            pnlNacimiento.Visible = False
            pnlMuerteLactante.Visible = False
            pnlPerdidaEmbarazo.Visible = False

            'Evaluar cual Panel mostrar segun el tipo de novedad
            If Not Session("TipoNovedad") = Nothing Then

                Try
                    CargarDatosMadre()
                Catch ex As Exception
                    lblMsg.Text = "Cédula o Nss Inválido"
                    SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                    Exit Sub
                End Try

                Select Case Session("TipoNovedad").ToString()
                    Case "RE"
                        pnlEmbarazo.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "Embarazo"

                        CargarDatosEmbarazo()

                    Case "LM"
                        pnlLicencia.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "Licencia"

                        CargarDatosLicencia()

                    Case "NC"
                        pnlNacimiento.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "Nacimiento"

                        CargarDatosNacimiento()

                    Case "PE"
                        pnlPerdidaEmbarazo.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "PerdidaEmbarazo"

                        CargarDatosPerdidaEmbarazo()

                    Case "MM"
                        pnlMuerteMadre.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "MuerteMadre"

                        CargarDatosMuerteMadre()

                    Case "ML"
                        pnlMuerteLactante.Visible = True
                        pnlGeneral.Visible = True
                        panelActivo = "MuerteLactante"

                        CargarDatosMuerteLactante()

                    Case Else
                        lblMsg.Text = "Ha ocurrido un error, por favor intente nuevamente"

                        pnlEmbarazo.Visible = False
                        pnlLicencia.Visible = False
                        pnlMuerteMadre.Visible = False
                        pnlNacimiento.Visible = False
                        pnlMuerteLactante.Visible = False
                        pnlPerdidaEmbarazo.Visible = False
                End Select

            Else
                lblMsg.Text = "Ha ocurrido un error, por favor intente nuevamente"

            End If
        End If


    End Sub

    Private Sub CargarDatosMadre()

        If Not String.IsNullOrEmpty(Session("idNSS").ToString()) Then

            ShowMovimientos("OK")

            If Session("idNSS").ToString().Length < 11 Then
                empleada = New Trabajador(Convert.ToInt32(Session("idNSS").ToString()))
                madre = New Maternidad(Convert.ToInt32(Session("idNSS").ToString()))
            ElseIf Session("idNSS").ToString().Length = 11 Then
                empleada = New Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, Session("idNSS").ToString())
                madre = New Maternidad(Session("idNSS").ToString())
            End If

            ucInfoEmpleado1.NombreEmpleado = String.Concat(empleada.Nombres, " ", empleada.PrimerApellido, " ", empleada.SegundoApellido)
            ucInfoEmpleado1.NSS = empleada.NSS.ToString
            ucInfoEmpleado1.Cedula = empleada.Documento
            ucInfoEmpleado1.Sexo = empleada.Sexo
            ucInfoEmpleado1.FechaNacimiento = empleada.FechaNacimiento
            ucInfoEmpleado1.SexoEmpleado = "Empleada"

            divMadre.Visible = True

        Else
            divMadre.Visible = False

        End If

    End Sub
    Private Sub CargarDatosEmbarazo()
        If Not madre Is Nothing Then
            lblFechaDiagnostico.Text = IIf(madre.FechaDiagnostico = Nothing, String.Empty, madre.FechaDiagnostico.ToShortDateString)
            lblFechaEstimadaParto.Text = IIf(madre.FechaEstimadaParto = Nothing, String.Empty, madre.FechaEstimadaParto.ToShortDateString)
            lblFechaRegistroEmbarazo.Text = IIf(madre.FechaRegistroRegistroEmbarazo = Nothing, String.Empty, madre.FechaRegistroRegistroEmbarazo.ToShortDateString)

            Try
                Dim empleador As New Empleador(CInt(madre.EmpleadorRegistroEmbarazo))
                lblRazonSocialEmbarazo.Text = ProperCase(empleador.NombreComercial)
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If

    End Sub
    Private Sub CargarDatosLicencia()

        If Not madre Is Nothing Then
            Dim empleador As New Empleador(CInt(madre.EmpleadorRegistroEmbarazo))
            Dim licencia As New DataView

            licencia = getLicenciaEmpleador(madre.Cedula, empleador.RazonSocial)
            lblFechaLicencia.Text = CDate(licencia(0)("FECHA_LICENCIA")).ToShortDateString
            lblFechaRegistroLicencia.Text = CDate(licencia(0)("FECHA_REGISTRO")).ToShortDateString
            lblRazonSocialLicencia.Text = ProperCase(empleador.NombreComercial)

        End If
    End Sub
    Private Sub CargarDatosNacimiento()
        If Not madre Is Nothing Then

            ViewState("secuenciaParto") = madre.SecuenciaParto

            If madre.getLactantes().Rows.Count > 0 Then
                Me.gvNacimientoLactantes.DataSource = madre.getLactantesVivos()
                Me.gvNacimientoLactantes.DataBind()
            End If

        End If
        
    End Sub
    Private Sub CargarDatosPerdidaEmbarazo()
        If Not madre Is Nothing Then
            lblFechaPerdidaEmbarazo.Text = IIf(madre.FechaPerdida = Nothing, String.Empty, madre.FechaPerdida.ToShortDateString)
            lblFechaRegistroPerdida.Text = IIf(madre.FechaRegistroPerdidaEmbarazo = Nothing, String.Empty, madre.FechaRegistroPerdidaEmbarazo.ToShortDateString)

            Try
                Dim empleador As New Empleador(CInt(madre.EmpleadorPerdidaEmbarazo))
                lblRazonSocialPerdida.Text = ProperCase(empleador.NombreComercial)
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If
    End Sub
    Private Sub CargarDatosMuerteMadre()
        If Not madre Is Nothing Then
            lblFechaMuerteMadre.Text = IIf(madre.FechaDefuncionMadre = Nothing, String.Empty, madre.FechaDefuncionMadre.ToShortDateString())
            lblFechaRegistroMuerte.Text = IIf(madre.FechaRegistroMuerteMadre = Nothing, String.Empty, madre.FechaRegistroMuerteMadre.ToShortDateString)

            Try
                Dim empleador As New Empleador(CType(madre.EmpleadorMuerteMadre, Int32))
                lblRazonSocialMuerte.Text = ProperCase(empleador.NombreComercial)
            Catch ex As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

        End If
    End Sub
    Private Sub CargarDatosMuerteLactante()
        If Not madre Is Nothing Then

            ViewState("secuenciaParto") = madre.SecuenciaParto

            If madre.getLactantesFallecidos().Count > 0 Then
                Me.gvMuerteLactantes.DataSource = madre.getLactantesFallecidos()
                Me.gvMuerteLactantes.DataBind()
            End If

        End If
    End Sub
    Protected Sub btnCambiar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCambiar.Click

        Select Case Session("TipoNovedad").ToString()
            Case "RE"
                CambiarReporteEmbarazo()
            Case "LM"
                CambiarReporteLicencia()
            Case "NC"
                CambiarReporteNacimiento()
            Case "PE"
                CambiarReportePerdidaEmbarazo()
            Case "MM"
                CambiarReporteMuerteMadre()
            Case "ML"
                CambiarReporteMuerteLactante()

        End Select

    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelar.Click
        lblMsg.Text = String.Empty
        Session("nss") = Session("idnss")
        Response.Redirect("sfsConsNovedades.aspx")

    End Sub

    Private Sub CambiarReporteEmbarazo()

        lblMsg.Text = String.Empty
        Dim fechaEstimadaParto As Date
        Dim fechaDiagnostico As Date
        Dim fechasCorrectas As Boolean = True

        If Not ((txtFechaDiagnostico.Text.Equals(String.Empty)) And (txtFechaEstimadaParto.Text.Equals(String.Empty))) Then

            If Not (txtFechaDiagnostico.Text.Equals(String.Empty)) Then
                fechasCorrectas = IsFechaFutura(txtFechaDiagnostico, "diagnostico")
                fechaDiagnostico = CDate(txtFechaDiagnostico.Text)
            Else
                fechaDiagnostico = CDate(lblFechaDiagnostico.Text)
            End If

            If Not (txtFechaEstimadaParto.Text.Equals(String.Empty)) Then
                fechaEstimadaParto = CDate(txtFechaEstimadaParto.Text)
            Else
                fechaEstimadaParto = CDate(lblFechaEstimadaParto.Text)
            End If

            If fechasCorrectas Then
                Dim respuestaCambioEmbarazo As String
                respuestaCambioEmbarazo = CambioReporteEmbarazo(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), Me.UsrRegistroPatronal, fechaDiagnostico _
                                                                , fechaEstimadaParto, Me.UsrRNC & Me.UsrCedula)
                ShowMovimientos(respuestaCambioEmbarazo)
            End If

        Else
            lblMsg.Text = "Debe especificar la/s fecha/s para realizar el cambio"
        End If

    End Sub

    Private Sub CambiarReporteLicencia()

        lblMsg.Text = String.Empty
        If Not (txtFechaLicencia.Text.Equals(String.Empty)) Then

            'If IsFechaFutura(txtFechaLicencia, "licencia") Then

            Dim respuestaCambioLicencia As String
            respuestaCambioLicencia = CambioReporteLicencia(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), Me.UsrRegistroPatronal, _
                                                            CDate(txtFechaLicencia.Text), Me.UsrRNC & Me.UsrCedula)
            ShowMovimientos(respuestaCambioLicencia)

            'End If
        End If

    End Sub

    Private Sub CambiarReporteNacimiento()
        lblMsg.Text = "entra"

        Dim respuestaCambioNacimiento As String
        Dim fechaNacimientoText As TextBox = Nothing
        Dim secuencia As Integer

        If IsVacio("tbFechaNacLact", fechaNacimientoText, gvNacimientoLactantes) Then
            Me.lblMsg.Text = "Debe especificar la fecha de defunción del o los lactantes en la lista."
            Exit Sub
        Else
            Me.lblMsg.Text = String.Empty
        End If
        lblMsg.Text = "pasa nacimiento sin fecha"
        'Por cada lactante
        For Each row As GridViewRow In gvNacimientoLactantes.Rows
            lblMsg.Text = "entra al foreach"
            fechaNacimientoText = DirectCast(row.FindControl("tbFechaNacLact"), TextBox)

            If Not fechaNacimientoText.Text.Equals(String.Empty) Then

                If IsFechaFutura(fechaNacimientoText, "nacimiento") Then
                    lblMsg.Text = "entra al loop"
                    secuencia = Convert.ToInt32(row.Cells(0).Text)
                    respuestaCambioNacimiento = CambioReporteNacimiento(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), _
                                                                        Me.UsrRegistroPatronal, Convert.ToDateTime(fechaNacimientoText.Text), _
                                                                        secuencia, Me.UsrRNC & Me.UsrCedula)
                    lblMsg.Text = "pasa cambio"
                    ShowMovimientos(respuestaCambioNacimiento)

                End If
            End If

        Next

    End Sub

    Private Sub CambiarReportePerdidaEmbarazo()

        lblMsg.Text = String.Empty
        If Not (txtFechaPerdidaEmbarazo.Text.Equals(String.Empty)) Then

            If IsFechaFutura(txtFechaPerdidaEmbarazo, "pérdida") Then

                Dim respuestaCambioPerdida As String
                respuestaCambioPerdida = CambioPerdidaEmbarazo(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), _
                                                               Me.UsrRegistroPatronal, Convert.ToDateTime(txtFechaPerdidaEmbarazo.Text), _
                                                               Me.UsrRNC & Me.UsrCedula)
                ShowMovimientos(respuestaCambioPerdida)

            End If

        End If

    End Sub

    Private Sub CambiarReporteMuerteMadre()

        lblMsg.Text = String.Empty

        If Not (txtFechaMuerteMadre.Text.Equals(String.Empty)) Then

            If IsFechaFutura(txtFechaMuerteMadre, "defunción") Then

                Dim respuestaCambioMuerteMadre As String
                respuestaCambioMuerteMadre = CambioReporteMuerteMadre(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), _
                                                                      Me.UsrRegistroPatronal, Convert.ToDateTime(txtFechaMuerteMadre.Text), _
                                                                      Me.UsrRNC & Me.UsrCedula)
                ShowMovimientos(respuestaCambioMuerteMadre)

            End If
        End If
    End Sub

    Private Sub CambiarReporteMuerteLactante()

        Dim respuestaCambioNacimiento As String
        Dim secuencia As Integer
        Dim fechaDefuncionText As TextBox = Nothing
        Dim nacimientoLactante As Date

        If IsVacio("tbFechaDefLact", fechaDefuncionText, gvMuerteLactantes) Then
            Exit Sub
        Else
            Me.lblMsg.Text = String.Empty
        End If

        'Por cada lactante
        For Each row As GridViewRow In gvMuerteLactantes.Rows

            fechaDefuncionText = DirectCast(row.FindControl("tbFechaDefLact"), TextBox)

            If Not fechaDefuncionText.Text.Equals(String.Empty) Then

                nacimientoLactante = CDate(row.Cells(3).Text)

                'Validar fechas suplidas
                If IsFechaFutura(fechaDefuncionText, "defunción") Then

                    If CDate(fechaDefuncionText.Text) < nacimientoLactante.ToShortDateString() Then
                        Exit Sub
                    End If

                    'Procesar la novedad
                    secuencia = Convert.ToInt32(row.Cells(0).Text)
                    respuestaCambioNacimiento = CambioReporteMuerteLactante(ucInfoEmpleado1.Cedula.Replace(CChar("-"), ""), _
                                                                        Me.UsrRegistroPatronal, secuencia, Convert.ToDateTime(fechaDefuncionText.Text), _
                                                                        Me.UsrRNC & Me.UsrCedula)
                    ShowMovimientos(respuestaCambioNacimiento)

                End If

            End If

        Next

    End Sub

    Private Sub ShowMovimientos(ByVal respuesta As String)

        If respuesta.Equals("OK") Then
            ucGridNovPendientes1.bindNovedades(Me.UsrRegistroPatronal, "NV", "RE", "R", Me.UsrRNC & Me.UsrCedula)
            If Me.ucGridNovPendientes1.CantidadRecords > 0 Then
                Me.fsNovedades.Visible = True
            Else
                ucGridNovPendientes1.Mensaje = "Ha ocurrido un error, por favor intente nuevamente."
                ucGridNovPendientes1.Visible = True
            End If
        Else
            lblMsg.Text = respuesta
        End If

    End Sub

    Private Function IsVacio(ByVal textName As String, ByVal textControl As TextBox, ByVal grid As GridView) As Boolean

        'Verificar que se haya suplido la/s fecha/s
        For Each row As GridViewRow In grid.Rows

            textControl = DirectCast(row.FindControl(textName), TextBox)

            If Not textControl.Text.Equals(String.Empty) Then
                Return False
            End If

        Next

        Return True

    End Function

    Private Function IsFechaFutura(ByRef textControl As TextBox, ByVal textName As String) As Boolean

        If Convert.ToDateTime(textControl.Text) >= DateTime.Now Then
            lblMsg.Text = "La fecha de " & textName & " no puede ser futura."
            Return False
        Else
            Return True
        End If

    End Function

    Protected Sub btnAplicar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAplicar.Click

        Dim ret As String = SuirPlus.Empresas.Trabajador.aplicarMovimientos(Me.UsrRegistroPatronal, Me.UsrRNC & Me.UsrCedula)
        Response.Redirect("NovedadesAplicadas.aspx?msg=Novedades aplicadas satisfactoriamente.")

    End Sub
End Class
